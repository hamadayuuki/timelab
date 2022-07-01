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
import UIKit

class RegisterRoomModel {
    init(){ }
    
    func createRoomToFireStore(university: String, department: String, course: String, room: String) -> Observable<String> {
        print("研究室登録 の処理")
        
        return Observable<String>.create { observer in
            
            let document = [
                "allUsers": [],
                "hosts": [],
                "clients": [],
                "university": university,
                "department": department,
                "course": course,
                "name": room,
                "type": "Lab",   // "Lab" か "Room", TODO: 可変に
                "createAt": Timestamp(),
                "updateAt": Timestamp()
            ] as [String : Any]
            
            let roomsRef = Firestore.firestore().collection("Rooms").document()
            roomsRef.setData(document) { err in
                if let err = err {
                    observer.onNext("")
                }
                let documentId = roomsRef.documentID
                observer.onNext(documentId)
            }
            return Disposables.create {
                print("Observable: Dispose")
            }
        }
        
    }
    
    func fetchQrCodeFromTimeLabAPI(roomId: String) -> Observable<Data> {
        
        return Observable<Data>.create { observer in
            AF.request("https://timelab-api.herokuapp.com/createQrCode/\(roomId)").responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        print(response.data)
                        var articles: QrCode = try JSONDecoder().decode(QrCode.self, from: response.data as! Data)
                        //print("articles.imgBase64: ", articles.imageBase64)
                        
                        var imgBase64 = articles.imageBase64
                        let decodeData = Data(base64Encoded: imgBase64)
                        observer.onNext(decodeData ?? Data())
//                        let decodeImage = UIImage(data: decodeData ?? Data())
//                        UIImageWriteToSavedPhotosAlbum(decodeImage!,self,nil,nil)   // 端末に画像を保存
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
