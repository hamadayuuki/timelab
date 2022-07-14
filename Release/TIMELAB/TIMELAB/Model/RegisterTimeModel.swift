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
