//
//  CalendarViewModel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/08/23.
//

import RxSwift
import RxCocoa
import UIKit   // Date()

// TODO: - ユーザーの滞在状況取得
// TODO: - 入室済みなら入室時刻取得

class CalendarViewModel {
    let disposeBag = DisposeBag()
    
    var userId: Observable<String>
    var roomId: Observable<String>
    var monthCalendarTime: Driver<[[String:Any]]>
    
    init() {
        let fetchUserModel = FetchUserModel()
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
        
        // 登録に使用する
        monthCalendarTime = Observable.zip(userId, roomId)
            .flatMap { (uid, roomId) in
                fetchTimeModel.fetchMonthCalendarTime(uid: uid, roomId: roomId)
            }
            .asDriver(onErrorJustReturn: [["enterAtDate": Date(), "leaveAtDate": Date(), "stayingTimeAtSecond": 0]])
    }
}

