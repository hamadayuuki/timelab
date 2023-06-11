//
//  CheckRegisterUserViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2023/06/11.
//

import UIKit
import SnapKit
import PKHUD

// メール認証から遷移する
// 主にユーザー登録の処理を行う
class CheckRegisterUserViewController: UIViewController {
    
    // MARK: - UI Parts
    var checkRegisterUserLabel: RegisterLabel!
    var checkRegisterUserMessageLabel: RegisterLabel!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        HUD.dimsBackground = false
        HUD.show(.progress)
    }
    
    // MARK: - Function
    func setupLayout() {
        view.backgroundColor = Color.white.UIColor
        
        checkRegisterUserLabel = RegisterLabel(text: "登録しています", size: 30)
        checkRegisterUserMessageLabel = RegisterLabel(text: "もう少しお待ちください", size: 15)
        
        
        let checkRegisterUserVertical = UIStackView(arrangedSubviews: [checkRegisterUserLabel, checkRegisterUserMessageLabel])
        checkRegisterUserVertical.axis = .vertical
        checkRegisterUserVertical.alignment = .center
        checkRegisterUserVertical.spacing = 20
        
        // MARK: - addSubview/layer
        view.addSubview(checkRegisterUserVertical)
        checkRegisterUserVertical.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.centerY.equalTo(view.bounds.height * 0.3)
        }
    }
}
