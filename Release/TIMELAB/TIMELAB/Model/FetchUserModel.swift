//
//  FetchUserModel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/07/10.
//

import Firebase
import FirebaseFirestore
import FirebaseAuth
import RxSwift
import RxCocoa
import UIKit

class FetchUserModel {
    
    func fetchUserId() -> Observable<String> {
        
        return Observable<String>.create { observer in
            
            if let user = Auth.auth().currentUser  {
                observer.onNext(user.uid)
            }
            observer.onNext("")
            
            return Disposables.create { print("Observable: Dispose") }
        }
       
    }
    
    
    func fetchUser(uid: String) -> Observable<[String: Any]> {
        print(#function)
        
        return Observable<[String: Any]>.create { observer in
            // FireStore からデータの取得
            let db = Firestore.firestore()
            db.collection("Users").document(uid).getDocument { (document, err) in
               if let document = document {
                   if let data = document.data() {
                       print("data: ", data)
                       observer.onNext(data)
                   } else {
                       observer.onNext(["": ""])
                   }
                } else {
                    print("Document does not exist")
                    observer.onNext(["": ""])
                }
            }
            
            return Disposables.create { print("Observable: Dispose") }
        }
    }
    
    func fetchUserState(uid: String, roomId: String) -> Observable<String> {
        print(#function)
        
        return Observable<String>.create { observer in
            // FireStore からデータの取得
            let db = Firestore.firestore()
            let usersRef = db.collection("Users").document(uid)
            let statesRef = usersRef.collection("States")
            statesRef.document(roomId).getDocument { (document, err) in
               if let document = document {
                   var data = document.data()!
                   let state = data["state"] as! String
                   observer.onNext(state)
                } else {
                    print("Document does not exist")
                    observer.onNext("")
                }
            }
            
            return Disposables.create { print("Observable: Dispose") }
        }
    }
    
}
