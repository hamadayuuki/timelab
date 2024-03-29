//
//  CalendarDetailViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/18.
//

import UIKit
import SnapKit
import FSCalendar
import Charts

class CalendarDetailViewController: UIViewController, ChartViewDelegate {
    
    var date: String!
    var enterAndLeaveTimesOfDay: [[String: Any]]!   // ["enterAtDate": Data, "leaveAtDate": Data, "stayingTimeAtSecond": Int]
    var stayingTimeStringOfDay: String!  // 1時間 23分 45分
    var doneContentChartView: DoneContentsChartView!
    var isAllNight: Bool!
    
    init(date: String, enterAndLeaveTimesOfDay: [[String: Any]], stayingTimeStringOfDay: String, isAllNight: Bool) {
        super.init(nibName: nil, bundle: nil)
        
        self.date = date
        self.enterAndLeaveTimesOfDay = enterAndLeaveTimesOfDay
        self.stayingTimeStringOfDay = stayingTimeStringOfDay
        self.isAllNight = isAllNight
        
        let clockTimes = createClockTimes()
        let dataEntries = createPieChartDataEntries(clockTimes: clockTimes)
        self.doneContentChartView = DoneContentsChartView(dataEntries: dataEntries, isAllNight: isAllNight)
        self.doneContentChartView.delegate = self
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - UI Parts
    var calendarDateFooterLabel: CalendarDateFooterLabel!
//    var achievementLevelUIImageView: CalendarDetailUIImageView!
    var timeDetailLabel: DetailLabel!
//    var memoDetailLabel: DetailLabel!
    var footerEnterTimeLabel: TimeTableLabel!
    var footerLeaveTimeLabel: TimeTableLabel!
    var timeTabelLabel: TimeTableLabel!
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    // MARK: - Function
    private func createClockTimes() -> [ClockTime] {
        if self.enterAndLeaveTimesOfDay.count == 0 {
            return [ClockTime(start: "00:00", end: "23:59")]
        }
        
        // 入退室時刻の並び替え
        var saveTimes: [[String: Any]] = []
        for time in self.enterAndLeaveTimesOfDay {
            if (DateUtils.stringFromDate(date: time["enterAtDate"] as! Date, format: "HH:mm")) == "00:00" {
                saveTimes.insert(time, at: 0)
            } else {
                saveTimes.append(time)
            }
        }
        self.enterAndLeaveTimesOfDay = saveTimes
        
        var clockTimes: [ClockTime] = []
        let firstEnterTimeString = DateUtils.stringFromDate(date: self.enterAndLeaveTimesOfDay.first!["enterAtDate"] as! Date, format: "HH:mm")
        let lastLeaveTimeString = DateUtils.stringFromDate(date: self.enterAndLeaveTimesOfDay.last!["leaveAtDate"] as! Date, format: "HH:mm")
        // "00:00"〜初入室時刻 を追加, 徹夜の有無に関わらず実行される
        if firstEnterTimeString != "00:00" {
            clockTimes.append(ClockTime(start: "00:00", end: DateUtils.stringFromDate(date: self.enterAndLeaveTimesOfDay.first!["enterAtDate"] as! Date, format: "HH:mm")))
        }
        for i in 0..<self.enterAndLeaveTimesOfDay.count {
            clockTimes.append(ClockTime(start: DateUtils.stringFromDate(date: self.enterAndLeaveTimesOfDay[i]["enterAtDate"] as! Date, format: "HH:mm"), end: DateUtils.stringFromDate(date: self.enterAndLeaveTimesOfDay[i]["leaveAtDate"] as! Date, format: "HH:mm")))
            // 1日に2回以上入室した場合に 間の時間を退室とする
            if i != self.enterAndLeaveTimesOfDay.count - 1 {
                clockTimes.append(ClockTime(start: DateUtils.stringFromDate(date: self.enterAndLeaveTimesOfDay[i]["leaveAtDate"] as! Date, format: "HH:mm"), end: DateUtils.stringFromDate(date: self.enterAndLeaveTimesOfDay[i + 1]["enterAtDate"] as! Date, format: "HH:mm")))
            }
        }
        // 最終退室時刻〜"23:59" を追加
        if lastLeaveTimeString != "23:59" {
            clockTimes.append(ClockTime(start: DateUtils.stringFromDate(date: self.enterAndLeaveTimesOfDay.last!["leaveAtDate"] as! Date, format: "HH:mm"), end: "23:59"))
        }
        return clockTimes
    }
    
    private func createPieChartDataEntries(clockTimes: [ClockTime]) -> [PieChartDataEntry] {
        var dataEntries: [PieChartDataEntry] = []
        for time in clockTimes {
            let startTime = (Int(time.start.components(separatedBy: ":")[0])! * 60) + Int(time.start.components(separatedBy: ":")[1])!
            let endTime = (Int(time.end.components(separatedBy: ":")[0])! * 60) + Int(time.end.components(separatedBy: ":")[1])!
            var stayingMinute = endTime - startTime
            if stayingMinute == 0 { stayingMinute += 1 }   // 滞在時間が1分未満
            dataEntries.append(PieChartDataEntry(value: Double(stayingMinute), label: "\(time.start)〜\(time.end)"))
        }
        return dataEntries
    }
    
    func setupLayout() {
        self.calendarDateFooterLabel = CalendarDateFooterLabel(text: self.date)
        self.timeDetailLabel = DetailLabel(text: "滞在時間 : " + self.stayingTimeStringOfDay, fontSize: 20)   // 滞在時間 : 1時間 23分 45秒
//        self.memoDetailLabel = DetailLabel(text: "メモ書きが入ります", fontSize: 13)
        self.timeTabelLabel = TimeTableLabel(text: "", fontSize: 30, isEnterTime: false)   // 12:34
        self.footerEnterTimeLabel = TimeTableLabel(text: "入室", fontSize: 20, isEnterTime: false, isFooter: true)
        self.footerLeaveTimeLabel = TimeTableLabel(text: "退室", fontSize: 20, isEnterTime: false, isFooter: true)
        
        
        // MARK: - addSubview/layer
        view.backgroundColor = Color.white.UIColor
        view.addSubview(calendarDateFooterLabel)
        calendarDateFooterLabel.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.top.equalTo(30)
            make.width.equalTo(view.bounds.width)
            make.height.equalTo(50)
        }
        
        // Time
        view.addSubview(timeDetailLabel)
        timeDetailLabel.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.top.equalTo(calendarDateFooterLabel.snp.bottom).offset(90)
        }
        
        view.addSubview(doneContentChartView)
        doneContentChartView.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.top.equalTo(timeDetailLabel.snp.bottom).offset(50)
            make.width.equalTo(280)
            make.height.equalTo(280)
        }
        
        for direction: TimeDirection in [.north, .east, .south, .west]{
            let timeLabel = DetailLabel(text: direction.timeText, fontSize: 12)
            view.addSubview(timeLabel)
            timeLabel.snp.makeConstraints { make -> Void in
                switch direction {
                case .north:   // 上
                    make.centerX.equalTo(doneContentChartView.snp.centerX)
                    make.top.equalTo(doneContentChartView.snp.top).offset(-10)
                case .east:    // 右
                    make.right.equalTo(doneContentChartView.snp.right).offset(10)
                    make.centerY.equalTo(doneContentChartView.snp.centerY)
                case .south:   // 下
                    make.centerX.equalTo(doneContentChartView.snp.centerX)
                    make.bottom.equalTo(doneContentChartView.snp.bottom).offset(10)
                case .west:    // 左
                    make.left.equalTo(doneContentChartView.snp.left).offset(-10)
                    make.centerY.equalTo(doneContentChartView.snp.centerY)
                }
            }
        }
        
        // 入退室時刻表のフッター
//        view.addSubview(footerEnterTimeLabel)
//        footerEnterTimeLabel.snp.makeConstraints { make -> Void in
//            make.centerX.equalTo(view.bounds.width * 0.35)
//            make.top.equalTo(timeDetailLabel.snp.bottom).offset(60)
//            make.height.equalTo(50)
//            make.width.equalTo(view.bounds.width * 0.3)
//        }
//        view.addSubview(footerLeaveTimeLabel)
//        footerLeaveTimeLabel.snp.makeConstraints { make -> Void in
//            make.centerX.equalTo(view.bounds.width * 0.65)
//            make.top.equalTo(timeDetailLabel.snp.bottom).offset(60)
//            make.height.equalTo(50)
//            make.width.equalTo(view.bounds.width * 0.3)
//        }
//
//        // 入退室時刻表のボディー
//        let cellHeight = 30
//        let cellWidth = view.bounds.width * 0.3
//        var tableCount = 0
//        for enterAndLeaveTimeOfDay in self.enterAndLeaveTimesOfDay {
//            // 左側 : 入室時刻
//            let enterTimeString = DateUtils.stringFromDate(date: enterAndLeaveTimeOfDay["enterAtDate"] as! Date, format: "HH:mm")   // 23:45
//            self.timeTabelLabel = TimeTableLabel(text: enterTimeString, fontSize: 20, isEnterTime: false)
//            view.addSubview(timeTabelLabel)
//            timeTabelLabel.snp.makeConstraints { make -> Void in
//                make.centerX.equalTo(footerEnterTimeLabel.snp.centerX)
//                make.top.equalTo(footerEnterTimeLabel.snp.bottom).offset(10 + (tableCount * cellHeight))   // 初期位置 + (セル同士の間隔)
//                make.height.equalTo(cellHeight)
//                make.width.equalTo(cellWidth)
//            }
//            // 右側 : 退室時刻
//            let leaveTimeString = DateUtils.stringFromDate(date: enterAndLeaveTimeOfDay["leaveAtDate"] as! Date, format: "HH:mm")   // 23:45
//            self.timeTabelLabel = TimeTableLabel(text: leaveTimeString, fontSize: 20, isEnterTime: true)
//            view.addSubview(timeTabelLabel)
//            timeTabelLabel.snp.makeConstraints { make -> Void in
//                make.centerX.equalTo(footerLeaveTimeLabel.snp.centerX)
//                make.top.equalTo(footerLeaveTimeLabel.snp.bottom).offset(10 + (tableCount * cellHeight))
//                make.height.equalTo(cellHeight)
//                make.width.equalTo(cellWidth)
//            }
//            tableCount += 1
//        }
        
//        // Done
//        view.addSubview(doneUIImageView)
//        doneUIImageView.snp.makeConstraints { make -> Void in
//            make.left.equalTo(47)
//            make.top.equalTo(timeDetailLabel.snp.bottom).offset(30)
//            make.width.equalTo(80)   // TODO: TIMELAB に移植する際、大きさはクラス内で指定する
//            make.height.equalTo(80)
//        }
//
//        // Memo
//        view.addSubview(memoDetailLabel)
//        memoDetailLabel.snp.makeConstraints { make -> Void in
//            make.left.equalTo(47)
//            make.top.equalTo(doneUIImageView.snp.bottom).offset(60)
//        }
    }
    
}
