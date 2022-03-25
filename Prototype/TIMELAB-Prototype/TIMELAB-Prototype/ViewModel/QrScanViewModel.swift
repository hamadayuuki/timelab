//
//  QrScanViewModel.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/25.
//

import UIKit
import RxSwift
import RxCocoa


class QrScanViewModel {
    let qrScanModel = QrScanModel()
    let isCheckAndRegistRoom: Driver<Bool>
    
    //   ↓ これで roomId を受け取ってから checkAndRegistRoom() を呼べる
    init(roomId: String) {
        isCheckAndRegistRoom = qrScanModel.checkAndRegistRoom(roomId: roomId)
            .map { result in
                return result
            }
            .asDriver(onErrorJustReturn: false)
    }
}
