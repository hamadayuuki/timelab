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
    let isRegisterEnterTime: Driver<Bool>
    let isRegisterLeaveTime: Driver<Bool>
    
    // 呼び出されるタイミングは QRコードを読み取ったとき, アカウント登録後
    //   ↓ roomId を受け取ってから checkAndRegistRoom() を呼べる
    init(roomId: String) {
        let qrScanModel = QrScanModel()   // 変数の宣言と初期化を init()内 で行わないと この後のプログラムでエラーが出る
        
        // ログイン中のユーザーが QRの研究室を登録しているか確認(check)し、登録していないときは登録(Regist)する
        // ほとんど true が返ってくる
        isCheckAndRegistRoom = qrScanModel.checkAndRegistRoom(roomId: roomId)
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
            .asDriver(onErrorJustReturn: ["": ""])
        
        // 入・退室時に使用する
        let checkRoomAndUser = Driver.combineLatest(isCheckAndRegistRoom, resultFetchUser) { (isCheck: $0, user: $1) }
        
        // 入室時刻を登録する
        isRegisterEnterTime = checkRoomAndUser
            .asObservable()   // flatMapLatest を使いために変換, 最後には Driver に変換する
            .filter { ($0.isCheck == true) && ($0.user?.count ?? 0 >= 5) && (($0.user?["state"] as? String ?? "") != "stay") }
            .flatMapLatest { tuple in
                qrScanModel.registerEnterTime(name: tuple.user?["name"] as? String ?? "", uid: tuple.user?["uid"] as? String ?? "")
            }
            .asDriver(onErrorJustReturn: false)
        
        // 退室時刻を登録する, TODO: V での実装, 実行確認
        // 退室時刻を入力するフィールドのリファレンスを取得
        let fetchLatestTimeRef = resultFetchUser
            .asObservable()
            .flatMap { user in
                qrScanModel.fetchLatestTimesRef(uid: user?["uid"] as? String ?? "")
            }
            .asDriver(onErrorJustReturn: ["ref": "" as Any])
        let checkRoomAndUserAndLatestTimeRef = Driver.combineLatest(isCheckAndRegistRoom, resultFetchUser, fetchLatestTimeRef) { (isCheck: $0, user: $1, latestTimeRef: $2) }
        isRegisterLeaveTime = checkRoomAndUserAndLatestTimeRef
            .asObservable()   // flatMapLatest を使いために変換, 最後には Driver に変換する
            .filter { ($0.isCheck == true) && ($0.user?.count ?? 0 >= 5) && (($0.user?["state"] as? String ?? "") == "stay") }
            .flatMapLatest { tuple in
                qrScanModel.registerLeaveTime(uid: tuple.user?["uid"] as? String ?? "", latestTimesRef: tuple.latestTimeRef?["ref"] as! DocumentReference)
            }
            .asDriver(onErrorJustReturn: false)
        
        
        
    }
}
