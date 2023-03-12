//
//  CalendarViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/17.
//

import UIKit
import SnapKit
import FSCalendar
import FloatingPanel
import Charts
import RxSwift
import RxCocoa
import PKHUD
import Firebase   // Timestamp

// 画面遷移用
protocol CalendarViewDelegate {
    func presentTransition(year: Int, month: Int, day: Int, dayOfWeek: String)
}

class CalendarViewController: UIViewController {
    let disposeBag = DisposeBag()
    var enterScheduleAndStayingTimeDic: [String: Int] = [:] // ["2022/04/16": 10, "2022/04/20": 30, "2022/04/21": 10]   // カレンダーのセル背景色変更のため
    var times: [[String: Any]]!   // 日毎の詳細画面のため
    var fpc: FloatingPanelController!
    var doneContentChartView: DoneContentsChartView!
    var doneContentUIImageView: DoneContentUIImageView!
    var longTimeCellDescriptionText: DetailLabel!
    var shortTimeCellDescriptionText: DetailLabel!
    var userIconButton: UserIconButton!
    var tabBarDelegate: TabBarViewController!   // TODO: TabBarViewController に Delegate を定義する
    
    // TODO: dataList を DoneContentsChartView か CalendarViewController どちらで扱うか決める。両方はなし。
    let dataList = [
        (value: 10.0, label: "A", icon: UIImage(named: "Flask")),
        (value: 20.0, label: "B", icon: UIImage(named: "Lupe")),
        (value: 30.0, label: "C", icon: UIImage(named: "PencilAndEraser")),
        (value: 20.0, label: "D", icon: UIImage(named: "PencilAndNote")),
        (value: 20.0, label: "E", icon: UIImage(named: "Television"))
    ]
    var contentsView = UIView()
    let scrollView = CalendarScrollView()
    
    init(userIconButton: UserIconButton, tabBarDelegate: TabBarViewController) {
        super.init(nibName: nil, bundle: nil)
        
        self.userIconButton = userIconButton
        self.tabBarDelegate = tabBarDelegate
        self.fpc = FloatingPanelController()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - UI Parts
    var calendarView: CalendarView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "カレンダー"
        view.backgroundColor = .white
        self.calendarView = CalendarView(dateAndStayingTimeDic: self.enterScheduleAndStayingTimeDic)
        HUD.show(.progress)
        setupMonthCalendarTime()
//        setupLayout()   // setupMonthCalendarTime() 内で呼ばれる
//        setupBinding()   // setupMonthCalendarTime() 内で呼ばれる
//        setupFloatingPanel()   // setupMonthCalendarTime() 内で呼ばれる
    }
    
    //画面を去るときにセミモーダルビューを非表示にする
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // セミモーダルビューを非表示にする
        self.fpc.removePanelFromParent(animated: true)
    }
    
    // MARK: - Function
    func setupMonthCalendarTime() {
        let calendarViewModel = CalendarViewModel()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        calendarViewModel.monthCalendarTime
            .drive { monthCalendarTimes in
                var newMonthCalndarTimes = monthCalendarTimes   // 日をまたいだ時のため
                for monthCalendarTime in monthCalendarTimes {
                    //self.dateDictionary.append(dateFormatter.string(from: monthCalendarTime["enterTimeDate"] as! Date))
                    let enterTimeDate = monthCalendarTime["enterAtDate"] as? Date ?? Date()
                    let leaveTimeDate = monthCalendarTime["leaveAtDate"] as? Date ?? Date()
                    let stayingTimeAtSecond = monthCalendarTime["stayingTimeAtSecond"] as? Int ?? 0
                    if self.enterScheduleAndStayingTimeDic.keys.contains(dateFormatter.string(from: enterTimeDate)) {
                        self.enterScheduleAndStayingTimeDic[dateFormatter.string(from:enterTimeDate)]! += stayingTimeAtSecond > (24 * 60 * 60) ? 0 : stayingTimeAtSecond   // 日をまたいでいる場合を考慮して
                    } else {
                        self.enterScheduleAndStayingTimeDic[dateFormatter.string(from: enterTimeDate)] = stayingTimeAtSecond > (24 * 60 * 60) ? 0 : stayingTimeAtSecond   // 日をまたいでいる場合を考慮して
                    }
                    
                    // 日をまたいでいる時
                    if dateFormatter.string(from: enterTimeDate) != dateFormatter.string(from: leaveTimeDate) {
                        let calendar = Calendar(identifier: .gregorian)
                        // 入室時刻 と 入室翌日の00:00 の差, 秒
                        let nextDayStartDate = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: enterTimeDate)!)
                        let diffEnterAndNextDayStart = nextDayStartDate.timeIntervalSince(enterTimeDate)   // 入室日翌日の00:00 と 入室時刻 の差分, 秒
                        // 入室翌日の00:00〜退室時刻 の秒数から、1日またいだ日数を取得
                        let diffLeaveAndNextDayStart = stayingTimeAtSecond - Int(diffEnterAndNextDayStart)
                        let addDaysNum = Int((diffLeaveAndNextDayStart) / (24 * 60 * 60))
                        // 日をまたいだ分追加
                        for i in 1..<(addDaysNum+1) {
                            let addDayDate: Date = calendar.date(byAdding: .day, value: i, to: enterTimeDate)!   // "YYYY/MM/DD"
                            self.enterScheduleAndStayingTimeDic[dateFormatter.string(from: addDayDate)] = 24 * 60 * 60
                            
                            // newMonthCalndarTimes へ 00:00〜23:59 を追加 → カレンダーセルの背景色は透明
                            let dayStartDate: Date = calendar.date(from:  DateComponents(year: calendar.component(.year, from: addDayDate) , month: calendar.component(.month, from: addDayDate), day: calendar.component(.day, from: addDayDate)))!   // 次の日の00:00
                            
                            let dayEndDate: Date = calendar.date(from:  DateComponents(hour: 23, minute: 59))!   // 次の日の23:59
                            newMonthCalndarTimes.append(["enterAtDate": dayStartDate, "leaveAtDate": dayEndDate, "stayingTimeAtSecond": 24 * 60 * 60])
                            
                        }
                        // 退室日の00:00 と 退室時刻 の差, 秒
                        let leaveDayStartDate: Date = calendar.startOfDay(for: leaveTimeDate)
                        let diffLeaveAndLeaveDayStart = leaveTimeDate.timeIntervalSince(leaveDayStartDate)
                        self.enterScheduleAndStayingTimeDic[dateFormatter.string(from: leaveTimeDate)] = Int(diffLeaveAndLeaveDayStart)
                        
                        // newMonthCalndarTimes へ 退出日00:00〜退出時間 を追加
                        newMonthCalndarTimes.append(["enterAtDate": leaveDayStartDate, "leaveAtDate": leaveTimeDate, "stayingTimeAtSecond": Int(diffLeaveAndLeaveDayStart)])
                        
                        // 入室日の滞在時間を調整
                        self.enterScheduleAndStayingTimeDic[dateFormatter.string(from: enterTimeDate)]! += Int(diffEnterAndNextDayStart)
                    }
                }
                self.times = newMonthCalndarTimes   // 日毎の詳細画面に使用
                self.calendarView.enterScheduleAndStayingTimeDic = self.enterScheduleAndStayingTimeDic
                self.setupLayout()
                self.setupBinding()
                self.setupFloatingPanel()
                HUD.hide()
            }
            .disposed(by: disposeBag)
    }
    
    // TODO: 計算量を少なくする
    func setEnterAndLeaveTimesOfDay(year: Int, month: Int, day: Int, times: [[String: Any]]) -> [[String: Any]] {
        var enterAndLeaveTimesOfDay: [[String: Any]] = []
        for time in times {
            // 入退室した時刻を日付から取得
            let enterAtDate = time["enterAtDate"] as? Date ?? Date()
            let enterYearAndMonthAndDay = DateUtils.stringFromDate(date: enterAtDate, format: "yyyy-M-d")
            // 選択した日付と一致するデータを取得
            if (enterYearAndMonthAndDay == "\(year)-\(month)-\(day)") {
                // 入室と退室で日付が異なるとき 退室時刻を 23:59 とする
                let leaveAtDate = time["leaveAtDate"] as? Date ?? Date()
                let leaveYearAndMonthAndDay = DateUtils.stringFromDate(date: leaveAtDate, format: "yyyy-M-d")
                if (enterYearAndMonthAndDay != leaveYearAndMonthAndDay) {
                    var newTime = time
                    newTime["leaveAtDate"] = Calendar(identifier: .gregorian).date(bySettingHour: 23, minute: 59, second: 59, of: enterAtDate)
                    enterAndLeaveTimesOfDay.append(newTime)
                } else {
                    enterAndLeaveTimesOfDay.append(time)
                }
            }
        }
        return enterAndLeaveTimesOfDay
    }
    
    // TODO: 計算量を少なくする
    func setStayingTimeStringOfDay(year: Int, month: Int, day: Int, times: [[String: Any]]) -> String {
        var stayingTimeSum = 0
        for time in times {
            // 入退室した時刻を日付から取得
            let enterAtDate = time["enterAtDate"] as? Date ?? Date()
            let enterYearAndMonthAndDay = DateUtils.stringFromDate(date: enterAtDate, format: "yyyy-M-d")
            if (enterYearAndMonthAndDay == "\(year)-\(month)-\(day)") {
                // 入室と退室で日付が異なるとき 滞在時間を (23:59 - 入室時刻) とする
                let leaveAtDate = time["leaveAtDate"] as? Date ?? Date()
                let leaveYearAndMonthAndDay = DateUtils.stringFromDate(date: leaveAtDate, format: "yyyy-M-d")
                if (enterYearAndMonthAndDay != leaveYearAndMonthAndDay) {
                    let midnight = Calendar(identifier: .gregorian).date(bySettingHour: 23, minute: 59, second: 59, of: enterAtDate) as? Date ?? Date()
                    let untilMidnightSecond = midnight.timeIntervalSince(enterAtDate)   // 滞在時間を (23:59 - 入室時刻) とする
                    stayingTimeSum += Int(untilMidnightSecond)
                } else {
                    stayingTimeSum += time["stayingTimeAtSecond"] as? Int ?? 0
                }
            }
        }
        
        let stayingHour = stayingTimeSum / (60 * 60)
        let stayingMinute = (stayingTimeSum - (stayingHour * (60 * 60))) / 60
        let stayingSecond = stayingTimeSum - (stayingHour * (60 * 60)) - (stayingMinute * 60)
        
        return "\(stayingHour)時間 \(stayingMinute)分 \(stayingSecond)秒"
    }
    
    private func setupLayout() {
//        var iconUIImage = UIImage(named: "UserIcon1")?.reSizeImage(reSize: CGSize(width: 50, height: 50))
//        iconUIImage = iconUIImage?.withRenderingMode(.alwaysOriginal)
//        let leftNavigationButton = UIBarButtonItem(image: iconUIImage, style: .plain, target: self, action: #selector(tapLeftNavigationButton(_:)))
//        self.navigationItem.leftBarButtonItem = leftNavigationButton
        
//        let userIconButton = UserIconButton(imageName: "UserIcon1")
        let userIconBarButton = UIBarButtonItem(customView: self.userIconButton)
        self.navigationItem.leftBarButtonItem = userIconBarButton
        
        view.backgroundColor = .white
        
        calendarView.calendarViewDelegate = self   // 画面遷移のために指定
        
        // カレンダーセルの説明
        shortTimeCellDescriptionText = DetailLabel(text: "短", fontSize: 10)
        let cell1 = UIView()
        cell1.backgroundColor = Color.superLightGray.UIColor
        cell1.layer.cornerRadius = 3
        let cell2 = UIView()
        cell2.backgroundColor = Color.paleOrange.UIColor
        cell2.layer.cornerRadius = 3
        let cell3 = UIView()
        cell3.backgroundColor = Color.superLightOrange.UIColor
        cell3.layer.cornerRadius = 3
        let cell4 = UIView()
        cell4.backgroundColor = Color.lightOrange.UIColor
        cell4.layer.cornerRadius = 3
        let cell5 = UIView()
        cell5.backgroundColor = Color.orange.UIColor
        cell5.layer.cornerRadius = 3
        longTimeCellDescriptionText = DetailLabel(text: "長", fontSize: 10)
        let cellDescriptionHorizontalView = UIStackView(arrangedSubviews: [shortTimeCellDescriptionText, cell1, cell2, cell3, cell4, cell5,  longTimeCellDescriptionText])
        cellDescriptionHorizontalView.axis = .horizontal
        cellDescriptionHorizontalView.distribution = .fillEqually   // 全ての要素の大きさを均等に
        cellDescriptionHorizontalView.spacing = 4
        
        // 円グラフ
        doneContentChartView = DoneContentsChartView()
        doneContentChartView.delegate = self
        
        // 円グラフのアイコン
//        doneContentUIImageView = DoneContentUIImageView(uiImage: UIImage())
        
        // MARK: - addSubview/layer
        contentsView.addSubview(calendarView)
        calendarView.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.top.equalTo(view.bounds.height * 0.1)
            make.width.equalTo(view.bounds.width * 0.9)
            make.height.equalTo(view.bounds.height * 0.5)
        }
        
        cell1.snp.makeConstraints { make -> Void in
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        
        contentsView.addSubview(cellDescriptionHorizontalView)
        cellDescriptionHorizontalView.snp.makeConstraints { make -> Void in
            make.right.equalTo(calendarView.snp.right)
            make.top.equalTo(calendarView.snp.bottom).offset(20)
        }
        
//        contentsView.addSubview(doneContentChartView)
//        doneContentChartView.snp.makeConstraints { make -> Void in
//            make.centerX.equalTo(view.bounds.width * 0.5)
//            make.centerY.equalTo(view.bounds.height * 0.8)
//            make.width.equalTo(300)
//            make.height.equalTo(300)
//        }
        
//        contentsView.addSubview(doneContentUIImageView)
//        doneContentUIImageView.backgroundColor = .white
//        doneContentUIImageView.snp.makeConstraints { make -> Void in
//            make.centerX.equalTo(view.bounds.width * 0.5)
//            make.centerY.equalTo(view.bounds.height * 0.8)
//            make.width.equalTo(80)
//            make.height.equalTo(80)
//        }
        
        scrollView.addSubview(contentsView)
        contentsView.snp.makeConstraints { make -> Void in
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(scrollView.frameLayoutGuide)
            make.edges.equalTo(scrollView.contentLayoutGuide)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make -> Void in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupBinding() {
        self.userIconButton.rx.tap
            .subscribe { _ in
                self.tabBarDelegate.showSlideMenu(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
}

// MARK: - CalendarViewDelegate
extension CalendarViewController: CalendarViewDelegate {
    func presentTransition(year: Int, month: Int, day: Int, dayOfWeek: String) {
        let dateString = "\(month)月\(day)日 (\(dayOfWeek))"
        let enterAndLeaveTimesOfDay = setEnterAndLeaveTimesOfDay(year: year, month: month, day: day, times: self.times)
        let stayingTimeStringOfDay = setStayingTimeStringOfDay(year: year, month: month, day: day, times: self.times)
        // モーダル表示, setupFloatingPanel() 実行ずみ の状態で呼ばれる
        let calendarDetailViewCotroller = CalendarDetailViewController(date: dateString, enterAndLeaveTimesOfDay: enterAndLeaveTimesOfDay, stayingTimeStringOfDay: stayingTimeStringOfDay)
        self.fpc.set(contentViewController: calendarDetailViewCotroller)
        self.fpc.addPanel(toParent: self, animated: true)
    }
}

// MARK: - FloatingPanelControllerDelegate
extension CalendarViewController: FloatingPanelControllerDelegate {
    func setupFloatingPanel() {
        self.fpc.delegate = self
        
        // モーダルを角丸にする
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 10.0
        self.fpc.surfaceView.appearance = appearance
        self.fpc.isRemovalInteractionEnabled = true   // 下へのスクロールで非表示
        self.fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true   // 背景タップで非表示
    }
    
    // .tip の位置になると画面をモーダルを削除する
    func floatingPanelWillBeginAttracting(_ fpc: FloatingPanelController, to state: FloatingPanelState) {
        if state == FloatingPanelState.tip {
            fpc.dismiss(animated: true, completion: nil)
        }
    }
    
    // カスタマイズしたレイアウトに変更(デフォルトで使用する際は不要)
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return CustomFloatingPanelLayout()
    }
}

// MARK: - ChartViewDelegate
extension CalendarViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(#function)
        if let dataSet = doneContentChartView.data?.dataSets[highlight.dataSetIndex] {
            let sliceIndex: Int = dataSet.entryIndex(entry: entry)
            print(sliceIndex)
            print(dataList[sliceIndex])   // .value, .label
            doneContentChartView.centerText = dataList[sliceIndex].label
            
            print(dataList[sliceIndex].icon!)
            self.doneContentUIImageView.image = dataList[sliceIndex].icon!
            
        }
    }
}

