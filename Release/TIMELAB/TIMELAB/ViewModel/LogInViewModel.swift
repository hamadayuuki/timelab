//
//  LogInViewModel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/05/21.
//

import RxSwift
import RxCocoa

class LogInViewModel {
    
    let logInResult: Driver<LogInResult>
    let logInEmailValidation: Driver<Bool>
    let logInPasswordValidation: Driver<Bool>
    let canLogIn: Driver<Bool>
    
    init(input: (
        email: Driver<String>,
        password: Driver<String>,
        logInButtonTaps: Signal<Void>   // tap を受け取るときは Signal
    ), logInAPI: LogInModel) {
        
        // TextField の状態からログイン準備が整っているか確認, canLogIn を ログインボタンの状態変化で使用
        let validationModel = ValidationModel()
        logInEmailValidation = input.email
            .map { email in
                validationModel.validateLogInEmail(email: email)
            }
        logInPasswordValidation = input.password
            .map { password in
                validationModel.validateLogInPassword(password: password)
            }
        canLogIn = Driver.combineLatest(logInEmailValidation, logInPasswordValidation) { (email, password) in
            validationModel.validateCanLogIn(email: email, password: password)
        }
        .distinctUntilChanged()
        
        // ログインの結果を受け取る, Bool
        let emailAndPassword = Driver.combineLatest(input.email, input.password) { (email: $0, password: $1) }
        logInResult = input.logInButtonTaps
            .asObservable()
            .withLatestFrom(emailAndPassword)
            .flatMapLatest { tuple in
                logInAPI.logIn(email: tuple.email, password: tuple.password)
            }
            .asDriver(onErrorJustReturn: LogInResult(errorMessage: "", isLogIn: false))
        
    }
    
    
}



