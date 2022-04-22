//
//  CalendarDetailUIImageView.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/23.
//

import UIKit
import SnapKit

class CalendarDetailUIImageView: UIImageView {
    init(name: String, size: CGSize) {
        super.init(frame: .zero)
        
        let image = UIImage(named: name)
        self.image = image ?? UIImage()
        
        self.snp.makeConstraints { make -> Void in
            make.width.equalTo(size.width)
            make.height.equalTo(size.height)
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
