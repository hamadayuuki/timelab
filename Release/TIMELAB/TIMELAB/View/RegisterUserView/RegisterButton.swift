//
//  RegisterButton.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/07.
//

import UIKit
import SnapKit

class RegisterButton: UIButton {
    init(text: String, textSize: CGFloat) {
        super.init(frame: .zero)
        
        self.backgroundColor = Color.navyBlue.UIColor
        self.layer.cornerRadius = 30
        self.setTitle(text, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: textSize, weight: .bold)
        self.titleLabel?.textColor = Color.white.UIColor
        
        self.snp.makeConstraints { make -> Void in
            make.width.equalTo(210)
            make.height.equalTo(60)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
