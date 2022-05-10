//
//  RegisterUserViewModel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/05/10.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterUserViewModel {
    let nameValidation: Driver<ValidationResult>
    let emailValidation: Driver<ValidationResult>
    let passwordValidation: Driver<ValidationResult>
    let passwordConfirmValidation: Driver<ValidationResult>
    
    let disposeBag = DisposeBag()   // ここで初期化しないと 処理が走らない場合あり
    
    // input: V から通知を受け取れるよう、初期化
    init(input: (
        name: Driver<String>,
        email: Driver<String>,
        password: Driver<String>,
        passwordConfirm: Driver<String>,
        signUpTaps: Signal<Void>   // tap を受け取るときは Signal
    )) {
        // M とのつながり
        let validationModel = ValidationModel()
        
        // V からの通知(データも?)を受け取り M に処理を任せる, V から呼ばれることでデータ送信(VM→V)を行える
        nameValidation = input.name
            .map { name in
                validationModel.ValidateName(name: name)
            }
        emailValidation = input.email
            .map { email in
                validationModel.ValidateEmail(email: email)
            }
        passwordValidation = input.password
            .map { password in
                validationModel.ValidatePassword(password: password)
            }
        passwordConfirmValidation = Driver.combineLatest(input.password, input.passwordConfirm)
            .map { (password, passwordConfirm) in
                validationModel.ValidatePasswordConfirm(password: password, passwordConfirm: passwordConfirm)
            }
        
    }
    
}



