//
//  ConfirmUserViewModel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/09/25.
//

import RxSwift
import RxCocoa

class ConfirmUserViewModel {
    let disposeBag = DisposeBag()
    
    let userId: Observable<String>
    let isUpadateUserIconNameToFireStore: Driver<Bool>
    
    init(iconName: String, updateButtonTap: Signal<Void>) {
        let fetchUserModel = FetchUserModel()
        let registerUserModel = RegisterUserModel()
        
        userId = fetchUserModel.fetchUserId()
            .filter { $0 != "" }
            .map { uid in return uid }
            .share(replay: 1)   // 複数回呼び出されるのを防ぐ
        
        isUpadateUserIconNameToFireStore = Observable.zip(userId, updateButtonTap.asObservable())
            .flatMap { (uid, _) in
                registerUserModel.updateIconNameToFireStore(uid: uid, iconName: iconName)
            }
            .asDriver(onErrorJustReturn: false)
    }
}
