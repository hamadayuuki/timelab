//
//  SaveRoomQrCodeViewModel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/07/02.
//

import UIKit
import RxSwift
import RxCocoa

class SaveRoomQrCodeViewModel {
    let disposeBag = DisposeBag()
    
    let isSaveRoomQrCode: Driver<Bool>
    
    init(saveButton: Signal<Void>, qrCodeData: Data) {
        let saveRoomQrCodeModel = SaveRoomQrCodeModel()
        
        isSaveRoomQrCode = saveButton
            .asObservable()
            .flatMap { _ in
                saveRoomQrCodeModel.saveRoomQrCode(qrCodeData: qrCodeData)
            }
            .asDriver(onErrorJustReturn: false)
    }
}
