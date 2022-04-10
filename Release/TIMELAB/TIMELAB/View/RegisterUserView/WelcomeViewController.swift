//
//  WelcomeViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/08.
//

import UIKit
import SnapKit
import PKHUD
import RxCocoa
import RxSwift

class WelcomeViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    // MARK: - UI Parts
    var welcomeLabel: RegisterLabel!
    var welcomeMessageLabel: RegisterLabel!
    var welcomeUIImageView: RegisterUIImageView!
    var moveRegisterNickNameView: RegisterButton!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBinding()
    }
    
    // MARK: - Function
    func setupLayout() {
        view.backgroundColor = Color.white.UIColor
        
        welcomeLabel = RegisterLabel(text: "ようこそ！！", size: 30)
        welcomeMessageLabel = RegisterLabel(text: "これから研究を頑張っていきましょう", size: 15)
        welcomeUIImageView = RegisterUIImageView(name: "Welcome")
        moveRegisterNickNameView = RegisterButton(text: "ニックネームを入力", textSize: 15)
        
        
        let welcomeVertical = UIStackView(arrangedSubviews: [welcomeLabel, welcomeMessageLabel, welcomeUIImageView])
        welcomeVertical.axis = .vertical
        welcomeVertical.alignment = .center
        welcomeVertical.spacing = 20
        
        welcomeUIImageView.snp.makeConstraints { make -> Void in
            make.width.equalTo(520)
            make.height.equalTo(390)
        }
        
        // MARK: - addSubview/layer
        view.addSubview(welcomeVertical)
        welcomeVertical.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.centerY.equalTo(view.bounds.height * 0.5)
        }
        
        view.addSubview(moveRegisterNickNameView)
        moveRegisterNickNameView.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.top.equalTo(welcomeVertical.snp.bottom).offset(30)
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
        
        moveRegisterNickNameView.rx.tap
            .subscribe { _ in
                HUD.show(.progress)   // ローディング表示
                self.moveRegisterNickNameView.isSelected = !self.moveRegisterNickNameView.isSelected
                self.moveRegisterNickNameView.backgroundColor = self.moveRegisterNickNameView.isSelected ? Color.lightGray.UIColor : Color.navyBlue.UIColor
                // 3秒後にローディングを消す
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    HUD.hide()
                    self.moveRegisterNickNameView.isSelected = !self.moveRegisterNickNameView.isSelected
                    self.moveRegisterNickNameView.backgroundColor = self.moveRegisterNickNameView.isSelected ? Color.lightGray.UIColor : Color.navyBlue.UIColor
                    // push画面遷移
                    let registerNickNameViewController = RegisterNickNameViewController()
                    self.navigationController?.pushViewController(registerNickNameViewController, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}
