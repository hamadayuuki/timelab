//
//  RegisterRoomUIImageView.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/06/02.
//

import UIKit

class RegisterRoomUIImageView: UIImageView {
    init(name: String, size: CGSize) {
        super.init(frame: .zero)
        
        let image = UIImage(named: name)
        self.image = image ?? UIImage()
        self.image = self.image?.reSizeImage(reSize: CGSize(width: size.width, height: size.height))
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
