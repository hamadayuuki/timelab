//
//  RegisterLabel.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/17.
//

import UIKit

class RegisterLabel: UILabel {
    init(text: String, size: CGFloat) {
        super.init(frame: .zero)
        
        self.text = text
        self.font = .systemFont(ofSize: size, weight: .heavy)
        self.textColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
