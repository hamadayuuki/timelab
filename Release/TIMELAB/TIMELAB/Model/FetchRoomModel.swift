//
//  FetchRoomModel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/07/10.
//

import Firebase
import FirebaseFirestore
import FirebaseAuth
import RxSwift
import RxCocoa
import UIKit

class FetchRoomModel {
    
    // 基本ユーザーの状態はここから取得する
    func fetchUsersStateFromRooms(roomId: String, uid: String) -> Observable<String> {
        return Observable<String>.create { observer in
            
            let roomsRef = Firestore.firestore().collection("Rooms").document(roomId)
            let userStateRef = roomsRef.collection("UsersStates").document(uid)
            
            userStateRef.getDocument { (document, err) in
               if let document = document {
                   let data = document.data()
                   let state = data?["state"] as? String ?? ""
                   observer.onNext(state)
                } else {
                    print("Document does not exist")
                    observer.onNext("")
                }
            }
            return Disposables.create { print("Observable: Dispose") }
        }
    }
    
    // 部屋に所属している全ユーザーのUIDを取得
    func fetchAllUserID(roomId: String) -> Observable<[String]> {
        return Observable<[String]>.create { observer in
            
            let roomsRef = Firestore.firestore().collection("Rooms").document(roomId)
            
            roomsRef.getDocument { (document, err) in
               if let document = document {
                   let data = document.data()
                   let allUsersId = data?["allUsers"] as? [String] ?? [""]
                   observer.onNext(allUsersId)
                } else {
                    print("Document does not exist")
                    observer.onNext([""])
                }
            }
            return Disposables.create { print("Observable: Dispose") }
        }
    }
    
    func fetchAllUserStayStatus(roomId: String) -> Observable<[[String: Any]]> {
        return Observable<[[String: Any]]>.create { observer in
            
            let roomsRef = Firestore.firestore().collection("Rooms").document(roomId)
            let usersStatesRef = roomsRef.collection("UsersStates")
            
            usersStatesRef.addSnapshotListener { (snapshot, err) in
                if let err = err {
                    print("fetchAllUserStayStatus エラー")
                    observer.onNext([["": ""]])
                } else {
                    var otherMemberStayStatesArray = []   // 戻り値
                    for document in snapshot!.documents {
                        print("document: \(document)")
                        print("document.data(): \(document.data())")
                        let userStates = document.data()
                        otherMemberStayStatesArray.append(["name": userStates["name"] as? String ?? "", "state": userStates["state"] as? String ?? ""])
                    }
                    print(otherMemberStayStatesArray)
                    observer.onNext(otherMemberStayStatesArray as? [[String: Any]] ?? [["": ""]])
                }
            }
            return Disposables.create { print("Observable: Dispose") }
        }
    }
    
    func fetchRoom(roomId: String) -> Observable<[String: Any]> {
        Observable<[String: Any]>.create { observer in
            let roomsRef = Firestore.firestore().collection("Rooms").document(roomId)
            
            roomsRef.getDocument { (document, err) in
               if let document = document {
                   observer.onNext(document.data() as? [String: Any] ?? ["": ""])
                } else {
                    print("Document does not exist")
                    observer.onNext(["": ""])
                }
            }
            return Disposables.create { print("Observable: Dispose") }
        }
        
        
    }
}

