//
//  LogInViewModel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/05/21.
//

import RxSwift
import RxCocoa

class LogInViewModel {
    
    let logInResult: Driver<Bool>
    
    init(input: (
        email: Driver<String>,
        password: Driver<String>,
        logInButtonTaps: Signal<Void>   // tap を受け取るときは Signal
    ), logInAPI: LogInModel) {
        
        // ログインの結果を受け取る, Bool
        let emailAndPassword = Driver.combineLatest(input.email, input.password) { (email: $0, password: $1) }
        logInResult = input.logInButtonTaps
            .asObservable()
            .withLatestFrom(emailAndPassword)
            .flatMapLatest { tuple in
                logInAPI.logIn(email: tuple.email, password: tuple.password)
            }
            .asDriver(onErrorJustReturn: false)
        
    }
    
    
}



