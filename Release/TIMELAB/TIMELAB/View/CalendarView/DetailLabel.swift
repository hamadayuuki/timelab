//
//  DetailLabel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/23.
//

import UIKit

class DetailLabel: UILabel {
    init(text: String, fontSize: CGFloat) {
        super.init(frame: .zero)
        
        self.text = text
        self.font = .systemFont(ofSize: fontSize, weight: .bold)
        self.textColor = Color.navyBlue.UIColor
        self.numberOfLines = 0   // 高さを可変にする
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

