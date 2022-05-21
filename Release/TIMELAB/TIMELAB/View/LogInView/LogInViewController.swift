//
//  LogInViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/10.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import PKHUD

class LogInViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var logInViewModel: LogInViewModel!
    var isProgressView  = false
    
    // MARK: - UI Parts
    var introductionLabel: LogInLabel!
    var introductionUIImageView: LogInUIImageView!
    var emailLabel: LogInLabel!
    var emailTextField: LogInTextField!
    var validateEmailLabel: LogInLabel!
    var passwordLabel: LogInLabel!
    var passwordAttentionLabel: LogInLabel!
    var passwordTextField: LogInTextField!
    var passwordSceretButton: LogInSecretButton!
    var validatePasswordLabel: LogInLabel!
    var forgetPasswordLabel: LogInLabel!
    var logInButton: LogInButton!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBinding()
    }
    
    // MARK: - Function
    private func setupLayout() {
        self.view.backgroundColor = .white
        
        let width = view.bounds.width
        let height = view.bounds.height
        
        introductionLabel = LogInLabel(text: "ログイン", size: 30)
        introductionUIImageView = LogInUIImageView(name: "DiscussionWomanAndMan")
        emailLabel = LogInLabel(text: "メールアドレス", size: 18)
        emailTextField = LogInTextField(placeholder: "", isSecretButton: false)
        validateEmailLabel = LogInLabel(text: "", size: 10)
        passwordLabel = LogInLabel(text: "パスワード入力", size: 18)
        passwordAttentionLabel = LogInLabel(text: "(小文字英数字8文字以上)", size: 10)
        passwordTextField = LogInTextField(placeholder: "", isSecretButton: true)
        passwordTextField.isSecureTextEntry = true
        passwordSceretButton = LogInSecretButton(imageSize: CGSize(width: 18, height: 18))
        validatePasswordLabel = LogInLabel(text: "", size: 10)
        forgetPasswordLabel = LogInLabel(text: "パスワードを忘れた？", size: 13, textColor: Color.gray.UIColor)
//        forgetPasswordLabel.underLine(color: Color.gray.UIColor, thickness: 1)   // SnapKit でレイアウトしているため使用できない
        
        logInButton = LogInButton(text: "ログイン", textSize: 15)
        
        let logInTextFieldVerticalView = setupLogInTextFieldVerticalView()
        let introductionHorizontal = UIStackView(arrangedSubviews: [introductionLabel, introductionUIImageView])
        introductionHorizontal.axis = .horizontal
        introductionHorizontal.spacing = 5
        
        // MARK: - addSubview/layer
        view.addSubview(logInTextFieldVerticalView)
        logInTextFieldVerticalView.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.centerY.equalTo(view.bounds.height * 0.55)
        }
        view.addSubview(forgetPasswordLabel)
        forgetPasswordLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(logInTextFieldVerticalView.snp.bottom).offset(5)
            make.right.equalTo(logInTextFieldVerticalView.snp.right)
        }
        
        // 左端の座標を logInVerticalView に合わせるため、logInVerticalView より後に描画
        view.addSubview(introductionHorizontal)
        introductionHorizontal.snp.makeConstraints { make -> Void in
            make.bottom.equalTo(logInTextFieldVerticalView.snp.top).offset(-30)
            make.left.equalTo(logInTextFieldVerticalView.snp.left)
        }
        introductionUIImageView.snp.makeConstraints { make -> Void in
            make.width.equalTo(190)
            make.height.equalTo(142)
        }
        
        view.addSubview(logInButton)
        logInButton.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.top.equalTo(logInTextFieldVerticalView.snp.bottom).offset(55)
        }
        
        view.addSubview(passwordSceretButton)
        passwordSceretButton.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(passwordTextField.snp.centerY)
            make.right.equalTo(logInTextFieldVerticalView.snp.right).offset(-10)
        }
        
    }
    
    func setupLogInTextFieldVerticalView() -> UIStackView {
        let emailVerticalView = UIStackView(arrangedSubviews: [emailLabel, emailTextField, validateEmailLabel])
        emailVerticalView.axis = .vertical
        emailVerticalView.spacing = 5
        let passwordHorizontalView = UIStackView(arrangedSubviews: [passwordLabel, passwordAttentionLabel, UIView()])   // PasswordAttentionLabel を左詰めにするため、UIView() を使用
        passwordHorizontalView.axis = .horizontal
        passwordHorizontalView.spacing = 5
        let passwordVerticalView = UIStackView(arrangedSubviews: [passwordHorizontalView, passwordTextField, validatePasswordLabel])
        passwordVerticalView.axis = .vertical
        passwordVerticalView.spacing = 5
        
        let logInTextFieldVerticalView = UIStackView(arrangedSubviews: [emailVerticalView, passwordVerticalView])
        logInTextFieldVerticalView.axis = .vertical
//        logInVerticalView.distribution = .fillEqually   // 要素の大きさを均等にする
        logInTextFieldVerticalView.spacing = 40
        
        return logInTextFieldVerticalView
    }
    
    private func setupBinding() {
        
        // VM との繋がり, ログイン実装
        logInViewModel = LogInViewModel(
            input: (email: emailTextField.rx.text.orEmpty.asDriver(),
                    password: passwordTextField.rx.text.orEmpty.asDriver(),
                    logInButtonTaps: logInButton.rx.tap.asSignal()),
            logInAPI: LogInModel())
        
        logInViewModel.logInResult
            .drive { result in
                print("ログインの実行結果: ", result)
                if result && self.isProgressView {
                    HUD.hide()
                    self.isProgressView = false
                    // push画面遷移
//                    let tabBarViewController = TabBarViewController()
//                    self.navigationController?.pushViewController(tabBarViewController, animated: true)
                } else {
                    HUD.flash(.error, delay: 1) { _ in }
                }
            }
            .disposed(by: disposeBag)
        
        // 背景をタップしたらキーボードを隠す
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)
        
        logInButton.rx.tap
            .subscribe { _ in
                HUD.show(.progress)   // ローディング表示
                self.isProgressView = true
                // TODO: ボタン 選択/非選択プログラム を簡略化, 簡略化可能かどうかから考える
                self.logInButton.isSelected = !self.logInButton.isSelected
                self.logInButton.backgroundColor = self.logInButton.isSelected ? Color.lightGray.UIColor : Color.navyBlue.UIColor
            }
            .disposed(by: disposeBag)
        
        // パスワード表示/非表示
        passwordSceretButton.rx.tap
            .subscribe { _ in
                self.passwordSceretButton.isSelected = !self.passwordSceretButton.isSelected
                self.passwordTextField.isSecureTextEntry = !self.passwordTextField.isSecureTextEntry
            }
            .disposed(by: disposeBag)
        
    }
}

