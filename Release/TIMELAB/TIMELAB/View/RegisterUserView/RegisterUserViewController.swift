//
//  RegisterUserViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/07.
//

// TODO: ボタン や 画像 等の大きさをどこで指定するか, iPadに対応させるために ViewController で指定するのが良い？

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import PKHUD

class RegisterUserViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var registerUserViewModel: RegisterUserViewModel!
    var isProgressView  = false
    
    // MARK: - UI Parts
    var introductionLabel: RegisterLabel!
    var nameLabel: RegisterLabel!
    var nameTextField: RegisterTextField!
    var validateNameLabel: RegisterLabel!
    var emailLabel: RegisterLabel!
    var emailTextField: RegisterTextField!
    var validateEmailLabel: RegisterLabel!
    var passwordLabel: RegisterLabel!
    var passwordAttentionLabel: RegisterLabel!
    var passwordTextField: RegisterTextField!
    var passwordSecretButton: RegisterSecretButton!
    var validatePasswordLabel: RegisterLabel!
    var passwordConfirmLabel: RegisterLabel!
    var passwordConfirmTextField: RegisterTextField!
    var passwordConfirmSecretButton: RegisterSecretButton!
    var validatePasswordConfirmLabel: RegisterLabel!
    var registerButton: RegisterButton!
    
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
        
        introductionLabel = RegisterLabel(text: "アカウントの作成", size: 30)
        nameLabel = RegisterLabel(text: "名前", size: 18)
        nameTextField = RegisterTextField(placeholder: "", isSecretButton: false)
        validateNameLabel = RegisterLabel(text: "", size: 13)
        emailLabel = RegisterLabel(text: "メールアドレス", size: 18)
        emailTextField = RegisterTextField(placeholder: "", isSecretButton: false)
        validateEmailLabel = RegisterLabel(text: "", size: 13)
        passwordLabel = RegisterLabel(text: "パスワード入力", size: 18)
        passwordAttentionLabel = RegisterLabel(text: "(小文字英数字8文字以上)", size: 10)
        passwordTextField = RegisterTextField(placeholder: "", isSecretButton: true)
        passwordTextField.isSecureTextEntry = true
        passwordSecretButton = RegisterSecretButton(imageSize: CGSize(width: 18, height: 18))
        validatePasswordLabel = RegisterLabel(text: "", size: 13)
        passwordConfirmLabel = RegisterLabel(text: "パスワード再入力", size: 18)
        passwordConfirmTextField = RegisterTextField(placeholder: "", isSecretButton: true)
        passwordConfirmTextField.isSecureTextEntry = true
        passwordConfirmSecretButton = RegisterSecretButton(imageSize: CGSize(width: 18, height: 18))
        validatePasswordConfirmLabel = RegisterLabel(text: "", size: 13)
        
        registerButton = RegisterButton(text: "アカウントを作成する", textSize: 15)
        
        let registerVerticalView = setupRegisterVerticalView()
        
        // MARK: - addSubview/layer
        view.addSubview(registerVerticalView)
        registerVerticalView.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width / 2)
            make.top.equalTo(view.bounds.height * 0.15)
        }
        
        view.addSubview(registerButton)
        registerButton.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.top.equalTo(registerVerticalView.snp.bottom).offset(55)
        }
        
        view.addSubview(passwordSecretButton)
        passwordSecretButton.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(passwordTextField.snp.centerY)
            make.right.equalTo(passwordTextField.snp.right).offset(-10)
        }
        
        view.addSubview(passwordConfirmSecretButton)
        passwordConfirmSecretButton.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(passwordConfirmTextField.snp.centerY)
            make.right.equalTo(passwordConfirmTextField.snp.right).offset(-10)
        }
        
    }
    
    func setupRegisterVerticalView() -> UIStackView {
        // 名前
        let nameVerticalView = UIStackView(arrangedSubviews: [nameLabel, nameTextField])
        nameVerticalView.axis = .vertical
        nameVerticalView.spacing = 5
        let nameHorizontalView = UIStackView(arrangedSubviews: [nameVerticalView, validateNameLabel])
        nameHorizontalView.axis = .horizontal
        nameHorizontalView.spacing = 5
        
        // メールアドレス
        let emailVerticalView = UIStackView(arrangedSubviews: [emailLabel, emailTextField])
        emailVerticalView.axis = .vertical
        emailVerticalView.spacing = 5
        let emailHorizontalView = UIStackView(arrangedSubviews: [emailVerticalView, validateEmailLabel])
        emailHorizontalView.axis = .horizontal
        emailHorizontalView.spacing = 5
        
        // パスワード
        let passwordAttentionHorizontalView = UIStackView(arrangedSubviews: [passwordLabel, passwordAttentionLabel, UIView()])   // PasswordAttentionLabel を左詰めにするため、UIView() を使用
        passwordAttentionHorizontalView.axis = .horizontal
        passwordAttentionHorizontalView.spacing = 5
        let passwordVerticalView = UIStackView(arrangedSubviews: [passwordAttentionHorizontalView, passwordTextField])
        passwordVerticalView.axis = .vertical
        passwordVerticalView.spacing = 5
        let passwordHorizontalView = UIStackView(arrangedSubviews: [passwordVerticalView, validatePasswordLabel])
        passwordHorizontalView.axis = .horizontal
        passwordHorizontalView.spacing = 5
        
        // パスワード確認
        let passwordConfirmVerticalView = UIStackView(arrangedSubviews: [passwordConfirmLabel, passwordConfirmTextField])
        passwordConfirmVerticalView.axis = .vertical
        passwordConfirmVerticalView.spacing = 5
        let passwordConfirmHorizontalView = UIStackView(arrangedSubviews: [passwordConfirmVerticalView, validatePasswordConfirmLabel])
        passwordConfirmHorizontalView.axis = .horizontal
        passwordConfirmHorizontalView.spacing = 5
        
        // 全体
        let registerVerticalView = UIStackView(arrangedSubviews: [introductionLabel, nameHorizontalView, emailHorizontalView, passwordHorizontalView, passwordConfirmHorizontalView])
        registerVerticalView.axis = .vertical
        registerVerticalView.distribution = .fillEqually   // 要素の大きさを均等にする
        registerVerticalView.spacing = 20
        
        return registerVerticalView
    }
    
    private func setupBinding() {
        
        // VM とのつながり, input にイベントを送る(テキストの変更やボタンのタップ等), 送るだけ, 登録のようなイメージ
        registerUserViewModel = RegisterUserViewModel(input: (
            name: nameTextField.rx.text.orEmpty.asDriver(),
            email: emailTextField.rx.text.orEmpty.asDriver(),
            password: passwordTextField.rx.text.orEmpty.asDriver(),
            passwordConfirm: passwordConfirmTextField.rx.text.orEmpty.asDriver(),
            signUpTaps: registerButton.rx.tap.asSignal()   // ボタンのタップには Single を使用する
        ), signUpAPI: RegisterUserModel())

        // MV からデータ受け取る, データの値を変更
        registerUserViewModel.nameValidation
            .drive(validateNameLabel.rx.validationResult)   // VM で 戻り値を ValidationResult にしているため,受け取りもvalidationResultにする, Rective の extension を実装する必要あり
            .disposed(by: disposeBag)

        registerUserViewModel.emailValidation
            .drive(validateEmailLabel.rx.validationResult)
            .disposed(by: disposeBag)

        registerUserViewModel.passwordValidation
            .drive(validatePasswordLabel.rx.validationResult)
            .disposed(by: disposeBag)

        registerUserViewModel.passwordConfirmValidation
            .drive(validatePasswordConfirmLabel.rx.validationResult)
            .disposed(by: disposeBag)
        
        registerButton.rx.tap
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                Task {
                    do {
                        try await self.registerUserViewModel.sendSignInLinks(email: self.emailTextField.text!, password: self.passwordTextField.text!)
                        HUD.hide()
                        // push画面遷移
                        let pleaseConfirmEmailViewController = PleaseConfirmEmailViewController()
                        self.navigationController?.pushViewController(pleaseConfirmEmailViewController, animated: true)
                    } catch {
                        self.resetLayout()
                        HUD.flash(.error, delay: 1.0)
                        print("Error sendSignInLinks")
                    }
                }
            }
            .disposed(by: disposeBag)
        
        registerUserViewModel.sendSignInLinks
            .subscribe { _ in
                print("メール送信 成功")
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
        
        registerButton.rx.tap
            .subscribe { _ in
                HUD.show(.progress)   // ローディング表示
                self.isProgressView = true
                self.registerButton.isSelected = !self.registerButton.isSelected
                self.registerButton.backgroundColor = self.registerButton.isSelected ? Color.lightGray.UIColor : Color.navyBlue.UIColor
            }
            .disposed(by: disposeBag)
        
        // パスワード表示/非表示
        passwordSecretButton.rx.tap
            .subscribe { _ in
                self.passwordSecretButton.isSelected = !self.passwordSecretButton.isSelected
                self.passwordTextField.isSecureTextEntry = !self.passwordTextField.isSecureTextEntry
            }
            .disposed(by: disposeBag)
        
        passwordConfirmSecretButton.rx.tap
            .subscribe { _ in
                self.passwordConfirmSecretButton.isSelected = !self.passwordConfirmSecretButton.isSelected
                self.passwordConfirmTextField.isSecureTextEntry = !self.passwordConfirmTextField.isSecureTextEntry
            }
            .disposed(by: disposeBag)
        
    }
    
    func resetLayout() {
        self.nameTextField.text = ""
        self.validateNameLabel.text = "※ "
        self.validateNameLabel.textColor = Color.navyBlue.UIColor
        self.emailTextField.text = ""
        self.validateEmailLabel.text = "※ "
        self.validateEmailLabel.textColor = Color.navyBlue.UIColor
        self.passwordTextField.text = ""
        self.validatePasswordLabel.text = "※ "
        self.validatePasswordLabel.textColor = Color.navyBlue.UIColor
        self.passwordConfirmTextField.text = ""
        self.validatePasswordConfirmLabel.text = "※ "
        self.validatePasswordConfirmLabel.textColor = Color.navyBlue.UIColor
        self.registerButton.isSelected = false
        self.registerButton.isEnabled = false
    }
}
