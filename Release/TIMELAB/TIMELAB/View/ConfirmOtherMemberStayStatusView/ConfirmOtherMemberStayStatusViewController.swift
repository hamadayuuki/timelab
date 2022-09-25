//
//  ConfirmOtherMemberStayStatusViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/05/02.
//

import UIKit
import SnapKit
import FSCalendar
import RxSwift
import RxCocoa
import PKHUD

class ConfirmOtherMemberStayStatusViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    // TODO: FireStoreからデータを取得する
    var otherMembers: [[String: Any]] = [
        ["state": "stay", "name": "a", "iconName": "UserIcon1"],
        ["state": "stay", "name": "b", "iconName": "UserIcon2"],
        ["state": "home", "name": "c", "iconName": "UserIcon3"],
        ["state": "home", "name": "d", "iconName": "UserIcon4"],
        ["state": "stay", "name": "e", "iconName": "UserIcon5"]
    ]
    var userIconUIImages: [ConfirmOtherMemberUserIconButton]!
    var userNameLabels: [ConfirmOtherMemberLabel]!
    var roomName = ""
    
    // MARK: - UI Parts
    var roomCard: RankingRoomCardUIImageView!
    var roomCardLabel: RankingLabel!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupLayout()
        HUD.show(.progress)   // setupBinding() 内で .hide()
        setupBinding()
    }
    
    // MARK: - Function
    func setupLayout() {
        self.roomCard = RankingRoomCardUIImageView()
        self.roomCardLabel = RankingLabel(text: roomName, size: 15, textColor: Color.white.UIColor)
        
        // メンバーのデータから UIButton(ボタンとしての機能なし, 画像として使用) と UILabel を作成, リストとして保持
        self.userIconUIImages = []
        self.userNameLabels = []
        for otherMember in otherMembers {
            // TODO: Any型の型宣言を簡略化する
            let userIconImage = ConfirmOtherMemberUserIconButton(imageName: otherMember["iconName"] as? String ?? "UserIcon1")
            if otherMember["state"] as? String ?? "home" == "stay" { userIconImage.backgroundColor = .orange }
            self.userIconUIImages.append(userIconImage)
            
            let userNameLabel = ConfirmOtherMemberLabel(text: otherMember["name"]  as? String ?? "", size: 15)
            self.userNameLabels.append(userNameLabel)
        }
        
        // MARK: - addSubview
        view.backgroundColor = .white
        
        // 部屋の名称
        view.addSubview(roomCard)
        roomCard.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.centerY.equalTo(140)
        }
        view.addSubview(roomCardLabel)
        roomCardLabel.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.centerY.equalTo(140 + 5.0)   // RoomCard の若干下
        }
        
        // アイコン画像の縦並び
        for (index, userIconUIImage) in self.userIconUIImages.enumerated() {
            view.addSubview(userIconUIImage)
            userIconUIImage.snp.makeConstraints { make -> Void in
                make.centerX.equalTo(0).offset(view.bounds.width * (0.25 * (CGFloat(index % 3) + 1.0)))
                make.centerY.equalTo(0).offset(245.0 + (135.0 * floor(CGFloat(index / 3))))   // equalTo() の中に数値を入れても意味ない, floor(): 切り捨て
            }
        }
        
        // ユーザー名の縦並び
        for (index, userNameLabel) in self.userNameLabels.enumerated() {
            view.addSubview(userNameLabel)
            userNameLabel.snp.makeConstraints { make -> Void in
                make.centerX.equalTo(self.userIconUIImages[index].snp.centerX)
                make.top.equalTo(self.userIconUIImages[index].snp.bottom).offset(5)
            }
        }
    }
    
    func setupBinding() {
        let confirmOtherMemberStayStatusViewModel = ConfirmOtherMemberStayStatusViewModel()
        confirmOtherMemberStayStatusViewModel.roomName
            .subscribe { roomName in
                self.roomName = roomName
            }
            .disposed(by: disposeBag)
        
        // roomName 取得後実行される
        confirmOtherMemberStayStatusViewModel.otherMemberStayStatus
            .drive { stayStatusArray in
                print("stayStatusArray: \(stayStatusArray)")
                self.otherMembers = stayStatusArray
                self.setupLayout()
                HUD.hide()
            }
            .disposed(by: disposeBag)
    }
    
}

