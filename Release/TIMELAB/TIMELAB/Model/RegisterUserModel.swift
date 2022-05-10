//
//  RegisterUserModel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/05/10.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

class RegisterUserModel {
    init() { }
    
    // アカウント登録の状態を通知するために create を使い、アカウント登録を Observable化
    //                                                                         ↓ VM で FireStroeへユーザー情報を登録できるよう User型 で通知
    func registerUserToFireAuth(name: String, email: String, password: String) -> Observable<User> {
        
        return Observable<User>.create { observer in
            // FireAuth への登録, email/password のチェックは完了している
            Auth.auth().createUser(withEmail: email, password: password) { (auth, err) in
                if let err = err {
                    print("登録失敗: ", err)
                    let user = User(name: "", email: "", uid: "", isValid: false)
                    observer.onNext(user)
                }
                
                guard let uid = auth?.user.uid else { return }
                print("登録成功: ", uid)
                let user = User(name: name, email: email, uid: uid, isValid: true)
                observer.onNext(user)
            }
            return Disposables.create {
                print("Observable: Dispose")
            }
            
        }// return
    }
    
}
