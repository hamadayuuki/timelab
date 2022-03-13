//
//  RegisterTextField.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/13.
//

import UIKit
import SnapKit

class RegisterTextField: UITextField {
    init(placeholder: String) {
        super.init(frame: .zero)
        
        setupLayout()
        self.frame = CGRect(x: 0, y: 0, width: 300, height: 70)   // 下線のため
        self.placeholder = placeholder
        self.font = .systemFont(ofSize: 30)
        setUnderLine(color: .orange, thickness: 0.5)
    }
    
    private func setupLayout() {
        self.snp.makeConstraints { make -> Void in
            make.width.equalTo(300)
            make.height.equalTo(70)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
