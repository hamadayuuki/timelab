//
//  RegisterTextField.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/07.
//

import UIKit
import SnapKit

class RegisterTextField: UITextField {
    init(placeholder: String, isSecretButton: Bool) {
        super.init(frame: .zero)
        
        let width = 270
        let height = 50
        let leftPaddingFrame = CGRect(x:0, y:0, width: 10, height: height)
        let rightPaddingFrame = CGRect(x: 0, y: 0, width: isSecretButton ? 40 : 10, height: height)
        self.textColor = Color.navyBlue.UIColor
        self.frame = CGRect(x: 0, y: 0, width: width, height: height)
        self.placeholder = placeholder
        self.font = .systemFont(ofSize: 20, weight: .bold)
        self.layer.borderColor = Color.navyBlue.cgColor
        self.layer.borderWidth = 3.0
        self.leftView = UIView(frame: leftPaddingFrame)   // 左に余白を追加
        self.leftViewMode = .always
        self.rightView = UIView(frame: rightPaddingFrame)   // 右に余白を追加
        self.rightViewMode = .always
        self.sizeToFit()
        
        self.snp.makeConstraints { make -> Void in
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

