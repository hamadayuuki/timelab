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
    
    func setEmailAndPassword() {
//        self.email = UserDefaults.standard.string(forKey: "email")
//        self.password = UserDefaults.standard.string(forKey: "password")
        
        self.email = "haruni.hamada@gmail.com"
        self.password = "haruniharuni"
    }
    
    func registerUserToAuth() async throws {
        do {
            let authResult = try await self.registerUserModel.registerUserToFireAuth(email: self.email, password: self.password)
            self.authResult.onNext(authResult)
        } catch {
            self.authResult.onNext(false)
        }
    }
    
    func registerUserToStore() {
        
    }
}
