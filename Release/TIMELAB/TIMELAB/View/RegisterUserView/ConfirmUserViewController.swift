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
import PKHUD

class ConfirmUserViewController: UIViewController {
    let disposeBag = DisposeBag()
    var userName = ""
    var iconName = ""
    
    // MARK: - UI Parts
    var descriptionLabel: RegisterLabel!
    var userIconButton: RegisterUserIconButton!
    var userNameLabel: RegisterLabel!
    var registerButton: RegisterButton!
    
    init(userName: String, iconName: String) {
        super.init(nibName: nil, bundle: nil)   // ViewController の super.init()
        
        self.userName = userName
        self.iconName = iconName
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout(userName: userName)
        setupBinding()
    }
    
    // MARK: - Function
    func setupLayout(userName: String) {
        view.backgroundColor = Color.white.UIColor
        
        descriptionLabel = RegisterLabel(text: "入力は終了です！", size: 20)
        userIconButton = RegisterUserIconButton(imageName: self.iconName, imageSize: CGSize(width: 125, height: 125))
        userNameLabel = RegisterLabel(text: self.userName, size: 20)
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
        self.registerButton.rx.tap
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                // Push画面遷移
                let checkRegisterUserViewController = CheckRegisterUserViewController(name: self.userName, iconName: self.iconName)
                self.navigationController?.pushViewController(checkRegisterUserViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
}


