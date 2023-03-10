//
//  DeleteRoomModel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/12/11.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth

class DeleteRoomModel {
    init() { }
    
    // Rooms/roomId の削除は行わない, 削除後に他ユーザーがQRを読み込んだ時のエラー防止
    func deleteUserOnRooms(roomIds: [String], uid: String) -> Observable<Bool> {
        print(#function)
        
        return Observable<Bool>.create { observer in
            for roomId in roomIds {
                let roomRef = Firestore.firestore().collection("Rooms")
                roomRef.document(roomId).updateData(
                    [
                         // 空のリストから要素を削除したとき → 変化なし
                         // 要素がないリストから要素を削除したとき → 変化なし
                        "allUsers": FieldValue.arrayRemove([uid]),
                        "clients": FieldValue.arrayRemove([uid]),
                        "hosts": FieldValue.arrayRemove([uid])
                    ]
                ) { err in
                    if let err = err {
                        print("error deleteUserOnRooms")
                        observer.onNext(false)
                    }
                }
            }
            print("success deleteUserOnRooms")
            observer.onNext(true)
            
            return Disposables.create { print("Observable: Dispose") }
        }// return
         
    }
    
    func deleteUserOnUsersStates(roomIds: [String], uid: String) -> Observable<Bool> {
        print(#function)
        
        return Observable<Bool>.create { observer in
            for roomId in roomIds {
                let roomRef = Firestore.firestore().collection("Rooms")
                let usersStatesRef = roomRef.document(roomId).collection("UsersStates")
                
                usersStatesRef.document(uid).delete() { err in
                    if let err = err {
                        print("error deleteUserOnUsersStates, roomId:\(roomId)")
                        observer.onNext(false)
                    }
                }
            }
            print("success deleteUserOnUsersStates")
            observer.onNext(true)
            
            return Disposables.create { print("Observable: Dispose") }
        }// return
         
    }
    
}
