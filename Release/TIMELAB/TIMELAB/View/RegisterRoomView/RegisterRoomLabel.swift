//
//  RegisterRoomLabel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/06/02.
//

import UIKit

class RegisterRoomLabel: UILabel {
    init(text: String, textAlignment: NSTextAlignment = .center, size: CGFloat, color: UIColor = Color.navyBlue.UIColor) {
        super.init(frame: .zero)
        
        self.text = text
        self.font = .systemFont(ofSize: size, weight: .heavy)
        self.textColor = color
        self.textAlignment = textAlignment
        self.numberOfLines = 0   // 複数行表示可能に
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

