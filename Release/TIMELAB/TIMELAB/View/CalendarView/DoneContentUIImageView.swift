//
//  DoneContentUIImageView.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/07/01.
//

import UIKit

class DoneContentUIImageView: UIImageView {
    init(uiImage: UIImage) {
        super.init(frame: .zero)
        
        self.image = uiImage ?? UIImage()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

