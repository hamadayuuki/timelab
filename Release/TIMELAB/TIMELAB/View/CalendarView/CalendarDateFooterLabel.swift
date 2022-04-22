//
//  CalendarDateFooterLabel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/23.
//

import UIKit
import SnapKit

class CalendarDateFooterLabel: UILabel {
    init(text: String) {
        super.init(frame: .zero)
        
        self.text = text
        self.font = .systemFont(ofSize: 20, weight: .bold)
        self.textColor = Color.white.UIColor
        self.textAlignment = .center
        self.backgroundColor = Color.navyBlue.UIColor
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

