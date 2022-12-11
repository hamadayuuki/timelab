//
//  DeleteUserModel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/12/11.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth

class DeleteUserModel {
    init() { }
    
    func deleteUserFireStore(uid: String) -> Observable<Bool> {
        print(#function)
        
        return Observable<Bool>.create { observer in
            let userRef = Firestore.firestore().collection("Users")
            userRef.document(uid).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                    observer.onNext(false)
                } else {
                    print("Document successfully removed!")
                    observer.onNext(true)
                }
            }
            return Disposables.create { print("Observable: Dispose") }
        }// return
        
    }
    
    func deleteUserFireAuth() -> Observable<Bool> {
        print(#function)
        
        return Observable<Bool>.create { observer in
            let user = Auth.auth().currentUser

            user?.delete { error in
              if let error = error {
                  print("error deleteUserFireAuth")
                  observer.onNext(false)
              } else {
                  print("success deleteUserFireAuth")
                  observer.onNext(true)
              }
            }
            return Disposables.create { print("Observable: Dispose") }
            
        }// return
        
    }
}
