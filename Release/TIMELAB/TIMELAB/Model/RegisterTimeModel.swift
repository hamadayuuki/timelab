//
//  RegisterTimeModel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/07/10.
//

import Firebase
import FirebaseFirestore
import RxSwift
import RxCocoa
import UIKit

class RegisterTimeModel {
    
    func registerTimeWhenEnter(uid: String, roomId: String) -> Observable<Bool> {
        print(#function)
        
        return Observable<Bool>.create { observer in
            let enterTime = Timestamp()
            var enterTimeDate = enterTime.dateValue()
            let setData: [String: Any] = [
                "enterAt": enterTime,
                "leaveAt": enterTime,
                "year": Calendar.current.component(.year, from: enterTimeDate),
                "month": Calendar.current.component(.month, from: enterTimeDate),
                "day": Calendar.current.component(.day, from: enterTimeDate),
                "uid": uid,
                "roomId": roomId,
                "stayingTimeAtSecond": 0
            ]
            
            let timesRef = Firestore.firestore().collection("Times").document()
            timesRef.setData(setData) { err in
                if let err = err { observer.onNext(false) }
                observer.onNext(true)
            }
            return Disposables.create { print("Observable: Dispose") }
        }
    }
    
    func registerTimeWhenLeave(uid: String, roomId: String, timeId: String, enterTimeDate: Date) -> Observable<Bool> {
        
        return Observable<Bool>.create { observer in
            let leaveTime = Timestamp()
            let leaveTimeDate = leaveTime.dateValue()
            let diffEnterToLeaveSecond = Int(leaveTimeDate.timeIntervalSince(enterTimeDate))
            let updateData: [String: Any] = [
                "leaveAt": leaveTime,
                "stayingTimeAtSecond": diffEnterToLeaveSecond
            ]
            
            let timesRef = Firestore.firestore().collection("Times").document(timeId)
            timesRef.updateData(updateData) { err in
                if let err = err { observer.onNext(false) }
                observer.onNext(true)
            }
            return Disposables.create { print("Observable: Dispose") }
        }
    }
    
    /*
    func registerEnterTime(name: String, uid: String, roomId: String) -> Observable<Bool> {
        
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
     */
    
}
