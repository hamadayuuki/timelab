//
//  RegisterRoomUIImageView.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/06/02.
//

import UIKit

class RegisterRoomUIImageView: UIImageView {
    init(name: String, size: CGSize, isBorderLine: Bool = false) {
        super.init(frame: .zero)
        
        let image = UIImage(named: name)
        self.image = image ?? UIImage()
        self.image = self.image?.reSizeImage(reSize: CGSize(width: size.width, height: size.height))
        if (isBorderLine) {
            self.layer.cornerRadius = 23
            self.layer.borderColor = Color.navyBlue.cgColor
            self.layer.borderWidth = 2.0
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
