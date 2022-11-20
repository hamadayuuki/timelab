//
//  TabBarViewModel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/11/21.
//

import Firebase
import RxSwift
import RxCocoa

class TabBarViewModel {
    let disposeBag = DisposeBag()
    
    let userId: Observable<String>
    let user: Driver<[String: Any]>
    
    init() {
        let fetchUserModel = FetchUserModel()
        
        userId = fetchUserModel.fetchUserId()
            .filter { $0 != "" }
            .map { uid in return uid }
            .share(replay: 1)   // 複数回呼び出されるのを防ぐ
        
        user = userId
            .flatMap { uid in
                fetchUserModel.fetchUser(uid: uid)
            }
            .asDriver(onErrorJustReturn: ["": ""])
    }
}

