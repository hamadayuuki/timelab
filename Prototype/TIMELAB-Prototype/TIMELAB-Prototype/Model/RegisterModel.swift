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
import FirebaseFirestore

// Model には Protocol を作成する
protocol RegisterModelProtocol {
    func createUserToFireAuth(emai: String, password: String) -> Observable<User>
    func createUserToFireStore(email: String, uid: String, name: String) -> Observable<Bool>
    func createLabToFireStore(university: String, department: String, course: String, lab: String) -> Observable<Bool>
}

class RegisterModel {
    init() { }
    
    // アカウント登録の状態を通知するために create を使い、アカウント登録を Observable化
    //                                                                         ↓ VM で FireStroeへユーザー情報を登録できるよう User型 で通知
    func createUserToFireAuth(name: String, email: String, password: String) -> Observable<User> {
        
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
    
    func createUserToFireStore(email: String, uid: String, name: String) -> Observable<Bool> {
        
        return Observable<Bool>.create { observer in
            
            let document = [
                "name": name,
                "email": email,
                "type": 0,
                "rooms": [],
                "times": [],
                "memos": [],
                "createAt": Timestamp(),
                "updateAt": Timestamp()
            ] as [String : Any]
            
            Firestore.firestore().collection("user").document(uid).setData(document) { err in
                if let err = err {
                    print("FireStoreへの登録に失敗: ", err)
                    observer.onNext(false)
                }
                print("FireStoreへの登録に成功")
                observer.onNext(true)
            }
            return Disposables.create {
                print("Observable: Dispose")
            }
            
        }
        
    }
    
    func createLabToFireStore(university: String, department: String, course: String, lab: String) -> Observable<Bool> {
        print("研究室登録 の処理")
        
        return Observable<Bool>.create { observer in
            
            let document = [
                "allUsers": [],
                "host": [],
                "client": [],
                "university": university,
                "department": department,
                "course": course,
                "name": lab,
                "type": 0,
                "createAt": Timestamp(),
                "updateAt": Timestamp()
            ] as [String : Any]
            
            Firestore.firestore().collection("Labs").document().setData(document) { err in
                if let err = err {
                    observer.onNext(false)
                }
                observer.onNext(true)
            }
            return Disposables.create {
                print("Observable: Dispose")
            }
        }
        
    }
    
}
