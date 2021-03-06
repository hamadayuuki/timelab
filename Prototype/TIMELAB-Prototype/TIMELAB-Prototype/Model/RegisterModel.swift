//
//  RegisterModel.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/18.
//

import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Alamofire
import SwiftyJSON

// Model には Protocol を作成する
protocol RegisterModelProtocol {
    func createUserToFireAuth(emai: String, password: String) -> Observable<User>
    func createUserToFireStore(email: String, uid: String, name: String) -> Observable<Bool>
    func createLabToFireStore(university: String, department: String, course: String, lab: String) -> Observable<String>
}

class RegisterModel {
    init() { }
    
    // アカウント登録の状態を通知するために create を使い、アカウント登録を Observable化
    //                                                                         ↓ VM で FireStroeへユーザー情報を登録できるよう User型 で通知
    func createUserToFireAuth(name: String, email: String, password: String) -> Observable<User> {
        
        return Observable<User>.create { observer in
            // FireAuth への登録, email/password のチェックは完了している
            Auth.auth().createUser(withEmail: email, password: password) { (auth, err) in
                if let err = err {
                    print("登録失敗: ", err)
                    let user = User(name: "", email: "", uid: "", isValid: false)
                    observer.onNext(user)
                }
                
                guard let uid = auth?.user.uid else { return }
                print("登録成功: ", uid)
                let user = User(name: name, email: email, uid: uid, isValid: true)
                observer.onNext(user)
            }
            return Disposables.create {
                print("Observable: Dispose")
            }
            
        }// return
    }
    
    func createUserToFireStore(email: String, uid: String, name: String) -> Observable<Bool> {
        
        return Observable<Bool>.create { observer in
            
            let document = [
                "name": name,
                "email": email,
                "type": "client",   // TODO: 可変に
                "rooms": [],
                "createAt": Timestamp(),
                "updateAt": Timestamp()
            ] as [String : Any]
            
            Firestore.firestore().collection("Users").document(uid).setData(document) { err in
                if let err = err {
                    print("FireStoreへの登録に失敗: ", err)
                    observer.onNext(false)
                }
                print("FireStoreへの登録に成功")
                observer.onNext(true)
            }
            return Disposables.create {
                print("Observable: Dispose")
            }
            
        }
        
    }
    
    func createLabToFireStore(university: String, department: String, course: String, lab: String) -> Observable<String> {
        print("研究室登録 の処理")
        
        return Observable<String>.create { observer in
            
            let document = [
                "allUsers": [],
                "hosts": [],
                "clients": [],
                "university": university,
                "department": department,
                "course": course,
                "name": lab,
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
