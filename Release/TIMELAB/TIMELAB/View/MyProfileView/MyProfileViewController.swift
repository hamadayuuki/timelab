//
//  MyProfileViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/12/10.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import PKHUD

class MyProfileViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    //var registerUserViewModel: RegisterUserViewModel!
    var isProgressView  = false
    var barTitle: String!
    var user: [String: Any]!
    var room: [String: Any]!
    
    init(setting: Setting, user: [String: Any], room: [String: Any]) {
        super.init(nibName: nil, bundle: nil)
        
        self.barTitle = setting.title
        self.user = user
        self.room = room
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    
    // MARK: - UI Parts
    var width: CGFloat!
    var height: CGFloat!
    let labelFrame = CGSize(width: 305, height: 25)
    
    var descriptionNickNameLabel: ProfileLabel!
    var nickNameLabel: ProfileLabel!
    var descriptionUnivercityLabel: ProfileLabel!
    var univercityLabel: ProfileLabel!
    var descriptionCourseLabel: ProfileLabel!
    var courseLabel: ProfileLabel!
    var descriptionRoomLabel: ProfileLabel!
    var roomLabel: ProfileLabel!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupLayout()
    }
    
    // MARK: - Function
    func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Color.navyBlue.UIColor]
        navigationController?.navigationBar.tintColor = Color.navyBlue.UIColor
        navigationItem.title = self.barTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(tapDismissButton(_:)))
    }
    
    private func setupLayout() {
        width = view.frame.width
        height = view.frame.height
        
        self.view.backgroundColor = .white
        
        let userIconButton = UserIconButton(imageName: user["iconName"] as? String ?? "", imageSize: CGSize(width: 125, height: 125))
        let profileVerticalView = setupProfileVerticalView()
        
        // MARK: - addSubview/layer
        view.addSubview(userIconButton)
        userIconButton.snp.makeConstraints { make -> Void in
            make.top.equalTo(154)
            make.centerX.equalTo(width * 0.5)
        }
        
        view.addSubview(profileVerticalView)
        descriptionNickNameLabel.snp.makeConstraints { make -> Void in
            make.width.equalTo(labelFrame.width)
            make.height.equalTo(labelFrame.height)
        }
        nickNameLabel.snp.makeConstraints { make -> Void in
            make.height.equalTo(labelFrame.height)
            make.width.equalTo(labelFrame.width)
        }
        profileVerticalView.snp.makeConstraints { make -> Void in
            make.top.equalTo(userIconButton.snp.bottom).offset(10)
            make.left.equalTo(38)
        }
    }
    
    func setupProfileVerticalView() -> UIStackView {
        descriptionNickNameLabel = ProfileLabel(text: "ニックネーム", size: 15, color: Color.lightGray.UIColor)
        nickNameLabel = ProfileLabel(text: self.user["name"] as? String ?? "", size: 20)
        nickNameLabel.underLine(color: Color.lightGray.UIColor, thickness: 1, frame: labelFrame)
        
        descriptionUnivercityLabel = ProfileLabel(text: "大学", size: 15, color: Color.lightGray.UIColor)
        univercityLabel = ProfileLabel(text: self.room["university"] as? String ?? "部屋を登録してください", size: 20)
        univercityLabel.underLine(color: Color.lightGray.UIColor, thickness: 1, frame: labelFrame)
        
        descriptionCourseLabel = ProfileLabel(text: "所属ゼミ", size: 15, color: Color.lightGray.UIColor)
        courseLabel = ProfileLabel(text: self.room["course"] as? String ?? "部屋を登録してください", size: 20)
        courseLabel.underLine(color: Color.lightGray.UIColor, thickness: 1, frame: labelFrame)
        
        descriptionRoomLabel = ProfileLabel(text: "使用している部屋名", size: 15, color: Color.lightGray.UIColor)
        roomLabel = ProfileLabel(text: self.room["name"] as? String ?? "部屋を登録してください", size: 20)
        roomLabel.underLine(color: Color.lightGray.UIColor, thickness: 1, frame: labelFrame)
        
         // ニックネーム
         let nickNameVerticalView = UIStackView(arrangedSubviews: [descriptionNickNameLabel, nickNameLabel])
         nickNameVerticalView.axis = .vertical
         nickNameVerticalView.spacing = 5
     
        // 大学
        let universityVerticalView = UIStackView(arrangedSubviews: [descriptionUnivercityLabel, univercityLabel])
        universityVerticalView.axis = .vertical
        universityVerticalView.spacing = 5
        
        // 所属ゼミ
        let courseVerticalView = UIStackView(arrangedSubviews: [descriptionCourseLabel, courseLabel])
        courseVerticalView.axis = .vertical
        courseVerticalView.spacing = 5
        
        // 使用している部屋
        let roomVerticalView = UIStackView(arrangedSubviews: [descriptionRoomLabel, roomLabel])
        roomVerticalView.axis = .vertical
        roomVerticalView.spacing = 5
     
         // 全体
         let profileVerticalView = UIStackView(arrangedSubviews: [nickNameVerticalView, universityVerticalView, courseVerticalView, roomVerticalView])
         profileVerticalView.axis = .vertical
         profileVerticalView.distribution = .fillEqually   // 要素の大きさを均等にする
         profileVerticalView.spacing = 30
        
        return profileVerticalView
    }
    
    @objc func tapDismissButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

