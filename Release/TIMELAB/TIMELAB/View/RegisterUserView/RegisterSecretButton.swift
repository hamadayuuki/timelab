//
//  RegisterSecretButton.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/07.
//

import UIKit

class RegisterSecretButton: UIButton {
    init(imageSize: CGSize = CGSize(width: 0.0, height: 0.0), backgroudColor: UIColor = UIColor.clear, cornerRadius: CGFloat = 0.0) {
        super.init(frame: .zero)
        
        var noSecretImage = UIImage(named: "NoSecret") ?? UIImage()
        noSecretImage = noSecretImage.reSizeImage(reSize: imageSize)
        self.setImage(noSecretImage, for: .normal)
        
        var secretImage = UIImage(named: "Secret") ?? UIImage()
        secretImage = secretImage.reSizeImage(reSize: imageSize)
        self.setImage(secretImage, for: .selected)
        
        self.backgroundColor = backgroudColor
        self.layer.cornerRadius = cornerRadius
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
