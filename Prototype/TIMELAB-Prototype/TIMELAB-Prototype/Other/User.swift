//
//  User.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/20.
//

import UIKit
import Firebase   // Timestamp

// TODO: FireStore への読み取り/書き込み に使用する
// https://firebase.google.com/docs/firestore/manage-data/add-data?hl=ja#custom_objects
struct User {
    var name: String
    var email: String
    var uid: String
    var roomsId: Array<String> = [""]   // 取得時に使用予定, 未使用
    var createAt: Timestamp
    var isValid: Bool
    
    // FireStore への登録で使用
    init(name: String, email: String, uid: String, isValid: Bool) {
        self.name = name
        self.email = email
        self.uid = uid
        self.createAt = Timestamp()   // 他の値関係なく作成
        self.isValid = isValid
    }
}
