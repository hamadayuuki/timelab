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
    
    let signUpResult: Driver<User>
    let isSignUp: Driver<Bool>
    var canSignUp: Driver<Bool>
    let isUserToFireStore: Driver<Bool>
    
    let disposeBag = DisposeBag()   // ここで初期化しないと 処理が走らない場合あり
    
    // input: V から通知を受け取れるよう、初期化
    init(input: (
        name: Driver<String>,
        email: Driver<String>,
        password: Driver<String>,
        passwordConfirm: Driver<String>,
        signUpTaps: Signal<Void>   // tap を受け取るときは Signal
    ), signUpAPI: RegisterUserModel) {
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
        
        // アカウント作成可能か
        // ! ここに isSignUp をいれないと、アカウント登録が呼ばれない → 実装を変更する必要あり
        canSignUp = Driver.combineLatest(nameValidation, emailValidation, passwordValidation, passwordConfirmValidation){ (name, email, password, passwordConfirm) in
            validationModel.ValidateCanRegister(nameIsValid: name.isValid, emailIsValid: email.isValid, passwordIsValid: password.isValid, passwordConfirmIsValid: passwordConfirm.isValid)
        }
        .distinctUntilChanged()
        
        // アカウント作成
        let nameAndEmailAndPassword = Driver.combineLatest(input.name, input.email, input.password) { (name: $0, email: $1, password: $2) }
        signUpResult = input.signUpTaps
            .asObservable()
            .withLatestFrom(nameAndEmailAndPassword)
            .flatMapLatest { tuple in
                signUpAPI.registerUserToFireAuth(name: tuple.name, email: tuple.email, password: tuple.password)   // User型 で返ってくる
            }
            .asDriver(onErrorJustReturn: User(name: "", email: "", uid: "", isValid: false))
        
        // M でのアカウント登録結果を受け取り、V に渡している, M→VM, VM→M
        //         ↓ Observable<User>
        isSignUp = signUpResult
            .asObservable()
            .filter { $0.isValid }
            .map { user in return user.isValid }
            .asDriver(onErrorJustReturn: false )
        
        // ユーザー情報を FireStore へ登録
        //  ↓ Observable<Observable<Bool>>
        let userToFireStoreResult = signUpResult
            .asObservable()
            .filter { $0.isValid }
            .map { user in
                signUpAPI.registerUserToFireStore(email: user.email, uid: user.uid, name: user.name)
            }
            .share(replay: 1)
        
        // ユーザー情報を FireStore へ登録できたかどうか を V へ通知
        isUserToFireStore = userToFireStoreResult
            .filter { $0 != nil }
            .flatMapLatest { bool in   // 値を通知する時には flatMapLatest を使う,
                return bool
            }
            .asDriver(onErrorJustReturn: false)
            
        // アカウント作成可能か
        // ! ここに isSignUp をいれないと、アカウント登録が呼ばれない → 実装を変更する必要あり
        canSignUp = Driver.combineLatest(nameValidation, emailValidation, passwordValidation, passwordConfirmValidation){ (name, email, password, passwordConfirm) in
            validationModel.ValidateCanRegister(nameIsValid: name.isValid, emailIsValid: email.isValid, passwordIsValid: password.isValid, passwordConfirmIsValid: passwordConfirm.isValid)
        }
        .distinctUntilChanged()
    }
    
}



