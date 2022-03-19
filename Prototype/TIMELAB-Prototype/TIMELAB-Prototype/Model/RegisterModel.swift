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
        print("name: ", name)
        print("email: ", email)
        print("password: ", password)
        
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
        print("FireStoreへユーザー登録")
        
        return Observable<Bool>.create { observer in
            
            let document = [
                "name": name,
                "email": email,
                "createAt": Timestamp()
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
            
            /*
             研究室登録の処理 を書く
             */
            
            // 3.0秒間 待機してから true を通知
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                observer.onNext(true)
            }
            return Disposables.create {
                print("Observable: Dispose")
            }
        }
        
    }
    
//    func createLabToFireStore(university: String, department: String, course: String, lab: String) -> Observable<Bool> {
//        print("university: ", university)
//        print("department: ", department)
//        print("course: ", course)
//        print("lab: ", lab)
//
//        return Observable<Bool>.create { observer in
//            // FireAuth への登録, email/password のチェックは完了している
//            Auth.auth().createUser(withEmail: email, password: password) { (auth, err) in
//                if let err = err {
//                    print("登録失敗: ", err)
//                    observer.onNext(false)
//                }
//
//                guard let uid = auth?.user.uid else { return }
//                print("登録成功: ", uid)
//                observer.onNext(true)
//            }
//            return Disposables.create {
//                print("Observable: Dispose")
//            }
//
//        }// return
//    }
    
}
