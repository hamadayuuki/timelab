//
//  CheckRegisterUserViewModel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2023/06/11.
//

import RxSwift

@MainActor
class CheckRegisterUserViewModel {
    let registerUserModel = RegisterUserModel()
    
    var email = ""
    var password = ""
    
    var authResult = PublishSubject<Bool>()
    var storeResult = PublishSubject<Bool>()
    
    func setEmailAndPassword() {
//        self.email = UserDefaults.standard.string(forKey: "email")
//        self.password = UserDefaults.standard.string(forKey: "password")
        
        self.email = "user0000@gmail.com"
        self.password = "user0000"
    }
    
    func registerUserToAuth() async throws {
        do {
            let authResult = try await self.registerUserModel.registerUserToFireAuth(email: self.email, password: self.password)
            self.authResult.onNext(authResult)
        } catch {
            self.authResult.onNext(false)
        }
    }
    
    // TODO: 引数でデータを受け取らないように変更, VMの変数に値を代入し使用(例: email, password)
    func registerUserToStore(uid: String, name: String, iconName: String) async throws {
        do {
            let storeResult = try await self.registerUserModel.registerUserToFireStore(email: self.email, uid: uid, iconName: iconName)
            self.storeResult.onNext(storeResult)
        } catch {
            self.storeResult.onNext(false)
        }
    }
}
