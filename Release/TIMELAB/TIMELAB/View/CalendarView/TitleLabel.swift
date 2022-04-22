//
//  TitleLabel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/23.
//

import UIKit
import SnapKit

class TitleLabel: UILabel {
    init(text: String) {
        super.init(frame: .zero)
        
        self.text = text
        self.font = .systemFont(ofSize: 15, weight: .bold)
        self.textColor = Color.white.UIColor
        self.textAlignment = .center
        self.backgroundColor = Color.orange.UIColor
        self.layer.cornerRadius = 9
        self.clipsToBounds = true   // 角丸を有効にする
        
        self.snp.makeConstraints { make -> Void in
            make.width.equalTo(88)
            make.height.equalTo(33)
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

