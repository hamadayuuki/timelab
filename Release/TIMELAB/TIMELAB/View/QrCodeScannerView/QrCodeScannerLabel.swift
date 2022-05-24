//
//  QrCodeScannerLabel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/06.
//

import UIKit

class QrCodeScannerLabel: UILabel {
    init(text: String = "", size: CGFloat, weight: UIFont.Weight = .heavy, color: UIColor = Color.navyBlue.UIColor, backgroundColor: UIColor = .clear) {
        super.init(frame: .zero)
        
        self.text = text
        self.font = .systemFont(ofSize: size, weight: weight)
        self.textColor = color
        self.backgroundColor = backgroundColor
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
