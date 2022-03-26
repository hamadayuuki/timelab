//
//  Time.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/26.
//

import Firebase

// 未使用
struct Time {
    var name: String = ""
    var uid: String = ""
    var enterAt: Timestamp = Timestamp()
    var leaveAt: Timestamp = Timestamp()
    var state: String = ""
    var enterTime: [String: Any] = ["": ""]
    var leaveTime: [String: Any] = ["": ""]
}
