//
//  CheckRegisterUserViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2023/06/11.
//

import UIKit
import SnapKit
import PKHUD
import RxSwift

// メール認証から遷移する
// 主にユーザー登録の処理を行う
class CheckRegisterUserViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let checkRegisterUserViewModel = CheckRegisterUserViewModel()
    
    // MARK: - UI Parts
    var checkRegisterUserLabel: RegisterLabel!
    var checkRegisterUserMessageLabel: RegisterLabel!
    
    var name: String!
    var iconName: String!
    
    init(name: String, iconName: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.name = name
        self.iconName = iconName
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBinding()
        
        HUD.dimsBackground = false
        HUD.show(.progress)
        checkRegisterUserViewModel.setEmailAndPassword()
        Task {
            do {
                try await checkRegisterUserViewModel.registerUserToAuth()
            } catch {
                print("Catch checkRegisterUserViewModel.registerUserToAuth()")
            }
        }
    }
    
    // MARK: - Function
    func setupLayout() {
        view.backgroundColor = Color.white.UIColor
        
        checkRegisterUserLabel = RegisterLabel(text: "登録しています", size: 30)
        checkRegisterUserMessageLabel = RegisterLabel(text: "もう少しお待ちください", size: 15)
        
        
        let checkRegisterUserVertical = UIStackView(arrangedSubviews: [checkRegisterUserLabel, checkRegisterUserMessageLabel])
        checkRegisterUserVertical.axis = .vertical
        checkRegisterUserVertical.alignment = .center
        checkRegisterUserVertical.spacing = 20
        
        // MARK: - addSubview/layer
        view.addSubview(checkRegisterUserVertical)
        checkRegisterUserVertical.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.centerY.equalTo(view.bounds.height * 0.3)
        }
    }
    
    func setupBinding() {
        Observable.combineLatest(checkRegisterUserViewModel.authResult, checkRegisterUserViewModel.uid)
            .subscribe { [weak self] authResult, uid in
                guard let self = self else { return }
                if authResult, let uid = uid {
                    print("Success Auth")
                    Task {
                        do {
                            try await self.checkRegisterUserViewModel.registerUserToStore(uid: uid, name: self.name, iconName: self.iconName)
                        } catch {
                            print("Error Auth try await self.checkRegisterUserViewModel")
                            HUD.show(.error)
                        }
                    }
                } else {
                    print("Error Auth")
                    HUD.show(.error)
                }
            }
        
        Observable.combineLatest(checkRegisterUserViewModel.authResult, checkRegisterUserViewModel.storeResult)
            .filter { $0 && $1 }
            .subscribe { [weak self] _, _ in
                guard let self = self else { return }
                print("Success Auth+Store")
                HUD.hide()
            }
            .disposed(by: disposeBag)
    }
}
