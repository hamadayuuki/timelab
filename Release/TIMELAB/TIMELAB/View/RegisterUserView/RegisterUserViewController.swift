//
//  RegisterUserViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/07.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import PKHUD

class RegisterUserViewController: UIViewController {
    
    // UI Parts
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
    var passwordSceretButton: RegisterSecretButton!
    var validatePasswordLabel: RegisterLabel!
    var passwordConfirmLabel: RegisterLabel!
    var passwordConfirmTextField: RegisterTextField!
    var passwordConfirmSceretButton: RegisterSecretButton!
    var validatePasswordConfirmLabel: RegisterLabel!
    var registerButton: RegisterButton!
    
    let disposeBag = DisposeBag()
    
//    var registerUserViewModel: RegisterUserViewModel!
    
    var isProgressView  = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBinding()
    }
    
    private func setupLayout() {
        self.view.backgroundColor = .white
        
        let width = view.bounds.width
        let height = view.bounds.height
        
        introductionLabel = RegisterLabel(text: "アカウントの作成", size: 30)
        nameLabel = RegisterLabel(text: "名前", size: 18)
        nameTextField = RegisterTextField(placeholder: "", isSecretButton: false)
        validateNameLabel = RegisterLabel(text: "", size: 10)
        emailLabel = RegisterLabel(text: "メールアドレス", size: 18)
        emailTextField = RegisterTextField(placeholder: "", isSecretButton: false)
        validateEmailLabel = RegisterLabel(text: "", size: 10)
        passwordLabel = RegisterLabel(text: "パスワード入力", size: 18)
        passwordAttentionLabel = RegisterLabel(text: "(小文字英数字8文字以上)", size: 10)
        passwordTextField = RegisterTextField(placeholder: "", isSecretButton: true)
        passwordTextField.isSecureTextEntry = true
        passwordSceretButton = RegisterSecretButton(imageSize: CGSize(width: 18, height: 18))
        validatePasswordLabel = RegisterLabel(text: "", size: 10)
        passwordConfirmLabel = RegisterLabel(text: "パスワード再入力", size: 18)
        passwordConfirmTextField = RegisterTextField(placeholder: "", isSecretButton: true)
        passwordConfirmTextField.isSecureTextEntry = true
        passwordConfirmSceretButton = RegisterSecretButton(imageSize: CGSize(width: 18, height: 18))
        validatePasswordConfirmLabel = RegisterLabel(text: "", size: 10)
        
        registerButton = RegisterButton()
        
        let nameVerticalView = UIStackView(arrangedSubviews: [nameLabel, nameTextField, validateNameLabel])
        nameVerticalView.axis = .vertical
        nameVerticalView.spacing = 5
        let emailVerticalView = UIStackView(arrangedSubviews: [emailLabel, emailTextField, validateEmailLabel])
        emailVerticalView.axis = .vertical
        emailVerticalView.spacing = 5
        let passwordHorizontalView = UIStackView(arrangedSubviews: [passwordLabel, passwordAttentionLabel, UIView()])   // PasswordAttentionLabel を左詰めにするため、UIView() を使用
        passwordHorizontalView.axis = .horizontal
        passwordHorizontalView.spacing = 5
        let passwordVerticalView = UIStackView(arrangedSubviews: [passwordHorizontalView, passwordTextField, validatePasswordLabel])
        passwordVerticalView.axis = .vertical
        passwordVerticalView.spacing = 5
        let passwordConfirmVerticalView = UIStackView(arrangedSubviews: [passwordConfirmLabel, passwordConfirmTextField, validatePasswordConfirmLabel])
        passwordConfirmVerticalView.axis = .vertical
        passwordConfirmVerticalView.spacing = 5
        
        let registerVerticalView = UIStackView(arrangedSubviews: [introductionLabel, nameVerticalView, emailVerticalView, passwordVerticalView, passwordConfirmVerticalView])
        registerVerticalView.axis = .vertical
        registerVerticalView.distribution = .fillEqually   // 要素の大きさを均等にする
        registerVerticalView.spacing = 20
        
        view.addSubview(registerVerticalView)
        registerVerticalView.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width / 2)
            make.top.equalTo(view.bounds.height * 0.15)
        }
        
        view.addSubview(registerButton)
        registerButton.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width / 2)
            make.top.equalTo(registerVerticalView.snp.bottom).offset(50)
            make.width.equalTo(210)
            make.height.equalTo(60)
        }
        
        view.addSubview(passwordSceretButton)
        passwordSceretButton.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(passwordTextField.snp.centerY)
            make.right.equalTo(registerVerticalView.snp.right).offset(-10)
        }
        
        view.addSubview(passwordConfirmSceretButton)
        passwordConfirmSceretButton.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(passwordConfirmTextField.snp.centerY)
            make.right.equalTo(registerVerticalView.snp.right).offset(-10)
        }
        
    }
    
    private func setupBinding() {
        
//        // VM とのつながり, input にイベントを送る(テキストの変更やボタンのタップ等), 送るだけ, 登録のようなイメージ
//        registerUserViewModel = RegisterUserViewModel(input: (
//            name: nameTextField.rx.text.orEmpty.asDriver(),
//            email: emailTextField.rx.text.orEmpty.asDriver(),
//            password: passwordTextField.rx.text.orEmpty.asDriver(),
//            passwordConfirm: passwordConfirmTextField.rx.text.orEmpty.asDriver(),
//            signUpTaps: registerButton.rx.tap.asSignal()   // ボタンのタップには Single を使用する
//        ), signUpAPI: RegisterModel())
//
//        // MV からデータ受け取る, データの値を変更
//        registerUserViewModel.nameValidation
//            .drive(validateNameLabel.rx.validationResult)   // VM で 戻り値を ValidationResult にしているため,受け取りもvalidationResultにする
//            .disposed(by: disposeBag)
//
//        registerUserViewModel.emailValidation
//            .drive(validateEmailLabel.rx.validationResult)
//            .disposed(by: disposeBag)
//
//        registerUserViewModel.passwordValidation
//            .drive(validatePasswordLabel.rx.validationResult)
//            .disposed(by: disposeBag)
//
//        registerUserViewModel.passwordConfirmValidation
//            .drive(validatePasswordConfirmLabel.rx.validationResult)
//            .disposed(by: disposeBag)
//
//        let canSingUp = registerUserViewModel.canSignUp
//            .drive(onNext: { [weak self] valid  in
//                self?.registerButton.isEnabled = valid
//                self?.registerButton.alpha = valid ? 1.0 : 0.5
//                print("valid: ", valid)
//            })
//            .disposed(by: disposeBag)
//
////        let fireAuthAndStore = Driver.combineLatest(canSingUp) { (auth: $0) }
//        // これがないと アカウント登録メソッド(M) が呼ばれない
//        registerUserViewModel.isSignUp
//            .drive { result in
//                print("V, FireAuth へユーザー登録 result: ", result)
//            }
//            .disposed(by: disposeBag)
//
//        registerUserViewModel.isUserToFireStore
//            .drive { result in   // この後の .disposed(by: disposedBag) がないと Bool型 として受け取られない
//                print("V, FireStore へユーザー登録: ", result)
//                if self.isProgressView && result {
//                    HUD.hide()
//                    // 画面遷移
//                    let qrScanViewController = QrScanViewController()
//                    self.present(qrScanViewController, animated: true, completion: nil)
//                }
//            }
//            .disposed(by: disposeBag)
//
//        registerUserViewModel.signUpResult
//            .drive { user in
//                if !user.isValid {   // false の場合、ユーザー情報をFireStoreへ登録する処理 は実行されない
//                    // ×画面 を描画
//                    HUD.flash(.error, delay: 1) { _ in
//                        self.nameTextField.text = ""
//                        self.emailTextField.text = ""
//                        self.passwordTextField.text = ""
//                        self.passwordConfirmTextField.text = ""
//                        self.setupBinding()   // validate の文字を初期化するため、通知を送る
//                    }
//                }
//            }
//            .disposed(by: disposeBag)
        
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
                HUD.show(.progress)
                self.isProgressView = true
                // 3秒後にローディングを消す
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    HUD.hide()
                }
            }
            .disposed(by: disposeBag)
        
        // パスワード表示/非表示
        passwordSceretButton.rx.tap
            .subscribe { _ in
                self.passwordSceretButton.isSelected = !self.passwordSceretButton.isSelected
                self.passwordTextField.isSecureTextEntry = !self.passwordTextField.isSecureTextEntry
            }
            .disposed(by: disposeBag)
        
        passwordConfirmSceretButton.rx.tap
            .subscribe { _ in
                self.passwordConfirmSceretButton.isSelected = !self.passwordConfirmSceretButton.isSelected
                self.passwordConfirmTextField.isSecureTextEntry = !self.passwordConfirmTextField.isSecureTextEntry
            }
            .disposed(by: disposeBag)
        
        registerButton.rx.tap
            .subscribe { _ in
                self.registerButton.isSelected = !self.registerButton.isSelected
                self.registerButton.backgroundColor = self.registerButton.isSelected ? Color.lightGray.UIColor : Color.navyBlue.UIColor
            }
            .disposed(by: disposeBag)
    }
}
