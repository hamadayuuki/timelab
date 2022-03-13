//
//  RegisterButton.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/13.
//

import UIKit

class RegisterButton: UIButton {
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .orange
        self.layer.cornerRadius = 20
        self.setTitle("登録", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
