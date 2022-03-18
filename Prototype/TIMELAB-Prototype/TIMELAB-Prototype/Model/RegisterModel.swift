//
//  RegisterModel.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/18.
//

import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth

// Model には Protocol を作成する
protocol FireAuthModelProtocol {
    func createUserToFireAuth(emai: String, password: String) -> Observable<Bool>
}

class FireAuthModel {
    init() { }
    
    // アカウント登録の状態を通知するために create を使い、アカウント登録を Observable化
    //                                                            ↓ 完了を Bool で通知する
    func createUserToFireAuth(email: String, password: String) -> Observable<Bool> {
        print("email: ", email)
        print("password: ", password)
        
        return Observable<Bool>.create { observer in
            // FireAuth への登録, email/password のチェックは完了している
            Auth.auth().createUser(withEmail: email, password: password) { (auth, err) in
                if let err = err {
                    print("登録失敗: ", err)
                    observer.onNext(false)
                }
                
                guard let uid = auth?.user.uid else { return }
                print("登録成功: ", uid)
                observer.onNext(true)
            }
            return Disposables.create {
                print("Observable: Dispose")
            }
            
        }// return
    }
    
}
