//
//  QrCodeScannerButton.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/06.
//

import UIKit

class QrCodeScannerButton: UIButton {
    init(imageName: String = "", imageSize: CGSize = CGSize(width: 0.0, height: 0.0), text: String = "", textColor: UIColor = Color.navyBlue.UIColor, backgroudColor: UIColor = UIColor.clear, cornerRadius: CGFloat = 0.0) {
        super.init(frame: .zero)
        
        var image = UIImage(named: imageName) ?? UIImage()
        image = image.reSizeImage(reSize: imageSize)
        self.setImage(image, for: .normal)
        self.setTitle(text, for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.backgroundColor = backgroudColor
        self.layer.cornerRadius = cornerRadius
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
