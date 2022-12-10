//
//  ProfileLabel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/12/10.
//

import UIKit

class ProfileLabel: UILabel {
    init(text: String, size: CGFloat, color: UIColor = Color.navyBlue.UIColor) {
        super.init(frame: .zero)
        
        self.text = text
        self.font = .systemFont(ofSize: size, weight: .heavy)
        self.textColor = color
        self.textAlignment = .left
        self.numberOfLines = 0   // 複数行表示可能に
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
