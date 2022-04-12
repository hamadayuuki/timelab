//
//  RegisterNickNameViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/08.
//

import UIKit
import SnapKit
import PKHUD
import RxCocoa
import RxSwift

class RegisterNickNameViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    // MARK: - UI Parts
    var nickNameUIImageView: RegisterUIImageView!
    var descriptionLabel: RegisterLabel!
    var nickNameTextField: RegisterTextField!
    var registerNickNameButton: RegisterButton!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBinding()
    }
    
    // MARK: - Function
    func setupLayout() {
        view.backgroundColor = Color.white.UIColor
        
        nickNameUIImageView = RegisterUIImageView(name: "FindJewelryMan")
        descriptionLabel = RegisterLabel(text: "表示するニックネームを教えてください", size: 15)
        nickNameTextField = RegisterTextField(placeholder: "", isSecretButton: false)
        registerNickNameButton = RegisterButton(text: "OK", textSize: 15)
        
        let registerNickNameVertical = UIStackView(arrangedSubviews: [nickNameUIImageView, descriptionLabel, nickNameTextField])
        registerNickNameVertical.axis = .vertical
        registerNickNameVertical.alignment = .center
        registerNickNameVertical.spacing = 20
        
        nickNameUIImageView.snp.makeConstraints { make -> Void in
            make.width.equalTo(280)
            make.height.equalTo(210)
        }
        
        // MARK: - addSubview/layer
        view.addSubview(registerNickNameVertical)
        registerNickNameVertical.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.centerY.equalTo(view.bounds.height * 0.4)
        }
        
        view.addSubview(registerNickNameButton)
        registerNickNameButton.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.top.equalTo(registerNickNameVertical.snp.bottom).offset(55)
        }
        
    }
    
    func setupBinding() {
        // 背景をタップしたらキーボードを隠す
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)
        
        registerNickNameButton.rx.tap
            .subscribe { _ in
                HUD.show(.progress)
                self.registerNickNameButton.isSelected = !self.registerNickNameButton.isSelected
                self.registerNickNameButton.backgroundColor = self.registerNickNameButton.isSelected ? Color.lightGray.UIColor : Color.navyBlue.UIColor
                // 3秒後にローディングを消す
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    HUD.hide()
                    self.registerNickNameButton.isSelected = !self.registerNickNameButton.isSelected
                    self.registerNickNameButton.backgroundColor = self.registerNickNameButton.isSelected ? Color.lightGray.UIColor : Color.navyBlue.UIColor
                    // Push画面遷移
                    let registerUserIconViewController = RegisterUserIconViewController(userName: self.nickNameTextField.text ?? "")
                    self.navigationController?.pushViewController(registerUserIconViewController, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}

