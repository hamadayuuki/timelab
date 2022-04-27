//
//  RankingLabel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/27.
//

import UIKit

class RankingLabel: UILabel {
    init(text: String, size: CGFloat, textColor: UIColor = .black) {
        super.init(frame: .zero)
        
        self.text = text
        self.font = .systemFont(ofSize: size, weight: .heavy)
        self.textColor = textColor
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
