//
//  QrScanModel.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/25.
//

// TODO: FireStore を使う時の プログラム順 を揃える (例: dbを定義 → documentを定義 → ・・・)
// TODO: 本番用のプロジェクトでは、RegisterEnterRoomModel.swift, RegisterLeaveRoomModel.swift, ... とファイルを区別する
// TODO: 全ての関数を Protocol で宣言する

import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth
import FirebaseFirestore

protocol checkAndRegistRoomProtocol {
    func checkAndRegistRoomToUser(roomId: String) -> Observable<Bool>
    func registerEnterTime() -> Observable<Bool>
}

class QrScanModel {
    init() { }
    
    // 研究室/部屋 への入退室を行うための 対象ユーザーに研究室/部屋が登録されているか確認, 登録
    func checkAndRegistRoomToUser(roomId: String) -> Observable<Bool> {
        print("M, checkAndRegistRoomToUser()")
        
        return Observable<Bool>.create { observer in
            if let user = Auth.auth().currentUser {
                let uid = user.uid
                
                // FireStore からデータの取得
                let db = Firestore.firestore()
                db.collection("Users").document(uid).getDocument { (document, err) in
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
                db.collection("Users").document(uid).getDocument { (document, err) in
                   if let document = document {
                       var data = document.data()
                       data?.updateValue(uid, forKey: "uid")   // ["uid": "~~~"] を追加, 入室時にuidを使うため
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
    
    func registerEnterTime(name: String, uid: String, roomId: String) -> Observable<Bool> {
        print("M, registerEnterTime, name: ", name)
        print("M, registerEnterTime, uid: ", uid)
        
        return Observable<Bool>.create { observer in
            let db = Firestore.firestore()
            let timestamp = Timestamp()
            let timeDate = timestamp.dateValue()
            let enterTimeArray = self.createTimeArray(timeDate: timeDate)
            let timesDocumentId = enterTimeArray["year"]! + enterTimeArray["month"]! + enterTimeArray["day"]! + enterTimeArray["hour24"]! + enterTimeArray["minute"]!
            let userRef = db.collection("Users").document(uid)
            let timesRef = userRef.collection("Times").document(timesDocumentId)   // "ref" を保存するため宣言
            
            let document = [
                "name": name,
                "uid": uid,
                "enterAt": timestamp,
                "enterTime": enterTimeArray,
                "roomId": roomId,
                "ref": timesRef,   // 退出時 どのフィールドに書き込むか指定するために使用
                "creatAt": timestamp
            ] as [String : Any]
            
            // TODO: Roomsコレクション に登録するよう変更
            // サブコレクション("Times") への登録
            timesRef.setData(document) {  err in
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
    
    // 退室時刻を登録するときに使用する リファレンス を取得する
    // 扱いやすいように 通知を[String: Any] にする
    func fetchLatestTimesRefAndRoomId(uid: String) -> Observable<[String: Any]?> {
        print("M, fetchLatestTimesRefAndRoomId()")
        
        return Observable<[String: Any]?>.create { observer in
            let db = Firestore.firestore()
            
            let timesRef = db.collection("Users").document(uid).collection("Times")
            timesRef.order(by: "creatAt", descending: true).limit(to: 1).getDocuments { (documents, err) in
                if let err = err {
                    print("User/Times コレクションから creatAt最新の値を取得するとき err発生: ", err)
                    observer.onCompleted()   // DocumentReferenceの戻り値なし のため使用
                } else {
                    let document = documents?.documents[0]   // [0] のみ存在
                    let data = document?.data()
                    let latestTimesRef: DocumentReference = data?["ref"] as! DocumentReference   // documents が読み込めている時点で存在しているため、エラーはない
                    let roomId = data?["roomId"] as? String ?? ""
                    observer.onNext(["ref": latestTimesRef, "roomId": roomId])
                }
            }
            
            return Disposables.create {
                print("Observable: Dispose")
            }
        }
        
    }
    
    func registerLeaveTime(uid: String, latestTimesRef: DocumentReference) -> Observable<Bool> {
        print("M, registerLeaveTime()")
        
        return Observable<Bool>.create { observer in
            let db = Firestore.firestore()
            let userRef = db.collection("Users").document(uid)
            let timestamp = Timestamp()
            let timeDate = timestamp.dateValue()
            let leaveTimeArray = self.createTimeArray(timeDate: timeDate)
            
            let document = [
                "leaveAt": Timestamp(),
                "leaveTime": leaveTimeArray
            ] as [String : Any]
            
            // サブコレクション("Times") への登録
            //                               ↓ これがないとフィールド全体が上書きされる, 追加 ではなく 上書きになってしまう
            latestTimesRef.setData(document, merge: true) {  err in
                if let err = err { observer.onNext(false) }
                print("FireStoreへの登録に成功")
            }
            
            // 滞在状態(state) を変更
            let stateDocument = ["state": "returnHome"]
            userRef.updateData(stateDocument) { stateErr in
                if let stateErr = stateErr { observer.onNext(false) }
                print("stete の更新に成功")
                observer.onNext(true)
            }
            
            return Disposables.create {
                print("Observable: Dispose")
            }
        }
        
    }
    
    // Rooms にユーザーを登録する
    func registerUserToRooms(/*roomId: String, uid: String, type: String*/) -> Observable<Bool> {
        print("M, registerUserToRooms()")

        return Observable<Bool>.create { observer in

            let roomId = "4BpVWmwhFCViM4xIyILB"
            let uid = "aaa"
            let type = "client"
            let roomsRef = Firestore.firestore().collection("Rooms").document(roomId)
            let updateData = [
                "allUsers": FieldValue.arrayUnion([uid]),
                type + "s":  FieldValue.arrayUnion([uid])
            ]
            
            roomsRef.updateData(updateData) { err in
                if let err = err {
                    observer.onNext(false)
                }
                observer.onNext(true)
            }
            return Disposables.create {
                print("Observable: Dispose")
            }
        }
        
    }
    
    // Rooms/userState にユーザーの状態を登録する
    func registerUserStateToRooms(/*roomId: String, uid: String, */state: String) -> Observable<Bool> {
        print("M, registerUserStateToRooms()")

        return Observable<Bool>.create { observer in

            let roomId = "4BpVWmwhFCViM4xIyILB"
            let uid = "aaa"
            let roomsRef = Firestore.firestore().collection("Rooms").document(roomId)
            
            roomsRef.collection("UsersState").document(uid).setData(["state": state]) { err in
                if let err = err {
                    observer.onNext(false)
                }
                observer.onNext(true)
            }
            return Disposables.create {
                print("Observable: Dispose")
            }
        }
        
    }
    
    // FireAuth のログイン情報記録機能 を使用し uid を取得、その後 FireStore からデータを取得している
    func fetchUsersStateFromRooms() -> Observable<String> {
        print(#function)
        
        return Observable<String>.create { observer in
            
            let roomId = "4BpVWmwhFCViM4xIyILB"
            let uid = "aaa"
            let roomsRef = Firestore.firestore().collection("Rooms").document(roomId)
            let userStateRef = roomsRef.collection("UsersState").document(uid)
            
            userStateRef.getDocument { (document, err) in
               if let document = document {
                   let data = document.data()
                   let state = data?["state"] as? String ?? ""
                   observer.onNext(state)
                } else {
                    print("Document does not exist")
                    observer.onNext("")
                }
            }
            return Disposables.create {
                print("Observable: Dispose")
            }
        }
        
    }
    
    // ["year": "2022", "month": "03", "day": "26", "hour24": "01", "minute": "38", "second": "34", "week": "土"] ← 2022年 3月 26日 1:38:34 (土)
    // 曜日以外: 0パディングあり, 全要素: String型
    func createTimeArray(timeDate: Date) -> [String: String] {
        
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
        
        // 2022年 3月 26日 1:38 (土)
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: timeDate)   // 2022
        print(formatter.string(from: timeDate))
        
        formatter.dateFormat = "MM"
        let month = formatter.string(from: timeDate)   // 03
        
        formatter.dateFormat = "dd"
        let day = formatter.string(from: timeDate)   // 26
        
        formatter.dateFormat = "HH"   // 24時間表記
        let hour24 = formatter.string(from: timeDate)   // 01
        
        formatter.dateFormat = "mm"
        let minute = formatter.string(from: timeDate)   // 38
        
        formatter.dateFormat = "ss"
        let second = formatter.string(from: timeDate)   // 34
        
        formatter.dateFormat = "E"
        let week = formatter.string(from: timeDate)   // 土
        
        return ["year": year, "month": month, "day": day, "hour24": hour24, "minute": minute, "second": second, "week": week]
    }
}
