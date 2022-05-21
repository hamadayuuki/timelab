//
//  LogInModel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/05/21.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth

class LogInModel {
    init() { }
    
    func logIn(email: String, password: String) -> Observable<Bool> {
        
        return Observable<Bool>.create { observer in
            
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                
                if let error = error { observer.onNext(false) }
                if let user = authResult?.user {
                    observer.onNext(true)
                }
                
            }
            
            return Disposables.create { print("Observable: Dispose") }
        }
        
    }
    
}
