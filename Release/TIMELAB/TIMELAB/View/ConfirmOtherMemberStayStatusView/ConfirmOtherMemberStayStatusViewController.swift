//
//  ConfirmOtherMemberStayStatusViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/05/02.
//

import UIKit
import SnapKit
import FSCalendar

class ConfirmOtherMemberStayStatusViewController: UIViewController {
    
    // TODO: FireStoreからデータを取得する
    let otherMemberDates = [
        ["name": "たろう", "iconName": "UserIcon1", "userId": "xxx", "stayStatus": "stay"],
        ["name": "濵田", "iconName": "UserIcon2", "userId": "yyy", "stayStatus": "home"],
        ["name": "ながの", "iconName": "UserIcon3", "userId": "zzz", "stayStatus": "stay"],
        ["name": "しば", "iconName": "UserIcon4", "userId": "000", "stayStatus": "home"],
        ["name": "れいかぴ", "iconName": "UserIcon5", "userId": "111", "stayStatus": "stay"],
        ["name": "有村", "iconName": "UserIcon6", "userId": "222", "stayStatus": "home"]
    ]
    var userIconUIImages: [ConfirmOtherMemberUserIconButton]!
    var userNameLabels: [ConfirmOtherMemberLabel]!
    
    // MARK: - UI Parts
    var roomCard: RankingRoomCardUIImageView!
    var roomCardLabel: RankingLabel!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    // MARK: - Function
    func setupLayout() {
        self.roomCard = RankingRoomCardUIImageView()
        self.roomCardLabel = RankingLabel(text: "太田研究室", size: 15, textColor: Color.white.UIColor)
        
        // メンバーのデータから UIButton(ボタンとしての機能なし, 画像として使用) と UILabel を作成, リストとして保持
        self.userIconUIImages = []
        self.userNameLabels = []
        for otherMemberDate in otherMemberDates {
            let userIconImage = ConfirmOtherMemberUserIconButton(imageName: otherMemberDate["iconName"] ?? "UserIcon1")
            if otherMemberDate["stayStatus"] == "stay" { userIconImage.backgroundColor = .orange }
            self.userIconUIImages.append(userIconImage)
            
            let userNameLabel = ConfirmOtherMemberLabel(text: otherMemberDate["name"] ?? "", size: 15)
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
    
}

