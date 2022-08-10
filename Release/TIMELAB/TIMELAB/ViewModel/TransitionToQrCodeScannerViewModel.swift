//
//  TransitionToQrCodeScannerViewModel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/07/23.
//
import RxSwift
import RxCocoa
import UIKit   // Date()

// TODO: - ユーザーの滞在状況取得
// TODO: - 入室済みなら入室時刻取得

class TransitionToQrCodeScannerViewModel {
    let disposeBag = DisposeBag()
    
    // Model からの通知を受け取る, V で呼び出しとして使用
    var userId: Observable<String>   // uid を渡すために
    var roomId: Observable<String>
    var userStateFromRooms: Driver<String>
    
    init() {
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
        
        roomId = userId
            .flatMap { uid in
                fetchUserModel.fetchUser(uid: uid)
            }
            .map { $0["currentStayingRoom"] as? String ?? "" }
            .share(replay: 1)
        
        userStateFromRooms = Observable.zip(roomId, userId)
            .filter { $1 != "" }
            .flatMap { (roomId, uid) in
                fetchRoomModel.fetchUsersStateFromRooms(roomId: roomId, uid: uid)
            }
            .asDriver(onErrorJustReturn: "")
        
    }
}
