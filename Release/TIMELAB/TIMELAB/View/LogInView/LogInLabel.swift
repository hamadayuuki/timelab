//
//  LogInLabel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/10.
//

import UIKit

class LogInLabel: UILabel {
    init(text: String, size: CGFloat, textColor: UIColor = Color.navyBlue.UIColor) {
        super.init(frame: .zero)
        
        self.text = text
        self.font = .systemFont(ofSize: size, weight: .heavy)
        self.textColor = textColor
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
