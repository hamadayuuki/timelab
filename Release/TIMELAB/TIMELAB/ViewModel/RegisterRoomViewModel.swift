//
//  RegisterRoomViewModel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/07/01.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterRoomViewModel {
    let disposeBag = DisposeBag()
    
    let universityValidation: Driver<ValidationResult>
    let departmentValidation: Driver<ValidationResult>
    let courseValidation: Driver<ValidationResult>
    let roomValidation: Driver<ValidationResult>
    
    let isSignUp: Driver<Bool>
    let canSignUp: Driver<Bool>
    let qrCodeData: Driver<Data>
    let userId: Driver<String>
    
    init(input: (
            university: Driver<String>,
            department: Driver<String>,
            course: Driver<String>,
            room: Driver<String>,
            registerButton: Signal<Void>
        )
    ) {
        // M とのつながり
        let validationModel = ValidationModel()
        let registerRoomModel = RegisterRoomModel()
        let fetchUserModel = FetchUserModel()
        
        // V からの通知(データも?)を受け取り M に処理を任せる, V から呼ばれることでデータ送信(VM→V)を行える
        universityValidation = input.university
            .map { university in
                validationModel.ValidateUniversity(university: university)
            }
        departmentValidation = input.department
            .map { department in
                validationModel.ValidateDepartment(department: department)
            }
        courseValidation = input.course
            .map { course in
                validationModel.ValidateCourse(course: course)
            }
        roomValidation = input.room
            .map { lab in
                validationModel.ValidateLab(lab: lab)
            }
        
        userId = fetchUserModel.fetchUserId()
            .filter { $0 != "" }
            .share(replay: 1)
            .asDriver(onErrorJustReturn: "")
        
        // 部屋作成
        let createRoomDatas = Driver.combineLatest(input.university, input.department, input.course, input.room, userId) { (university: $0, department: $1, course: $2, room: $3, uid: $4) }
        //  ↓ Observable<String>, documentId が通知される
        let roomsDocumentId = input.registerButton
            .asObservable()
            .withLatestFrom(createRoomDatas)
            .flatMapLatest { tuple in
//                signUpAPI.createUserToFireAuth(email: tuple.university, password: tuple.department)
                registerRoomModel.createRoomToFireStore(university: tuple.university, department: tuple.department, course: tuple.course, room: tuple.room, hostUserId: tuple.uid)
            }
            .share(replay: 1)
        
        // M でのアカウント登録結果を受け取り、V に渡している, M→VM, VM→M
        isSignUp = roomsDocumentId
            .filter { $0 != nil }
            .map { result in return result != "" }
            .asDriver(onErrorJustReturn: false )
        
        // アカウント作成可能か
        // ! ここに isSignUp をいれないと、アカウント登録が呼ばれない → 実装を変更する必要あり
        canSignUp = Driver.combineLatest(universityValidation, departmentValidation, courseValidation, roomValidation){ (university, department, course, room) in
            validationModel.ValidateCanRegister(universityIsValid: university.isValid, departmentIsValid: department.isValid, courseIsValid: course.isValid, roomIsValid: room.isValid)
        }
        .distinctUntilChanged()
        
        // timelab-api で作成したQRコードを Data型 で受け取る
        qrCodeData = roomsDocumentId
            .flatMap { documentId in
                registerRoomModel.fetchQrCodeFromTimeLabAPI(roomId: documentId)
            }
            .asDriver(onErrorJustReturn: Data())
        
    }
}
