//
//  User.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/20.
//

import UIKit
import Firebase   // Timestamp

struct User {
    var name: String
    var email: String
    var uid: String
    var createAt: Timestamp
    var isValid: Bool
    
    init(name: String, email: String, uid: String, isValid: Bool) {
        self.name = name
        self.email = email
        self.uid = uid
        self.createAt = Timestamp()   // 他の値関係なく作成
        self.isValid = isValid
    }
}
