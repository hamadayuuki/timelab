//
//  RegisterButton.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/07.
//

import UIKit

class RegisterButton: UIButton {
    init() {
        super.init(frame: .zero)
        self.backgroundColor = Color.navyBlue.UIColor
        self.layer.cornerRadius = 30
        self.setTitle("アカウントを作成する", for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        self.titleLabel?.textColor = Color.white.UIColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
