//
//  RegisterRoomUIImageView.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/06/02.
//

import UIKit
import SnapKit

class RegisterRoomUIImageView: UIImageView {
    init(name: String) {
        super.init(frame: .zero)
        
        let image = UIImage(named: name)
        self.image = image ?? UIImage()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
