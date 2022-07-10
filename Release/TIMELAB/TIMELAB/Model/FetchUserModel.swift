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
    
}
