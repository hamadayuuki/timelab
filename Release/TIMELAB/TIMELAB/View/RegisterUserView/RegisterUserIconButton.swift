//
//  RegisterUserIconButton.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/08.
//

import UIKit
import SnapKit

class RegisterUserIconButton: UIButton {
    init(imageName: String = "", imageSize: CGSize = CGSize(width: 85, height: 85)) {
        super.init(frame: .zero)
        
        var image = UIImage(named: imageName) ?? UIImage()
        image = image.reSizeImage(reSize: imageSize)
        self.accessibilityIdentifier = imageName   // 選択したアイコンの画像名を取得するため
        self.setImage(image, for: .normal)
        self.backgroundColor = Color.white.UIColor
        self.layer.cornerRadius = imageSize.width / 2
        self.layer.borderColor = Color.navyBlue.cgColor
        self.layer.borderWidth = 1
        
        self.snp.makeConstraints { make -> Void in
            make.width.equalTo(imageSize.width)
            make.height.equalTo(imageSize.height)
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

