//
//  RegisterLabViewModel.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/18.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterLabViewModel {
    let universityValidation: Driver<ValidationResult>
    let departmentValidation: Driver<ValidationResult>
    let courseValidation: Driver<ValidationResult>
    let labValidation: Driver<ValidationResult>
    
    let isSignUp: Driver<Bool>
    let canSignUp: Driver<Bool>
    
    let disposeBag = DisposeBag()   // ここで初期化しないと 処理が走らない場合あり
    
    // input: V から通知を受け取れるよう、初期化
    init(input: (
        university: Driver<String>,
        department: Driver<String>,
        course: Driver<String>,
        lab: Driver<String>,
        registerButton: Signal<Void>   // tap を受け取るときは Signal
    ), signUpAPI: RegisterModel) {
        
        // M とのつながり
        let registerLabValidationModel = RegisterLabValidationModel()
        
        // V からの通知(データも?)を受け取り M に処理を任せる, V から呼ばれることでデータ送信(VM→V)を行える
        universityValidation = input.university
            .map { university in
                registerLabValidationModel.ValidateUniversity(university: university)
            }
        departmentValidation = input.department
            .map { department in
                registerLabValidationModel.ValidateDepartment(department: department)
            }
        courseValidation = input.course
            .map { course in
                registerLabValidationModel.ValidateCourse(course: course)
            }
        labValidation = input.lab
            .map { lab in
                registerLabValidationModel.ValidateLab(lab: lab)
            }
        
        // アカウント作成
        let signUpDatas = Driver.combineLatest(input.university, input.department, input.course, input.lab) { (university: $0, department: $1, course: $2, lab: $3) }
        let result = input.registerButton
            .asObservable()
            .withLatestFrom(signUpDatas)
            .flatMapLatest { tuple in
//                signUpAPI.createUserToFireAuth(email: tuple.university, password: tuple.department)
                signUpAPI.createLabToFireStore(university: tuple.university, department: tuple.department, course: tuple.course, lab: tuple.lab)
            }
            .share(replay: 1)
        
        // M でのアカウント登録結果を受け取り、V に渡している, M→VM, VM→M
        isSignUp = result
            .filter { $0 != nil }
            .map { result in return result }
            .asDriver(onErrorJustReturn: false )
        
        // アカウント作成可能か
        // ! ここに isSignUp をいれないと、アカウント登録が呼ばれない → 実装を変更する必要あり
        canSignUp = Driver.combineLatest(universityValidation, departmentValidation, courseValidation, labValidation){ (university, department, course, lab) in
            registerLabValidationModel.ValidateCanRegister(universityIsValid: university.isValid, departmentIsValid: department.isValid, courseIsValid: course.isValid, labIsValid: lab.isValid)
        }
        .distinctUntilChanged()
    }
}
