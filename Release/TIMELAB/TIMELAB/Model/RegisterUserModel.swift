//
//  RegisterUserModel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/05/10.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase
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
            return Disposables.create { print("Observable: Dispose") }
            
        }// return
    }
    
    func registerUserToFireStore(email: String, uid: String, name: String, iconName: String) -> Observable<Bool> {
        
        return Observable<Bool>.create { observer in
            
            let document = [
                "name": name,
                "email": email,
                "uid": uid,
                "iconName": iconName,
                "type": "client",   // TODO: 可変に
                "rooms": [],
                "createAt": Timestamp(),
                "updateAt": Timestamp()
            ] as [String : Any]
            
            let userRef = Firestore.firestore().collection("Users")
            userRef.document(uid).setData(document) { err in
                if let err = err {
                    print("FireStoreへの登録に失敗: ", err)
                    observer.onNext(false)
                }
                print("FireStoreへの登録に成功")
                observer.onNext(true)
            }
            return Disposables.create { print("Observable: Dispose") }
            
        }
        
    }
    
    func updateIconNameToFireStore(uid: String, iconName: String) -> Observable<Bool> {
        Observable<Bool>.create { observer in
            let updateData = ["iconName": iconName]
            
            let usersRef = Firestore.firestore().collection("Users")
            usersRef.document(uid).updateData(updateData) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                    observer.onNext(false)
                } else {
                    observer.onNext(true)
                }
            }
            return Disposables.create { print("Observable: Dispose") }
        }
    }
    
    // ユーザーの状態を登録する
    func registerUserState(roomId: String, uid: String, state: String) -> Observable<Bool> {

        return Observable<Bool>.create { observer in
            if uid == "" { observer.onNext(false) }   // 例外処理
            
            let usersRef = Firestore.firestore().collection("Users")
            let setData = [
                "state": state
            ]
            
            usersRef.document(uid).collection("States").document(roomId).setData(setData) { err in
                if let err = err {
                    observer.onNext(false)
                }
                observer.onNext(true)
            }
            return Disposables.create { print("Observable: Dispose") }
        }
        
    }
    
    func registerRoomToUsers(roomId: String, uid: String) -> Observable<Bool> {
        print("M: ", #function)
        print("roomId: ", roomId, "   , uid: ", uid)
        
        return Observable<Bool>.create { observer in
            let userRef = Firestore.firestore().collection("Users").document(uid)
            
            userRef.setData(["rooms": FieldValue.arrayUnion([roomId])], merge: true) { err in
                if let err = err { observer.onNext(false) }
                observer.onNext(true)
            }
            return Disposables.create { print("Observable: Dispose") }
        }
        
    }
    
    func registerCurrentStayingRoom(roomId: String, uid: String) -> Observable<Bool> {
        print("M: ", #function)
        print("roomId: ", roomId, "   , uid: ", uid)
        
        return Observable<Bool>.create { observer in
            let userRef = Firestore.firestore().collection("Users").document(uid)
            
            userRef.setData(["currentStayingRoom": roomId], merge: true) { err in
                if let err = err { observer.onNext(false) }
                observer.onNext(true)
            }
            return Disposables.create { print("Observable: Dispose") }
        }
        
    }
    
    // MARK: Firebase Dynamic Links
    
    func createActionCodeSettings() -> ActionCodeSettings {
        let dynamicLinkUrl = "https://timelab.page.link"
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: dynamicLinkUrl)
        // The sign-in operation has to always be completed in the app.
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        return actionCodeSettings
    }
    
    func sendSingInLink(name: String, email: String, password: String) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            let actionCodeSettings = self.createActionCodeSettings()
            
            Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { error in
                if let error = error {
                    print("sendSignInLInk Error")
                    observer.onNext(false)
                }
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set(password, forKey: "password")
                observer.onNext(true)
                print("success sendSignInLink")
            }
            return Disposables.create { print("Observable: Dispose") }
        }
    }
    
}
