//
//  QrScanViewModel.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/25.
//

import UIKit

class QrScanViewModel {
    let qrScanModel = QrScanModel()
    
    func callCheckAndRegistRoom(roomId: String) {
        qrScanModel.checkAndRegistRoom(roomId: roomId)
    }
}
