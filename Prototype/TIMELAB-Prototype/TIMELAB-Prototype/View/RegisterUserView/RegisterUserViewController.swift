//
//  RegisterUserViewController.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/14.
//

import UIKit
import SnapKit

class RegisterUserViewController: UIViewController {
    
    let emailTextField = RegisterTextField(placeholder: "メールアドレス")
    let passwordTextField = RegisterTextField(placeholder: "パスワード")
    let registerButton = RegisterButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    private func setupLayout() {
        self.view.backgroundColor = .white
        
        let registerVerticalView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        registerVerticalView.axis = .vertical
        registerVerticalView.distribution = .fillEqually   // 要素の大きさを均等にする
        registerVerticalView.spacing = 50
        
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
    }
}
