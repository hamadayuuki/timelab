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
    
    func fetchMonthCalendarTime(/*uid: String, roomId: String, year: Int, month: Int*/) -> Observable<[[String: Any]]> {
        
        return Observable<[[String: Any]]>.create { observer in
            
            let uid = "Z1jmr9PECugcUek8bV1hvgW8kbF2"
            let roomId = "v43x0A079YBnPFj8jkyo"
            let year = 2022
            let month = 8
            
            let timeRef = Firestore.firestore().collection("Times")
            
            timeRef
                .whereField("uid", isEqualTo: uid)
                .whereField("roomId", isEqualTo: roomId)
                .whereField("year", isEqualTo: year)
                .whereField("month", isEqualTo: month)
                .order(by: "enterAt", descending: false)   // 昇順, 1 2 3 4 5
                .getDocuments() { (querySnapShot, err) in
                    // TODO: resultList を簡潔に
                    if let documents = querySnapShot?.documents {
                        var resultList: [[String: Any]] = []
                        for document in documents {
                            let data = document.data()
                            let enterTime: Timestamp = data["enterAt"] as! Timestamp
                            let enterTimeDate = enterTime.dateValue()
    //                        enterTimeDate = enterTimeDate.UTCtoJST(date: enterTimeDate)   // FireStoreから取得した時刻はUTC表示
                            let stayingTimeAtSecond = data["stayingTimeAtSecond"] as! Int
                            let appendDic: [String: Any] = ["enterTimeDate": enterTimeDate, "stayingTimeAtSecond": stayingTimeAtSecond]
                            resultList.append(appendDic)
                        }
                        observer.onNext(resultList)
                    } else {
                        print("Document does not exist")
                        observer.onNext([["enterTimeDate": Data(), "timeId": ""]])
                    }
                }
            
            return Disposables.create { print("Observable: Dispose") }
        }
       
    }
    
}

