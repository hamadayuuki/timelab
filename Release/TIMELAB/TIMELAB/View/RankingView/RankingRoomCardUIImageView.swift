//
//  RankingRoomCardUIImageView.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/27.
//

import UIKit
import SnapKit

class RankingRoomCardUIImageView: UIImageView {
    init() {
        super.init(frame: .zero)
        
        let image = UIImage(named: "RoomCard")
        self.image = image ?? UIImage()
        
        self.snp.makeConstraints { make -> Void in
            make.width.equalTo(185)
            make.height.equalTo(58)
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
