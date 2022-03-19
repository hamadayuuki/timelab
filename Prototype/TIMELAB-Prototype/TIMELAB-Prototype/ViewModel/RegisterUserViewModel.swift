//
//  RegisterUserViewModel.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/19.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterUserViewModel {
    let nameValidation: Driver<ValidationResult>
    let emailValidation: Driver<ValidationResult>
    let passwordValidation: Driver<ValidationResult>
    let passwordConfirmValidation: Driver<ValidationResult>
    
    let signUpResult: Observable<User>
    let isSignUp: Driver<Bool>
    let canSignUp: Driver<Bool>
    let isUserToFireStore: Driver<Bool>
    
    let disposeBag = DisposeBag()   // ここで初期化しないと 処理が走らない場合あり
    
    // input: V から通知を受け取れるよう、初期化
    init(input: (
        name: Driver<String>,
        email: Driver<String>,
        password: Driver<String>,
        passwordConfirm: Driver<String>,
        signUpTaps: Signal<Void>   // tap を受け取るときは Signal
    ), signUpAPI: RegisterModel) {
        
        // M とのつながり
        let registerModel = RegisterUserValidationModel()
        
        // V からの通知(データも?)を受け取り M に処理を任せる, V から呼ばれることでデータ送信(VM→V)を行える
        nameValidation = input.name
            .map { name in
                registerModel.ValidateName(name: name)
            }
        emailValidation = input.email
            .map { email in
                registerModel.ValidateEmail(email: email)
            }
        passwordValidation = input.password
            .map { password in
                registerModel.ValidatePassword(password: password)
            }
        passwordConfirmValidation = Driver.combineLatest(input.password, input.passwordConfirm)
            .map { (password, passwordConfirm) in
                registerModel.ValidatePasswordConfirm(password: password, passwordConfirm: passwordConfirm)
            }
        
        // アカウント作成
        let nameAndEmailAndPassword = Driver.combineLatest(input.name, input.email, input.password) { (name: $0, email: $1, password: $2) }
        signUpResult = input.signUpTaps
            .asObservable()
            .withLatestFrom(nameAndEmailAndPassword)
            .flatMapLatest { tuple in
                signUpAPI.createUserToFireAuth(name: tuple.name, email: tuple.email, password: tuple.password)   // User型 で返ってくる
            }
            .share(replay: 1)
        
        // M でのアカウント登録結果を受け取り、V に渡している, M→VM, VM→M
        //         ↓ Observable<User>
        isSignUp = signUpResult
            .filter { $0 != nil }
            .map { user in return user.isValid }
            .asDriver(onErrorJustReturn: false )
        
        // TODO: FireStore での登録が行われるよう変更
        // ユーザー情報を FireStore へ登録できたか V へ通知
        isUserToFireStore = signUpResult
            .filter { $0 != nil }
            .map { user in
                if user.isValid {
                    /*let isUserToFireStore = */signUpAPI.createUserToFireStore(email: user.email, uid: user.uid, name: user.name)
                    return true   // TODO: FireStoreへの登録結果を使用する
                }
                return false
            }
            .asDriver(onErrorJustReturn: false)
            
        
        // アカウント作成可能か
        // ! ここに isSignUp をいれないと、アカウント登録が呼ばれない → 実装を変更する必要あり
        canSignUp = Driver.combineLatest(emailValidation, passwordValidation, passwordConfirmValidation){ (email, password, passwordConfirm) in
            registerModel.ValidateCanRegister(emailIsValid: email.isValid, passwordIsValid: password.isValid, passwordConfirmIsValid: passwordConfirm.isValid)
        }
        .distinctUntilChanged()
    }
}

