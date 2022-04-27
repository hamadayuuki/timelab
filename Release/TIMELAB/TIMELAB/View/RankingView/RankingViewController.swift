//
//  RankingViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/27.
//

import UIKit
import SnapKit
import FSCalendar

class RankingViewController: UIViewController {
    
    // MARK: - UI Parts
    var roomCard: RankingRoomCardUIImageView!
    var roomCardLabel: RankingLabel!
    
    var firstUserCrownUIImageView: RankingCrownUIImageView!
    var secondUserCrownUIImageView: RankingCrownUIImageView!
    var thirdUserCrownUIImageView: RankingCrownUIImageView!
    var fourthUserCrownUIImageView: RankingCrownUIImageView!
    var fifthUserCrownUIImageView: RankingCrownUIImageView!
    
    var firstUserIconUIButton: RankingUserIconButton!
    var secondUserIconUIButton: RankingUserIconButton!
    var thirdUserIconUIButton: RankingUserIconButton!
    var forthUserIconUIButton: RankingUserIconButton!
    var fifthUserIconUIButton: RankingUserIconButton!
    
    var firstUserTimeLabel: RankingLabel!
    var secondUserTimeLabel: RankingLabel!
    var thirdUserTimeLabel: RankingLabel!
    var forthUserTimeLabel: RankingLabel!
    var fifthUserTimeLabel: RankingLabel!
    
    var firstUserNameLabel: RankingLabel!
    var secondUserNameLabel: RankingLabel!
    var thirdUserNameLabel: RankingLabel!
    var forthUserNameLabel: RankingLabel!
    var fifthUserNameLabel: RankingLabel!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    // MARK: - Function
    func setupLayout() {
        self.roomCard = RankingRoomCardUIImageView()
        self.roomCardLabel = RankingLabel(text: "太田研究室", size: 15, textColor: Color.white.UIColor)
        
        self.firstUserCrownUIImageView = RankingCrownUIImageView(name: "GoldCrown")
        self.secondUserCrownUIImageView = RankingCrownUIImageView(name: "SilverCrown")
        self.thirdUserCrownUIImageView = RankingCrownUIImageView(name: "BrownCrown")
        self.fourthUserCrownUIImageView = RankingCrownUIImageView(name: "NavyBlueCrown1")
        self.fifthUserCrownUIImageView = RankingCrownUIImageView(name: "NavyBlueCrown2")
        let userCrownUIImages = [firstUserCrownUIImageView, secondUserCrownUIImageView, thirdUserCrownUIImageView, fourthUserCrownUIImageView, fifthUserCrownUIImageView]
        
        self.firstUserIconUIButton = RankingUserIconButton(imageName: "UserIcon_1")
        self.secondUserIconUIButton = RankingUserIconButton(imageName: "UserIcon_2")
        self.thirdUserIconUIButton = RankingUserIconButton(imageName: "UserIcon_3")
        self.forthUserIconUIButton = RankingUserIconButton(imageName: "UserIcon_4")
        self.fifthUserIconUIButton = RankingUserIconButton(imageName: "UserIcon_5")
        let userIconUIButtons = [firstUserIconUIButton, secondUserIconUIButton, thirdUserIconUIButton, forthUserIconUIButton, fifthUserIconUIButton]
        
        self.firstUserTimeLabel = RankingLabel(text: "25時間45分", size: 15)
        self.secondUserTimeLabel = RankingLabel(text: "25時間45分", size: 15)
        self.thirdUserTimeLabel = RankingLabel(text: "25時間45分", size: 15)
        self.forthUserTimeLabel = RankingLabel(text: "25時間45分", size: 15)
        self.fifthUserTimeLabel = RankingLabel(text: "25時間45分", size: 15)
        let userTimeLabels = [firstUserTimeLabel, secondUserTimeLabel, thirdUserTimeLabel, forthUserTimeLabel, fifthUserTimeLabel]
        
        self.firstUserNameLabel = RankingLabel(text: "濵田", size: 13)
        self.secondUserNameLabel = RankingLabel(text: "たろう", size: 13)
        self.thirdUserNameLabel = RankingLabel(text: "たいが", size: 13)
        self.forthUserNameLabel = RankingLabel(text: "れいかぴ", size: 13)
        self.fifthUserNameLabel = RankingLabel(text: "有村", size: 13)
        let userNameLabels = [firstUserNameLabel, secondUserNameLabel, thirdUserNameLabel, forthUserNameLabel, fifthUserNameLabel]
        
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
        
        // 王冠画像の縦並び
        for (index, userCrownUIImage) in userCrownUIImages.enumerated() {
            guard let userCrownUIImage = userCrownUIImage else { return }   // nilチェック
            view.addSubview(userCrownUIImage)
            userCrownUIImage.snp.makeConstraints { make -> Void in
                make.centerX.equalTo(view.bounds.width * 0.2)
                make.centerY.equalTo(0).offset(230.0 + (100.0 * CGFloat(index)))   // equalTo() の中に数値を入れても意味ない
            }
        }
        
        // アイコン画像の縦並び
        for (index, userIconUIButton) in userIconUIButtons.enumerated() {
            guard let userIconUIButton = userIconUIButton else { return }   // nilチェック
            view.addSubview(userIconUIButton)
            userIconUIButton.snp.makeConstraints { make -> Void in
                make.left.equalTo(userCrownUIImages[index]!.snp.right).offset(40)
                make.centerY.equalTo(0).offset(230.0 + (100.0 * CGFloat(index)))   // equalTo() の中に数値を入れても意味ない
            }
        }
        
        // ユーザー名の縦並び
        for (index, userNameLabel) in userNameLabels.enumerated() {
            guard let userNameLabel = userNameLabel else { return }   // nilチェック
            view.addSubview(userNameLabel)
            userNameLabel.snp.makeConstraints { make -> Void in
                make.centerX.equalTo(userIconUIButtons[index]!.snp.centerX)
                make.top.equalTo(userIconUIButtons[index]!.snp.bottom).offset(5)
            }
        }
        
        // 時間の縦並び
        for (index, userTimeLabel) in userTimeLabels.enumerated() {
            guard let userTimeLabel = userTimeLabel else { return }   // nilチェック
            view.addSubview(userTimeLabel)
            userTimeLabel.snp.makeConstraints { make -> Void in
                make.left.equalTo(userIconUIButtons[index]!.snp.right).offset(15)
                make.centerY.equalTo(0).offset(230.0 + (100.0 * CGFloat(index)))   // equalTo() の中に数値を入れても意味ない
            }
        }
    }
    
}
