//
//  RoomQrCodeUIImageView.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/07/02.
//

import UIKit

class RoomQrCodeUIImageView: UIImageView {
    init(qrCodeData: Data) {
        super.init(frame: .zero)
        
        let uiImage = UIImage(data: qrCodeData)!
        self.image = uiImage
        self.image = self.image?.reSizeImage(reSize: CGSize(width: 195, height: 195))
        self.layer.cornerRadius = 23
        self.layer.borderColor = Color.navyBlue.cgColor
        self.layer.borderWidth = 2.0
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
