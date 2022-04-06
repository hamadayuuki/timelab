//
//  QrCodeScannerButton.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/06.
//

import UIKit

class QrCodeScannerButton: UIButton {
    init(imageName: String = "", text: String, textColor: UIColor = Color.navyBlue.UIColor, backgroudColor: UIColor = UIColor.clear, cornerRadius: CGFloat) {
        super.init(frame: .zero)
        
        self.setImage(UIImage(named: imageName) ?? UIImage(), for: .normal)
        self.setTitle(text, for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.backgroundColor = backgroudColor
        self.layer.cornerRadius = cornerRadius
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
