//
//  CalendarDetailViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/18.
//

import UIKit
import SnapKit
import FSCalendar

class CalendarDetailViewController: UIViewController {
    
    var date: String!
    
    init(date: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.date = date
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - UI Parts
    var calendarDateFooterLabel: CalendarDateFooterLabel!
    var achievementLevelUIImageView: CalendarDetailUIImageView!
    var doneUIImageView: CalendarDetailUIImageView!
    var timeTitleLabel: TitleLabel!
    var doneTitleLabel: TitleLabel!
    var memoTitleLabel: TitleLabel!
    var timeDetailLabel: DetailLabel!
    var memoDetailLabel: DetailLabel!
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    // MARK: - Function
    func setupLayout() {
        self.calendarDateFooterLabel = CalendarDateFooterLabel(text: self.date)
        self.achievementLevelUIImageView = CalendarDetailUIImageView(name: "Fire3", size: CGSize(width: 40, height: 35))
        self.doneUIImageView = CalendarDetailUIImageView(name: "PencilAndNote", size: CGSize(width: 80, height: 80))
        self.timeTitleLabel = TitleLabel(text: "Time")
        self.doneTitleLabel = TitleLabel(text: "Done")
        self.memoTitleLabel = TitleLabel(text: "Memo")
        self.timeDetailLabel = DetailLabel(text: "6時間 56分 32秒", fontSize: 19)
        self.memoDetailLabel = DetailLabel(text: "今日はほとんど半日研究を頑張った。\n来週までには、、、、、\n夏休みが始まる時には○○を終わらせる。", fontSize: 13)
        
        
        // MARK: - addSubview/layer
        view.backgroundColor = Color.white.UIColor
        view.addSubview(calendarDateFooterLabel)
        calendarDateFooterLabel.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.top.equalTo(30)
            make.width.equalTo(view.bounds.width)
            make.height.equalTo(50)
        }
        view.addSubview(achievementLevelUIImageView)
        achievementLevelUIImageView.snp.makeConstraints { make -> Void in
            make.left.equalTo(260)   // TODO: 日付と相対的に配置する
            make.centerY.equalTo(calendarDateFooterLabel.snp.centerY)
        }
        
        // Time
        view.addSubview(timeTitleLabel)
        timeTitleLabel.snp.makeConstraints { make -> Void in
            make.left.equalTo(47)
            make.top.equalTo(calendarDateFooterLabel.snp.bottom).offset(44)
        }
        view.addSubview(timeDetailLabel)
        timeDetailLabel.snp.makeConstraints { make -> Void in
            make.left.equalTo(47)
            make.top.equalTo(timeTitleLabel.snp.bottom).offset(20)
            make.width.equalTo(160)
            make.height.equalTo(20)
        }
        
        // Done
        view.addSubview(doneTitleLabel)
        doneTitleLabel.snp.makeConstraints { make -> Void in
            make.left.equalTo(47)
            make.top.equalTo(timeDetailLabel.snp.bottom).offset(60)
        }
        view.addSubview(doneUIImageView)
        doneUIImageView.snp.makeConstraints { make -> Void in
            make.left.equalTo(47)
            make.top.equalTo(doneTitleLabel.snp.bottom).offset(20)
            make.width.equalTo(80)   // TODO: TIMELAB に移植する際、大きさはクラス内で指定する
            make.height.equalTo(80)
        }
        
        // Memo
        view.addSubview(memoTitleLabel)
        memoTitleLabel.snp.makeConstraints { make -> Void in
            make.left.equalTo(47)
            make.top.equalTo(doneUIImageView.snp.bottom).offset(60)
        }
        view.addSubview(memoDetailLabel)
        memoDetailLabel.snp.makeConstraints { make -> Void in
            make.left.equalTo(47)
            make.top.equalTo(memoTitleLabel.snp.bottom).offset(20)
        }
    }
    
}
