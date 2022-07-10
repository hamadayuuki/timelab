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
    var isRegisterUserStateToRooms: Driver<Bool>
    var userStateFromRooms: Observable<String>
    
    init(roomId: String) {
        let registerUserModel = RegisterUserModel()
        let fetchUserModel = FetchUserModel()
        let registerRoomModel = RegisterRoomModel()
        let fetchRoomModel = FetchRoomModel()
        
        // 登録に使用する
        userId = fetchUserModel.fetchUserId()
            .map { uid in return uid }
        
        userStateFromRooms = userId
            .filter { $0 != "" }
            .flatMap { uid in
                fetchRoomModel.fetchUsersStateFromRooms(roomId: roomId, uid: uid)
            }
        
        // 登録
        // Model の呼び出し, View から参照される
        isRegisterUserState = Observable.zip(userId, userStateFromRooms)
            .map { (userId, userStateFromRooms) -> (String, String) in
                var userState = ""
                print(userStateFromRooms)
                switch userStateFromRooms {
                    case "stay": userState = "home"
                    case "home": userState = "returnedHome"
                    case "returnedHome": userState = "stay"
                    default: userState = "stay"
                }
                return (userId, userState)
            }
            .flatMap { (uid, userState) in
                registerUserModel.registerUserState(roomId: roomId, uid: uid, state: userState)
            }
            .asDriver(onErrorJustReturn: false)
        
        isRegisterUserStateToRooms = Observable.zip(userId, userStateFromRooms)
            .map { (userId, userStateFromRooms) -> (String, String) in
                var userState = ""
                print(userStateFromRooms)
                switch userStateFromRooms {
                    case "stay": userState = "home"
                    case "home": userState = "returnedHome"
                    case "returnedHome": userState = "stay"
                    default: userState = "stay"
                }
                return (userId, userState)
            }
            .flatMap { uid, userState in
                registerRoomModel.registerUserStateToRooms(roomId: roomId, uid: uid, state: userState)
            }
            .asDriver(onErrorJustReturn: false)
        
    }
}
