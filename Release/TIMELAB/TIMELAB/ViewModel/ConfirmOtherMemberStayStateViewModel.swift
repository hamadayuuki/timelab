//
//  ConfirmOtherMemberStayStateViewModel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/09/25.
//

import Firebase
import RxSwift
import RxCocoa

class ConfirmOtherMemberStayStateViewModel {
    let disposeBag = DisposeBag()
    
    let userId: Observable<String>
    let roomId: Observable<String>
    let roomName: Observable<String>
    let otherMemberStayState: Driver<[[String: Any]]>
    
    init() {
        let fetchUserModel = FetchUserModel()
        let fetchRoomModel = FetchRoomModel()
        
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
        
        roomName = roomId
            .flatMap { roomId in
                fetchRoomModel.fetchRoom(roomId: roomId)
            }
            .map { $0["name"] as? String ?? "" }
            .filter { $0 != "" }
            .share(replay: 1)
        
        otherMemberStayState = Observable.zip(roomId, roomName)
            .flatMap { (roomId, _) in
                fetchRoomModel.fetchAllUserStayState(roomId: roomId)
            }
            .asDriver(onErrorJustReturn: [["": ""]])
    }
    
}
