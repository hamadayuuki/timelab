//
//  LogOutModel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/12/09.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth

class LogOutModel {
    init() { }
    
    func logOut() -> Observable<Bool> {
        print(#function)
        
        return Observable<Bool>.create { observer in
            do {
                try Auth.auth().signOut()
                observer.onNext(true)
            } catch let signOutError as NSError {
                print("Error signing")
                observer.onNext(false)
            }
            observer.onNext(false)
            return Disposables.create { print("Observable: Dispose") }
        }
        
    }
    
}

