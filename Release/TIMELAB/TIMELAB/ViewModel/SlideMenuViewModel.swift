//
//  SlideMenuViewModel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/12/10.
//

import RxSwift
import RxCocoa

class SlideMenuViewModel {
    let disposeBag = DisposeBag()
    var logOutModel = LogOutModel()
    var deleteUserModel = DeleteUserModel()
    var deleteRoomModel = DeleteRoomModel()
    
    func signOutAction() -> Driver<Bool> {
        return logOutModel.logOut()
            .filter { $0 == true }
            .asDriver(onErrorJustReturn: false)
    }
    
    func deleteUserFireStore(uid: String) -> Driver<Bool> {
        return deleteUserModel.deleteUserFireStore(uid: uid)
            .filter { $0 == true }
            .asDriver(onErrorJustReturn: false)
    }
    
    func deleteUserFireAuth() -> Driver<Bool> {
        return deleteUserModel.deleteUserFireAuth()
            .filter { $0 == true }
            .asDriver(onErrorJustReturn: false)
    }
    
    func deleteUserOnRooms(roomIds: [String], uid: String) -> Driver<Bool> {
        return deleteRoomModel.deleteUserOnRooms(roomIds: roomIds, uid: uid)
            .filter { $0 == true }
            .asDriver(onErrorJustReturn: false)
    }
    
    func deleteUserOnUsersStates(roomIds: [String], uid: String) -> Driver<Bool> {
        return deleteRoomModel.deleteUserOnUsersStates(roomIds: roomIds, uid: uid)
            .filter { $0 == true }
            .asDriver(onErrorJustReturn: false)
    }
    
}
