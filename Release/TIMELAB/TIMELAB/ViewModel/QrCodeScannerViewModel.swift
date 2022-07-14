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
    var nextUserState: Observable<String>
    var userName: Observable<String>
    var isRegisterUserToRooms: Driver<Bool>
    var isRegisterRoomToUsers: Driver<Bool>
    
    init(roomId: String) {
        let registerUserModel = RegisterUserModel()
        let fetchUserModel = FetchUserModel()
        let registerRoomModel = RegisterRoomModel()
        let fetchRoomModel = FetchRoomModel()
        
        // 登録に使用する
        userId = fetchUserModel.fetchUserId()
            .filter { $0 != "" }
            .map { uid in return uid }
        
        userStateFromRooms = userId
            .filter { $0 != "" }
            .flatMap { uid in
                fetchRoomModel.fetchUsersStateFromRooms(roomId: roomId, uid: uid)
            }
        nextUserState = userStateFromRooms   // 滞在状態変更後
            .map { userStateFromRooms -> String in
                var userState = ""
                print(userStateFromRooms)
                switch userStateFromRooms {
                    case "stay": userState = "home"
                    case "home": userState = "stay"
                    default: userState = "stay"
                }
                return userState
            }
        
        userName = userId
            .filter { $0 != "" }
            .flatMap { uid in
                fetchUserModel.fetchUser(uid: uid)
            }
            .map { user in
                return user["name"] as? String ?? ""
            }
        
        // 登録
        // Model の呼び出し, View から参照される
        isRegisterUserState = Observable.zip(userId, nextUserState)
            .flatMap { (uid, userState) in
                registerUserModel.registerUserState(roomId: roomId, uid: uid, state: userState)
            }
            .asDriver(onErrorJustReturn: false)
        
        isRegisterUserStateToRooms = Observable.zip(userId, nextUserState, userName)
            .flatMap { (uid, userState, name) in
                registerRoomModel.registerUserStateToRooms(roomId: roomId, uid: uid, state: userState, name: name)
            }
            .asDriver(onErrorJustReturn: false)
        
        isRegisterUserToRooms = Observable.zip(userId, userName)
            .flatMap{ (uid, name) in
                registerRoomModel.registerUserToRooms(roomId: roomId, uid: uid, name: name)
            }
            .asDriver(onErrorJustReturn: false)
        
        isRegisterRoomToUsers = userId
            .flatMap{ (uid) in
                registerUserModel.registerRoomToUsers(roomId: roomId, uid: uid)
            }
            .asDriver(onErrorJustReturn: false)
    }
}
