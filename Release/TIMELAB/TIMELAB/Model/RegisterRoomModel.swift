//
//  RegisterRoomModel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/07/01.
//

import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Alamofire
import SwiftyJSON

class RegisterRoomModel {
    init(){ }
    
    func fetchQrCodeFromTimeLabAPI(roomId: String) -> Observable<Data> {
        
        return Observable<Data>.create { observer in
            AF.request("https://timelab-api.herokuapp.com/createQrCode/\(roomId)").responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        print(response.data)
                        var articles: QrCode = try JSONDecoder().decode(QrCode.self, from: response.data as! Data)
                        print("articles.imgBase64: ", articles.imageBase64)
                        
                        var imgBase64 = articles.imageBase64
                        let decodeData = Data(base64Encoded: imgBase64)
                        observer.onNext(decodeData ?? Data())
    //                    let decodeImage = UIImage(data: decodeData ?? Data())
    //                    UIImageWriteToSavedPhotosAlbum(decodeImage!,self,nil,nil)   // 端末に画像を保存
                    } catch {
                        print("デコードに失敗しました")
                        observer.onNext(Data())
                    }
                case .failure(let error):
                    print("error", error)
                    observer.onNext(Data())
                }
            }
            return Disposables.create {
                print("Observable: Dispose")
            }
        }
        
    }
    
}
