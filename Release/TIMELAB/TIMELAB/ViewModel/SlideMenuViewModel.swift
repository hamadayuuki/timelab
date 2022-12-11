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
    
    func signOutAction() -> Driver<Bool> {
        return logOutModel.logOut()
            .filter { $0 == true }
            .asDriver(onErrorJustReturn: false)
    }
    
}
