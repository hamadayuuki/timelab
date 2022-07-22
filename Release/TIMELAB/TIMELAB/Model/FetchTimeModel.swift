//
//  FetchTimeModel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/07/15.
//

import Firebase
import FirebaseFirestore
import FirebaseAuth
import RxSwift
import RxCocoa
import UIKit

class FetchTimeModel {
    
    func fetchEnterTime(uid: String, roomId: String) -> Observable<[String: Any]> {
        
        return Observable<[String: Any]>.create { observer in
            
            let timeRef = Firestore.firestore().collection("Times")
            
            timeRef
                .whereField("uid", isEqualTo: uid)
                .whereField("roomId", isEqualTo: roomId)
                .order(by: "enterAt", descending: true)
                .limit(to: 1)
                .getDocuments() { (querySnapShot, err) in
                    if let documents = querySnapShot?.documents {
                        let data = documents[0].data()
                        let enterTime: Timestamp = data["enterAt"] as! Timestamp
                        var enterTimeDate = enterTime.dateValue()
//                        enterTimeDate = enterTimeDate.UTCtoJST(date: enterTimeDate)   // FireStoreから取得した時刻はUTC表示
                        let timeId = documents[0].documentID
                        let returnData: [String: Any] = ["enterTimeDate": enterTimeDate, "timeId": timeId]
//                        print("documents.count: ", documents.count)
//                        print("enterTime: ", enterTime)
//                        print("enterTimeDate: ", enterTimeDate)
                        observer.onNext(returnData)
                    } else {
                        print("Document does not exist")
                        observer.onNext(["enterTimeDate": Data(), "timeId": ""])
                    }
                }
            
            return Disposables.create { print("Observable: Dispose") }
        }
       
    }
    
}

