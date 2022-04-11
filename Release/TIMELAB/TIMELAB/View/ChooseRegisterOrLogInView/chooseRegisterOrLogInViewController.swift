//
//  chooseRegisterOrLogInViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/11.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import PKHUD

class chooseRegisterOrLogInViewController: UIViewController {
    
    // MARK: - UI Parts
    var titleLabelUIImageView: chooseRegisterOrLogInUIImageView!
    var iconUIImageView: chooseRegisterOrLogInUIImageView!
    var logInButton: chooseRegisterOrLogInButton!
    var registerButton: chooseRegisterOrLogInButton!
    
    let disposeBag = DisposeBag()
    
//    var registerUserViewModel: RegisterUserViewModel!
    
    var isProgressView  = false
    
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
        
        titleLabelUIImageView = chooseRegisterOrLogInUIImageView(name: "TimeLabTitleLabel")
        iconUIImageView = chooseRegisterOrLogInUIImageView(name: "TimeLabIcon")
        logInButton = chooseRegisterOrLogInButton(text: "ログイン", textSize: 15, isRegister: false)
        registerButton = chooseRegisterOrLogInButton(text: "はじめて使う", textSize: 15, isRegister: true)
        
        let iconAndTitleLabelVertical = UIStackView(arrangedSubviews: [titleLabelUIImageView, iconUIImageView])
        iconAndTitleLabelVertical.axis = .vertical
        iconAndTitleLabelVertical.spacing = -30
        
        let registerOrLogInVertical = UIStackView(arrangedSubviews: [logInButton, registerButton])
        registerOrLogInVertical.axis = .vertical
        registerOrLogInVertical.spacing = 20
        
        // MARK: - addSubview/layer
        titleLabelUIImageView.snp.makeConstraints { make -> Void in
            make.width.equalTo(217)
            make.height.equalTo(52)
        }
        iconUIImageView.snp.makeConstraints { make -> Void in
            make.width.equalTo(195)
            make.height.equalTo(195)
        }
        
        view.addSubview(iconAndTitleLabelVertical)
        iconAndTitleLabelVertical.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.centerY.equalTo(view.bounds.height * 0.35)
        }
        
        view.addSubview(registerOrLogInVertical)
        registerOrLogInVertical.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.centerY.equalTo(view.bounds.height * 0.7)
        }
        
    }
    
    private func setupBinding() {
        
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
//                self.isProgressView = true
                // TODO: ボタン 選択/非選択プログラム を簡略化, 簡略化可能かどうかから考える
                self.logInButton.isSelected = !self.logInButton.isSelected
                self.logInButton.backgroundColor = self.logInButton.isSelected ? Color.lightGray.UIColor : Color.navyBlue.UIColor
                // 3秒後にローディングを消す
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    HUD.hide()
                    self.logInButton.isSelected = !self.logInButton.isSelected
                    self.logInButton.backgroundColor = self.logInButton.isSelected ? Color.lightGray.UIColor : Color.navyBlue.UIColor
                    // push画面遷移
                    let logInViewControlelr = LogInViewController()
                    self.navigationController?.pushViewController(logInViewControlelr, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        registerButton.rx.tap
            .subscribe { _ in
                HUD.show(.progress)   // ローディング表示
//                self.isProgressView = true
                // TODO: ボタン 選択/非選択プログラム を簡略化, 簡略化可能かどうかから考える
                self.registerButton.isSelected = !self.registerButton.isSelected
                self.registerButton.backgroundColor = self.registerButton.isSelected ? Color.lightGray.UIColor : Color.navyBlue.UIColor
                // 3秒後にローディングを消す
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    HUD.hide()
                    self.registerButton.isSelected = !self.registerButton.isSelected
                    self.registerButton.backgroundColor = self.registerButton.isSelected ? Color.lightGray.UIColor : Color.white.UIColor
                    // push画面遷移
                    let registerUserViewController = RegisterUserViewController()
                    self.navigationController?.pushViewController(registerUserViewController, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        
    }
}


