//
//  RegisterLabRoomViewController.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/13.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterLabRoomViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let univercityTextField = RegisterTextField(placeholder: "〇〇大学")
    let facultyTextField = RegisterTextField(placeholder: "〇〇学部")
    let departmentTextField = RegisterTextField(placeholder: "〇〇学科")
    let labRoomNameTextField = RegisterTextField(placeholder: "〇〇研究室")
    let registerButton = RegisterButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBinding()
    }
    
    private func setupLayout() {
        self.view.backgroundColor = .white
        
        let registerVerticalView = UIStackView(arrangedSubviews: [univercityTextField, facultyTextField, departmentTextField, labRoomNameTextField])
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
    
    private func setupBinding() {
        registerButton.rx.tap
            .subscribe { [weak self] _ in
                // FireStore への登録
                print("登録ボタンが押されました")
            }
            .disposed(by: disposeBag)
    }
}
