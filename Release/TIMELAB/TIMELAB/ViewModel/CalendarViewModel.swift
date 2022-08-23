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
    
    var monthCalendarTime: Driver<[[String:Any]]>
    
    init() {
        let fetchTimeModel = FetchTimeModel()
        
        // 登録に使用する
        monthCalendarTime = fetchTimeModel.fetchMonthCalendarTime()
            .asDriver(onErrorJustReturn: [["enterAtDate": Date(), "leaveAtDate": Date(), "stayingTimeAtSecond": 0]])
    }
}

