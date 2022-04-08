//
//  ConfirmUserViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/08.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class ConfirmUserViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    // MARK: - UI Parts
    var descriptionLabel: RegisterLabel!
    var userIconButton: RegisterUserIconButton!
    var userNameLabel: RegisterLabel!
    var registerButton: RegisterButton!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userIconName = "UserIcon_1"
        let userName = "たろう"
        setupLayout(userIconName: userIconName, userName: userName)
        setupBinding()
    }
    
    // MARK: - Function
    func setupLayout(userIconName: String, userName: String) {
        view.backgroundColor = Color.white.UIColor
        
        descriptionLabel = RegisterLabel(text: "入力は終了です！", size: 20)
        userIconButton = RegisterUserIconButton(imageName: userIconName, imageSize: CGSize(width: 125, height: 125))
        userNameLabel = RegisterLabel(text: userName, size: 30)
        registerButton = RegisterButton(text: "OK", textSize: 15)
        
        let confirmUserVertical = UIStackView(arrangedSubviews: [descriptionLabel, userIconButton, userNameLabel])
        confirmUserVertical.axis = .vertical
        confirmUserVertical.alignment = .center
        confirmUserVertical.spacing = 40
        
        // MARK: - addSubview/layer
        view.addSubview(confirmUserVertical)
        confirmUserVertical.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.centerY.equalTo(view.bounds.height * 0.4)
        }
        
        view.addSubview(registerButton)
        registerButton.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.top.equalTo(confirmUserVertical.snp.bottom).offset(55)
        }
        
    }
    
    func setupBinding() {
        registerButton.rx.tap
            .subscribe { _ in
                self.registerButton.isSelected = !self.registerButton.isSelected
                self.registerButton.backgroundColor = self.registerButton.isSelected ? Color.lightGray.UIColor : Color.navyBlue.UIColor
            }
            .disposed(by: disposeBag)
    }
}


