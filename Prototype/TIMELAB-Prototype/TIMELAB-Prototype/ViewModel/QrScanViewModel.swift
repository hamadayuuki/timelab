//
//  QrScanViewModel.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/25.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase   // DocumentReference型 を使用するため


class QrScanViewModel {
    
    let isCheckAndRegistRoom: Driver<Bool>
    let isRegistUserToRooms: Driver<Bool>
    let isRegisterEnterTime: Driver<Bool>
    let isRegistUserStateToRooms: Driver<Bool>
    let isRegisterLeaveTime: Driver<Bool>
    
    // 呼び出されるタイミングは QRコードを読み取ったとき, アカウント登録後
    //   ↓ roomId を受け取ってから checkAndRegistRoom() を呼べる
    init(roomId: String) {
        let qrScanModel = QrScanModel()   // 変数の宣言と初期化を init()内 で行わないと この後のプログラムでエラーが出る
        
        // Users に ログイン中のユーザーが QRの研究室を登録しているか確認(check)し、登録していないときは登録(Regist)する
        // ほとんど true が返ってくる
        isCheckAndRegistRoom = qrScanModel.checkAndRegistRoomToUser(roomId: roomId)
            .map { bool in
                return bool
            }
            .asDriver(onErrorJustReturn: false)
        
        // FireStore の ユーザー情報(+uid)を取得する
        let resultFetchUser = isCheckAndRegistRoom
            .filter { $0 == true }
            .drive { _ in
                qrScanModel.fetchUser()   // アカウント登録時点で FireStore にユーザー情報は入っている, Observable<[String: Any]?>
            }
            .asDriver(onErrorJustReturn: ["": ""])   // fetchUser() でもエラーの時は ["": ""] を通知する
        
        isRegistUserToRooms = resultFetchUser
            .filter { $0?.count != 1 }
            .asObservable()
            .flatMap { tuple in
                qrScanModel.registerUserToRooms(/*roomId: roomId, uid: tuple?["uid"] as? String ?? "", type: tuple?["type"] as? String ?? ""*/)   // Rooms に ユーザー を登録する
            }
            .asDriver(onErrorJustReturn: false)
        
        // 入退室 を区別する
        let resultFetchUsersStateFromRooms = qrScanModel.fetchUsersStateFromRooms()
            .map { state in
                return state
            }
            .asDriver(onErrorJustReturn: "")
        
        /* 入・退室時に使用する*/
        let isCheckRegistToUsersAndRooms = Driver.combineLatest(isCheckAndRegistRoom, isRegistUserToRooms) { $0 && $1 }
        let checkRoomAndUserAndState = Driver.combineLatest(isCheckRegistToUsersAndRooms, resultFetchUser, resultFetchUsersStateFromRooms) { (isCheck: $0, user: $1, state: $2) }
        
        // Rooms/UsersState の 滞在状態 を変更する
        isRegistUserStateToRooms = checkRoomAndUserAndState
            .asObservable()
            .filter { ($0.isCheck == true) }
            .flatMap { tuple in
                qrScanModel.registerUserStateToRooms(/*roomId: roomId, uid: tuple.user?["uid"] as? String ?? "", */state: (tuple.state == "stay") ? "": "stay")   // Rooms/UserState に 滞在状態 を登録する
            }
            .asDriver(onErrorJustReturn: false)
        
        /* 入室時刻を登録する*/
        isRegisterEnterTime = checkRoomAndUserAndState
            .asObservable()   // flatMapLatest を使いために変換, 最後には Driver に変換する
            .filter { ($0.isCheck == true) && ($0.state != "stay") }
            .flatMapLatest { tuple in
                qrScanModel.registerEnterTime(name: tuple.user?["name"] as? String ?? "", uid: tuple.user?["uid"] as? String ?? "", roomId: roomId)
            }
            .asDriver(onErrorJustReturn: false)
        
        /* 退室時刻を登録する*/
        // 退室時刻を入力するフィールドのリファレンスを取得
        let fetchLatestTimeRefAndRoomId = resultFetchUser
            .asObservable()
            .flatMap { user in
                qrScanModel.fetchLatestTimesRefAndRoomId(uid: user?["uid"] as? String ?? "")
            }
            .asDriver(onErrorJustReturn: ["ref": "" as Any])

        let checkRoomAndUserAndLatestTimeRefAndRoomIdAndState = Driver.combineLatest(isCheckAndRegistRoom, resultFetchUser, fetchLatestTimeRefAndRoomId, resultFetchUsersStateFromRooms) { (isCheck: $0, user: $1, latestTimeRefAndRoomId: $2, state: $3) }

        isRegisterLeaveTime = checkRoomAndUserAndLatestTimeRefAndRoomIdAndState
            .asObservable()   // flatMapLatest を使うために変換, 最後には Driver に変換する
            .filter { ($0.isCheck == true) && ($0.state == "stay") && (($0.latestTimeRefAndRoomId?["roomId"] as? String ?? "") == roomId) }
            .flatMapLatest { tuple in
                qrScanModel.registerLeaveTime(uid: tuple.user?["uid"] as? String ?? "", latestTimesRef: tuple.latestTimeRefAndRoomId?["ref"] as! DocumentReference)
            }
            .asDriver(onErrorJustReturn: false)
        
        
        
    }
}
