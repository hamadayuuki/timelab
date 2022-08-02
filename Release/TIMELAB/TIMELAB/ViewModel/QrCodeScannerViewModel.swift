//
//  QrCodeScannerViewModel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/07/10.
//

import RxSwift
import RxCocoa
import UIKit   // Date()

class QrCodeScannerViewModel {
    let disposeBag = DisposeBag()
    
    // Model からの通知を受け取る, V で呼び出しとして使用
    var userId: Observable<String>   // uid を渡すために
    var userStateFromRooms: Observable<String>
    var nextUserState: Observable<String>
    var userName: Observable<String>
    var enterTimeDic: Observable<[String: Any]>
    var isRegisterUserStateToRooms: Driver<Bool>
    var isRegisterUserState: Driver<Bool>
    var isRegisterUserToRooms: Driver<Bool>
    var isRegisterRoomToUsers: Driver<Bool>
    var isRegisterTimeWhenEnter: Driver<Bool>
    var isRegisterTimeWhenLeave: Driver<Bool>
    
    init(roomId: String) {
        let registerUserModel = RegisterUserModel()
        let fetchUserModel = FetchUserModel()
        let registerRoomModel = RegisterRoomModel()
        let fetchRoomModel = FetchRoomModel()
        let registerTimeModel = RegisterTimeModel()
        let fetchTimeModel = FetchTimeModel()
        
        // 登録に使用する
        userId = fetchUserModel.fetchUserId()
            .filter { $0 != "" }
            .map { uid in return uid }
            .share(replay: 1)   // 複数回呼び出されるのを防ぐ
        
        userStateFromRooms = userId
            .filter { $0 != "" }
            .flatMap { uid in
                fetchRoomModel.fetchUsersStateFromRooms(roomId: roomId, uid: uid)
            }
            .share(replay: 1)
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
            .share(replay: 1)
        
        // 登録
        // Model の呼び出し, View から参照される
        // 滞在状況
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
        
        // ユーザー自体
        // TODO: 毎回する必要ある？
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
        
        // 時刻
        isRegisterTimeWhenEnter = Observable.zip(userId, userStateFromRooms)
            .filter { $1 == "home" || $1 == "" }
            .flatMap{ (uid, userState) in
                Observable.zip(registerTimeModel.registerTimeWhenEnter(uid: uid, roomId: roomId), registerUserModel.registerCurrentStayingRoom(roomId: roomId, uid: uid))
                    .map { return $0 && $1 }
            }
            .asDriver(onErrorJustReturn: false)
        
        enterTimeDic = Observable.zip(userId, userStateFromRooms)
            .filter { $0 != "" && $1 == "stay" }
            .flatMap { (uid, _) in
                fetchTimeModel.fetchEnterTime(uid: uid, roomId: roomId)
            }
            .filter { ($0["timeId"] as? String ?? "") != "" }
            .share(replay: 1)
        
        isRegisterTimeWhenLeave = Observable.zip(userId, enterTimeDic, userStateFromRooms)
            .filter { $2 == "stay" }
            .flatMap { (uid, enterTimeDic, userState) in
                registerTimeModel.registerTimeWhenLeave(uid: uid, roomId: roomId, timeId: enterTimeDic["timeId"] as! String, enterTimeDate: enterTimeDic["enterTimeDate"] as! Date)
            }
            .asDriver(onErrorJustReturn: false)
    }
}
