//
//  RankingUserIconButton.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/27.
//

import UIKit
import SnapKit

// UIImageView として使用, アイコン画像の円を表現するため
class RankingUserIconButton: UIButton {
    init(imageName: String = "", imageSize: CGSize = CGSize(width: 55, height: 55)) {
        super.init(frame: .zero)
        
        var image = UIImage(named: imageName) ?? UIImage()
        image = image.reSizeImage(reSize: imageSize)
        self.accessibilityIdentifier = imageName   // 選択したアイコンの画像名を取得するため
        self.setImage(image, for: .normal)
        self.backgroundColor = .white
        self.layer.cornerRadius = imageSize.width / 2
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.isEnabled = false
        self.adjustsImageWhenDisabled = false   // ボタンを無効化した時色を変えない
        
        self.snp.makeConstraints { make -> Void in
            make.width.equalTo(imageSize.width)
            make.height.equalTo(imageSize.height)
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

