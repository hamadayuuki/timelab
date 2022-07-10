//
//  QrCodeScannerViewModel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/07/10.
//

import RxSwift
import RxCocoa

class QrCodeScannerViewModel {
    let disposeBag = DisposeBag()
    
    // Model からの通知を受け取る, V で呼び出しとして使用
    var isRegisterUserState: Driver<Bool>
    var userId: Observable<String>   // uid を渡すために
    
    init(roomId: String) {
        let registerUserModel = RegisterUserModel()
        let fetchUserModel = FetchUserModel()
        
        userId = fetchUserModel.fetchUserId()
            .map { uid in
                return uid
            }
            .share()
        
        // Model の呼び出し, View から参照される
        // TODO: state の値を可変に
        isRegisterUserState = userId
            .filter { $0 != "" }
            .flatMap { uid in
                registerUserModel.registerUserState(roomId: roomId, uid: uid, state: "stay")
            }
            .asDriver(onErrorJustReturn: false)
        
    }
}
