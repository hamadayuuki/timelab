//
//  PleaseConfirmEmailViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2023/06/11.
//

import UIKit
import SnapKit
import PKHUD
import RxCocoa
import RxSwift

class PleaseConfirmEmailViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    // MARK: - UI Parts
    var confirmEmailLabel: RegisterLabel!
    var confirmEmailMessageLabel: RegisterLabel!
    var confirmEmailUIImageView: RegisterUIImageView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        setupLayout()
    }
    
    // MARK: - Function
    func setupLayout() {
        view.backgroundColor = Color.white.UIColor
        
        confirmEmailLabel = RegisterLabel(text: "登録メールを送信しました", size: 25)
        confirmEmailMessageLabel = RegisterLabel(text: "メールのURLを押してください。", size: 15)
        confirmEmailUIImageView = RegisterUIImageView(name: "PleaseConfirmEmail")
        
        
        let confirmEmailVertical = UIStackView(arrangedSubviews: [confirmEmailLabel, confirmEmailMessageLabel, confirmEmailUIImageView])
        confirmEmailVertical.axis = .vertical
        confirmEmailVertical.alignment = .center
        confirmEmailVertical.spacing = 20
        
        confirmEmailUIImageView.snp.makeConstraints { make -> Void in
            make.width.equalTo(260)
            make.height.equalTo(260)
        }
        
        // MARK: - addSubview/layer
        view.addSubview(confirmEmailVertical)
        confirmEmailVertical.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.centerY.equalTo(view.bounds.height * 0.5)
        }
    }
}

