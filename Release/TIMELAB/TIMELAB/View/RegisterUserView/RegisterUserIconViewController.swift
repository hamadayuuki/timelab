//
//  RegisterUserIconViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/08.
//

import UIKit
import SnapKit
import PKHUD
import RxCocoa
import RxSwift

class RegisterUserIconViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    // MARK: - UI Parts
    var descriptionLabel: RegisterLabel!
    var icon1: RegisterUserIconButton!
    var icon2: RegisterUserIconButton!
    var icon3: RegisterUserIconButton!
    var icon4: RegisterUserIconButton!
    var icon5: RegisterUserIconButton!
    var icon6: RegisterUserIconButton!
    var icon7: RegisterUserIconButton!
    var icon8: RegisterUserIconButton!
    var icon9: RegisterUserIconButton!
    var icon10: RegisterUserIconButton!
    var icon11: RegisterUserIconButton!
    var icon12: RegisterUserIconButton!
    var icon13: RegisterUserIconButton!
    var icon14: RegisterUserIconButton!
    var icon15: RegisterUserIconButton!
    var registerUserIconButton: RegisterButton!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBinding()
    }
    
    // MARK: - Function
    func setupLayout() {
        view.backgroundColor = Color.white.UIColor
        
        descriptionLabel = RegisterLabel(text: "アイコンに使うイラストを選んでください", size: 15)
        let userIconVertical = setupUserIconVertical()
        let descriptionAndUserIconVertical = UIStackView(arrangedSubviews: [descriptionLabel, userIconVertical])
        descriptionAndUserIconVertical.axis = .vertical
        descriptionAndUserIconVertical.spacing = 20
        descriptionAndUserIconVertical.alignment = .center
        registerUserIconButton = RegisterButton(text: "OK", textSize: 15)
        
        // MARK: - addSubview/layer
        view.addSubview(descriptionAndUserIconVertical)
        descriptionAndUserIconVertical.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.centerY.equalTo(view.bounds.height * 0.5)
        }
        
        view.addSubview(registerUserIconButton)
        registerUserIconButton.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.top.equalTo(descriptionAndUserIconVertical.snp.bottom).offset(30)
        }
        
    }
    
    // 15個のアイコン を 3×5 に並べる
    func setupUserIconVertical() -> UIStackView {
        icon1 = RegisterUserIconButton(imageName: "UserIcon_1")
        icon2 = RegisterUserIconButton(imageName: "UserIcon_2")
        icon3 = RegisterUserIconButton(imageName: "UserIcon_3")
        icon4 = RegisterUserIconButton(imageName: "UserIcon_4")
        icon5 = RegisterUserIconButton(imageName: "UserIcon_5")
        icon6 = RegisterUserIconButton(imageName: "UserIcon_6")
        icon7 = RegisterUserIconButton(imageName: "UserIcon_7")
        icon8 = RegisterUserIconButton(imageName: "UserIcon_8")
        icon9 = RegisterUserIconButton(imageName: "UserIcon_9")
        icon10 = RegisterUserIconButton(imageName: "UserIcon_10")
        icon11 = RegisterUserIconButton(imageName: "UserIcon_11")
        icon12 = RegisterUserIconButton(imageName: "UserIcon_12")
        icon13 = RegisterUserIconButton(imageName: "UserIcon_13")
        icon14 = RegisterUserIconButton(imageName: "UserIcon_14")
        icon15 = RegisterUserIconButton(imageName: "UserIcon_15")
        
        let userIconHorizontal1 = UIStackView(arrangedSubviews: [icon1, icon2, icon3])
        userIconHorizontal1.axis = .horizontal
        userIconHorizontal1.spacing = 23
        let userIconHorizontal2 = UIStackView(arrangedSubviews: [icon4, icon5, icon6])
        userIconHorizontal2.axis = .horizontal
        userIconHorizontal2.spacing = 23
        let userIconHorizontal3 = UIStackView(arrangedSubviews: [icon7, icon8, icon9])
        userIconHorizontal3.axis = .horizontal
        userIconHorizontal3.spacing = 23
        let userIconHorizontal4 = UIStackView(arrangedSubviews: [icon10, icon11, icon12])
        userIconHorizontal4.axis = .horizontal
        userIconHorizontal4.spacing = 23
        let userIconHorizontal5 = UIStackView(arrangedSubviews: [icon13, icon14, icon15])
        userIconHorizontal5.axis = .horizontal
        userIconHorizontal5.spacing = 23
        
        let userIconVertical = UIStackView(arrangedSubviews: [userIconHorizontal1, userIconHorizontal2, userIconHorizontal3, userIconHorizontal4, userIconHorizontal5])
        userIconVertical.axis = .vertical
        userIconVertical.spacing = 20
        
        return userIconVertical
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
        
        icon1.rx.tap
            .subscribe { _ in self.changeIconBackgroundColor(icon: self.icon1) }
            .disposed(by: disposeBag)
        
        icon2.rx.tap
            .subscribe { _ in self.changeIconBackgroundColor(icon: self.icon2) }
            .disposed(by: disposeBag)
        
        icon3.rx.tap
            .subscribe { _ in self.changeIconBackgroundColor(icon: self.icon3) }
            .disposed(by: disposeBag)
        
        icon4.rx.tap
            .subscribe { _ in self.changeIconBackgroundColor(icon: self.icon4) }
            .disposed(by: disposeBag)
        
        icon5.rx.tap
            .subscribe { _ in self.changeIconBackgroundColor(icon: self.icon5) }
            .disposed(by: disposeBag)
        
        icon6.rx.tap
            .subscribe { _ in self.changeIconBackgroundColor(icon: self.icon6) }
            .disposed(by: disposeBag)
        
        icon7.rx.tap
            .subscribe { _ in self.changeIconBackgroundColor(icon: self.icon7) }
            .disposed(by: disposeBag)
        
        icon8.rx.tap
            .subscribe { _ in self.changeIconBackgroundColor(icon: self.icon8) }
            .disposed(by: disposeBag)
        
        icon9.rx.tap
            .subscribe { _ in self.changeIconBackgroundColor(icon: self.icon9) }
            .disposed(by: disposeBag)
        
        icon10.rx.tap
            .subscribe { _ in self.changeIconBackgroundColor(icon: self.icon10) }
            .disposed(by: disposeBag)
        
        icon11.rx.tap
            .subscribe { _ in self.changeIconBackgroundColor(icon: self.icon11) }
            .disposed(by: disposeBag)
        
        icon12.rx.tap
            .subscribe { _ in self.changeIconBackgroundColor(icon: self.icon12) }
            .disposed(by: disposeBag)
        
        icon13.rx.tap
            .subscribe { _ in self.changeIconBackgroundColor(icon: self.icon13) }
            .disposed(by: disposeBag)
        
        icon14.rx.tap
            .subscribe { _ in self.changeIconBackgroundColor(icon: self.icon14) }
            .disposed(by: disposeBag)
        
        icon15.rx.tap
            .subscribe { _ in self.changeIconBackgroundColor(icon: self.icon15) }
            .disposed(by: disposeBag)
        
        registerUserIconButton.rx.tap
            .subscribe { _ in
                HUD.show(.progress)
                self.registerUserIconButton.isSelected = !self.registerUserIconButton.isSelected
                self.registerUserIconButton.backgroundColor = self.registerUserIconButton.isSelected ? Color.lightGray.UIColor : Color.navyBlue.UIColor
                // 3秒後にローディングを消す
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    HUD.hide()
                    self.registerUserIconButton.isSelected = !self.registerUserIconButton.isSelected
                    self.registerUserIconButton.backgroundColor = self.registerUserIconButton.isSelected ? Color.lightGray.UIColor : Color.navyBlue.UIColor
                    // Push画面遷移
                    let confirmUserViewController = ConfirmUserViewController()
                    self.navigationController?.pushViewController(confirmUserViewController, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    func changeIconBackgroundColor(icon: RegisterUserIconButton) {
        self.icon1.isSelected = false
        self.icon2.isSelected = false
        self.icon3.isSelected = false
        self.icon4.isSelected = false
        self.icon5.isSelected = false
        self.icon6.isSelected = false
        self.icon7.isSelected = false
        self.icon8.isSelected = false
        self.icon9.isSelected = false
        self.icon10.isSelected = false
        self.icon11.isSelected = false
        self.icon12.isSelected = false
        self.icon13.isSelected = false
        self.icon14.isSelected = false
        self.icon15.isSelected = false
        
        icon.isSelected = true
        
        self.icon1.backgroundColor = self.icon1.isSelected ? Color.orange.UIColor : Color.white.UIColor
        self.icon2.backgroundColor = self.icon2.isSelected ? Color.orange.UIColor : Color.white.UIColor
        self.icon3.backgroundColor = self.icon3.isSelected ? Color.orange.UIColor : Color.white.UIColor
        self.icon4.backgroundColor = self.icon4.isSelected ? Color.orange.UIColor : Color.white.UIColor
        self.icon5.backgroundColor = self.icon5.isSelected ? Color.orange.UIColor : Color.white.UIColor
        self.icon6.backgroundColor = self.icon6.isSelected ? Color.orange.UIColor : Color.white.UIColor
        self.icon7.backgroundColor = self.icon7.isSelected ? Color.orange.UIColor : Color.white.UIColor
        self.icon8.backgroundColor = self.icon8.isSelected ? Color.orange.UIColor : Color.white.UIColor
        self.icon9.backgroundColor = self.icon9.isSelected ? Color.orange.UIColor : Color.white.UIColor
        self.icon10.backgroundColor = self.icon10.isSelected ? Color.orange.UIColor : Color.white.UIColor
        self.icon11.backgroundColor = self.icon11.isSelected ? Color.orange.UIColor : Color.white.UIColor
        self.icon12.backgroundColor = self.icon12.isSelected ? Color.orange.UIColor : Color.white.UIColor
        self.icon13.backgroundColor = self.icon13.isSelected ? Color.orange.UIColor : Color.white.UIColor
        self.icon14.backgroundColor = self.icon14.isSelected ? Color.orange.UIColor : Color.white.UIColor
        self.icon15.backgroundColor = self.icon15.isSelected ? Color.orange.UIColor : Color.white.UIColor
    }
}


