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
    
    func fetchEnterTime(uid: String, roomId: String) -> Observable<Date> {
        
        return Observable<Date>.create { observer in
            
            let timeRef = Firestore.firestore().collection("Times")
            
            timeRef
                .whereField("uid", isEqualTo: uid)
                .whereField("roomId", isEqualTo: roomId)
                .order(by: "enterAt", descending: true)
                .limit(to: 1)
                .getDocuments() { (querySnapShot, err) in
                    if let documents = querySnapShot?.documents {
                        var data = documents[0].data()
                        var enterTime: Timestamp = data["enterAt"] as! Timestamp
                        var enterTimeDate = enterTime.dateValue()
                        enterTimeDate = enterTimeDate.UTCtoJST(date: enterTimeDate)   // FireStoreから取得した時刻はUTC表示
                        print("documents.count: ", documents.count)
                        print("enterTime: ", enterTime)
                        print("enterTimeDate: ", enterTimeDate)
                        observer.onNext(enterTimeDate)
                    } else {
                        print("Document does not exist")
                        observer.onNext(Date())
                    }
                }
            
            return Disposables.create { print("Observable: Dispose") }
        }
       
    }
    
}

