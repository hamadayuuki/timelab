//
//  QrScanModel.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/25.
//

import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth
import FirebaseFirestore

class QrScanModel {
    init() { }
    
    func checkAndRegistRoom(roomId: String) {
        let db = Firestore.firestore()
        let uid = "D5X29pC9eoXlDrxxpKaBLw4pq0h1"   // アカウントは指定, TODO: FireAuthのログイン機能を使用して uid を取得し使用する
        
        // 研究室/部屋 への入退室を行うための 対象ユーザーに研究室/部屋が登録されているか確認, 登録
        db.collection("user").document(uid).getDocument { (document, err) in
            if let document = document {
                let data = document.data()
                let roomsArray: Array<String> = data?["rooms"] as? Array<String> ?? [""]
                print("roomsArray: ", roomsArray)
                print("type(of: roomsArray): ", type(of: roomsArray))
                if !roomsArray.contains(roomId) {
                    print("部屋を追加")
                    db.collection("user").document(uid).updateData([
                        "rooms": FieldValue.arrayUnion([roomId])
                    ])
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}
