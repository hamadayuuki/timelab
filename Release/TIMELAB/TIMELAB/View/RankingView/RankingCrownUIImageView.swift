//
//  RankingCrownUIImageView.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/27.
//

import UIKit
import SnapKit

class RankingCrownUIImageView: UIImageView {
    init(name: String) {
        super.init(frame: .zero)
        
        let image = UIImage(named: name)
        self.image = image ?? UIImage()
        
        self.snp.makeConstraints { make -> Void in
            make.width.equalTo(38)
            make.height.equalTo(30)
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
