//
//  RegisterUserViewController.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RegisterUserViewController: UIViewController {
    
    // UI Parts
    var nameLabel: RegisterLabel!
    var nameTextField: RegisterTextField!
    var validateNameLabel: RegisterLabel!
    var emailLabel: RegisterLabel!
    var emailTextField: RegisterTextField!
    var validateEmailLabel: RegisterLabel!
    var passwordLabel: RegisterLabel!
    var passwordTextField: RegisterTextField!
    var validatePasswordLabel: RegisterLabel!
    var passwordConfirmLabel: RegisterLabel!
    var passwordConfirmTextField: RegisterTextField!
    var validatePasswordConfirmLabel: RegisterLabel!
    var registerButton: RegisterButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    private func setupLayout() {
        self.view.backgroundColor = .white
        
        let width = view.bounds.width
        let height = view.bounds.height
        
        nameLabel = RegisterLabel(text: "名前", size: 18)
        nameTextField = RegisterTextField(placeholder: "")
        validateNameLabel = RegisterLabel(text: "", size: 10)
        emailLabel = RegisterLabel(text: "メールアドレス", size: 18)
        emailTextField = RegisterTextField(placeholder: "")
        validateEmailLabel = RegisterLabel(text: "", size: 10)
        passwordLabel = RegisterLabel(text: "パスワード入力 (小文字数字8文字以上)", size: 18)
        passwordTextField = RegisterTextField(placeholder: "")
        validatePasswordLabel = RegisterLabel(text: "", size: 10)
        passwordConfirmLabel = RegisterLabel(text: "パスワード再入力", size: 18)
        passwordConfirmTextField = RegisterTextField(placeholder: "")
        validatePasswordConfirmLabel = RegisterLabel(text: "", size: 10)
        
        registerButton = RegisterButton()
        
        let nameVerticalView = UIStackView(arrangedSubviews: [nameLabel, nameTextField, validateNameLabel])
        nameVerticalView.axis = .vertical
        nameVerticalView.spacing = 5
        let emailVerticalView = UIStackView(arrangedSubviews: [emailLabel, emailTextField, validateEmailLabel])
        emailVerticalView.axis = .vertical
        emailVerticalView.spacing = 5
        let passwordVerticalView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField, validatePasswordLabel])
        passwordVerticalView.axis = .vertical
        passwordVerticalView.spacing = 5
        let passwordConfirmVerticalView = UIStackView(arrangedSubviews: [passwordConfirmLabel, passwordConfirmTextField, validatePasswordConfirmLabel])
        passwordConfirmVerticalView.axis = .vertical
        passwordConfirmVerticalView.spacing = 5
        
        let registerVerticalView = UIStackView(arrangedSubviews: [nameVerticalView, emailVerticalView, passwordVerticalView, passwordConfirmVerticalView])
        registerVerticalView.axis = .vertical
        registerVerticalView.distribution = .fillEqually   // 要素の大きさを均等にする
        registerVerticalView.spacing = 20
        
        view.addSubview(registerVerticalView)
        registerVerticalView.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width / 2)
            make.top.equalTo(view.bounds.height * 0.2)
        }
        
        view.addSubview(registerButton)
        registerButton.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width / 2)
            make.top.equalTo(registerVerticalView.snp.bottom).offset(50)
            make.width.equalTo(100)
            make.height.equalTo(70)
        }
        
        // 背景をタップしたらキーボードを隠す
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)
    }
}
