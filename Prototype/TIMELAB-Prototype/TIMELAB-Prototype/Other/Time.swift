//
//  Time.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/26.
//

import Firebase

// TODO: FireStore への読み取り/書き込み に使用する
// https://firebase.google.com/docs/firestore/manage-data/add-data?hl=ja#custom_objects
struct Time {
    var name: String = ""
    var uid: String = ""
    var enterAt: Timestamp = Timestamp()
    var leaveAt: Timestamp = Timestamp()
    var state: String = ""
    var enterTime: [String: Any] = ["": ""]
    var leaveTime: [String: Any] = ["": ""]
}
