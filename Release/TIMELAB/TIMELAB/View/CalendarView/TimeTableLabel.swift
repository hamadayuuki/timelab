//
//  TimeTableLabel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/09/27.
//

import UIKit

class TimeTableLabel: UILabel {
    init(text: String, fontSize: CGFloat, isEnterTime: Bool, isFooter: Bool = false) {
        super.init(frame: .zero)
        
        self.text = text
        if isFooter {
            self.font = .systemFont(ofSize: fontSize, weight: .bold)
        } else {
            self.font = .systemFont(ofSize: fontSize, weight: .light)
        }
        
        self.textAlignment = .center
        if isEnterTime {
            self.textColor = Color.navyBlue.UIColor
//            self.backgroundColor = Color.lightGray.UIColor
            self.numberOfLines = 0   // 高さを可変にする
        } else {
            self.textColor = Color.navyBlue.UIColor
            self.numberOfLines = 0   // 高さを可変にする
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
