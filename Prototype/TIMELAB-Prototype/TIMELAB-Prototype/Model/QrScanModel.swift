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

protocol checkAndRegistRoomProtocol {
    func checkAndRegistRoom(roomId: String) -> Observable<Bool>
    func registerEnterTime() -> Observable<Bool>
}

class QrScanModel {
    init() { }
    
    // 研究室/部屋 への入退室を行うための 対象ユーザーに研究室/部屋が登録されているか確認, 登録
    func checkAndRegistRoom(roomId: String) -> Observable<Bool> {
        
        return Observable<Bool>.create { observer in
            if let user = Auth.auth().currentUser {
                let uid = user.uid
                
                // FireStore からデータの取得
                let db = Firestore.firestore()
                db.collection("user").document(uid).getDocument { (document, err) in
                    if let err = err {
                        print("err: ", err)
                        observer.onNext(false)
                    }
                    if let document = document {
                        let data = document.data()
                        let roomsArray: Array<String> = data?["rooms"] as? Array<String> ?? [""]   // "rooms" の要素を配列で取得
                        print("roomsArray: ", roomsArray)
                        print("type(of: roomsArray): ", type(of: roomsArray))
                        // 新たに 研究室/部屋 を登録
                        if !roomsArray.contains(roomId) {
                            print("部屋を追加")
                            db.collection("user").document(uid).updateData([
                                "rooms": FieldValue.arrayUnion([roomId])
                            ])
                        }
                        observer.onNext(true)
                    } else {
                        print("Document does not exist")
                        observer.onNext(false)
                    }
                }
            }
            return Disposables.create {
                print("Observable: Dispose")
            }
        }
        
    }
    
    // FireAuth のログイン情報記録機能 を使用し uid を取得、その後 FireStore からデータを取得している
    func fetchUser() -> Observable<[String: Any]?> {
        print(#function)
        
        return Observable<[String: Any]?>.create { observer in
            if let user = Auth.auth().currentUser {
                let uid = user.uid

                // FireStore からデータの取得
                let db = Firestore.firestore()
                db.collection("user").document(uid).getDocument { (document, err) in
                   if let document = document {
                       var data = document.data()
                       data?.updateValue(uid, forKey: "uid")   // 入室時にuidを使うため
                       observer.onNext(data)
                    } else {
                        print("Document does not exist")
                        observer.onNext(["": ""])
                    }
                }
            } else {
                print("現在、ログイン中でない")
                observer.onNext(["": ""])
            }
            return Disposables.create {
                print("Observable: Dispose")
            }
        }
        
    }
    
    func registerEnterTime(name: String, uid: String) -> Observable<Bool> {
        print("M, registerEnterTime, name: ", name)
        print("M, registerEnterTime, uid: ", uid)
        
        return Observable<Bool>.create { observer in
            let db = Firestore.firestore()
            let timestamp = Timestamp()
            let timeDate = timestamp.dateValue()
            let enterTimeArray = self.createTimeArray(timeDate: timeDate)
            let timesDocumentId = enterTimeArray["year"]! + enterTimeArray["month"]! + enterTimeArray["day"]! + enterTimeArray["hour24"]! + enterTimeArray["minute"]!
            
            let document = [
                "name": name,
                "uid": uid,
                "enterAt": timestamp,
                "enterTime": enterTimeArray
            ] as [String : Any]
            
            // サブコレクション("Times") への登録
            let userRef = db.collection("user").document(uid)
            userRef.collection("Times").document(timesDocumentId).setData(document) {  err in
                if let err = err { observer.onNext(false) }
                print("FireStoreへの登録に成功")
            }
            
            // 滞在状態(state) を変更
            userRef.updateData(["state": "stay"]) { stateErr in
                if let stateErr = stateErr { observer.onNext(false) }
                print("stete の更新に成功")
                observer.onNext(true)
            }
            
            return Disposables.create {
                print("Observable: Dispose")
            }
        }
        
    }
    
    func registerLeaveTime() {
        let db = Firestore.firestore()
        let uid = "D5X29pC9eoXlDrxxpKaBLw4pq0h1"
        let timestamp = Timestamp()
        let timeDate = timestamp.dateValue()
        let leaveTimeArray = createTimeArray(timeDate: timeDate)
        
        let document = [
            "leaveAt": Timestamp(),
            "leaveTime": leaveTimeArray
        ] as [String : Any]
        //                                                     ↓ これがないとフィールド全体が上書きされる, 追加 ではなく 上書きになってしまう
        db.collection("times").document(uid).setData(document, merge: true) { err in
            if let err = err { print("FireStoreへの退室時刻登録に失敗: ", err) }
            print("FireStoreへの退室時刻登録に成功")
        }
        
        // "state" の更新
        let stateDocument = ["state": "returnedHome"]
        db.collection("times").document(uid).updateData(stateDocument) { err in
            if let err = err { print("FireStoreへの退室時刻登録に失敗: ", err) }
            print("FireStoreの 'state'更新 に成功")
        }
    }
    
    // ["year": "2022", "month": "3", "day": "26", "hour24": "1", "minute": "38", "second": "34", "week": "土"] ← 2022年 3月 26日 1:38:34 (土)
    func createTimeArray(timeDate: Date) -> [String: String] {
        
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
        
        // 2022年 3月 26日 1:38 (土)
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: timeDate)   // 2022
        print(formatter.string(from: timeDate))
        
        formatter.dateFormat = "M"
        let month = formatter.string(from: timeDate)   // 3
        
        formatter.dateFormat = "d"
        let day = formatter.string(from: timeDate)   // 26
        
        formatter.dateFormat = "H"   // 24時間表記
        let hour24 = formatter.string(from: timeDate)   // 1
        
        formatter.dateFormat = "m"
        let minute = formatter.string(from: timeDate)   // 38
        
        formatter.dateFormat = "s"
        let second = formatter.string(from: timeDate)   // 34
        
        formatter.dateFormat = "E"
        let week = formatter.string(from: timeDate)   // 土
        
        return ["year": year, "month": month, "day": day, "hour24": hour24, "minute": minute, "second": second, "week": week]
    }
}
