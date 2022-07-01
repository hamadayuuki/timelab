//
//  SaveRoomQrCodeModel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/07/02.
//

import RxSwift
import RxCocoa
import UIKit

class SaveRoomQrCodeModel {
    
    func saveRoomQrCode(qrCodeData: Data) -> Observable<Bool> {
        
        return Observable<Bool>.create { observer in
            if let decodeImage = UIImage(data: qrCodeData) {
                UIImageWriteToSavedPhotosAlbum(decodeImage,self,nil,nil)   // 端末に画像を保存
                observer.onNext(true)
            }
            observer.onNext(false)
            
            return Disposables.create { print("Observable: Dispose") }
        }
       
    }
    
}
