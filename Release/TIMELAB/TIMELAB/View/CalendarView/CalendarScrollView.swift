//
//  CalendarScrollView.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/07/01.
//

import UIKit

class CalendarScrollView: UIScrollView {
    init() {
        super.init(frame: .zero)
        
        self.isPagingEnabled = false
        self.showsVerticalScrollIndicator = false  // 縦方向のスクロールバーをつけるかどうか。
        self.translatesAutoresizingMaskIntoConstraints = false
        self.alwaysBounceVertical = true
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

