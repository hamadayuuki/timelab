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

// 画面遷移用
protocol CalendarViewDelegate {
    func presentTransition(date: String)
}

class CalendarViewController: UIViewController {
    let disposeBag = DisposeBag()
    var enterScheduleAndStayingTimeDic: [String: Int] = [:] // ["2022/04/16": 10, "2022/04/20": 30, "2022/04/21": 10]
    var fpc: FloatingPanelController!
    var doneContentChartView: DoneContentsChartView!
    var doneContentUIImageView: DoneContentUIImageView!
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
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.fpc = FloatingPanelController()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - UI Parts
    var calendarView: CalendarView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        HUD.show(.progress)
        setupMonthCalendarTime()
//        setupLayout()   // setupMonthCalendarTime() 内で呼ばれる
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
                print(monthCalendarTimes)
                for monthCalendarTime in monthCalendarTimes {
                    //self.dateDictionary.append(dateFormatter.string(from: monthCalendarTime["enterTimeDate"] as! Date))
                    let enterTimeDate = monthCalendarTime["enterAtDate"] as! Date
                    let leaveTimeDate = monthCalendarTime["leaveAtDate"] as! Date
                    let stayingTimeAtSecond = monthCalendarTime["stayingTimeAtSecond"] as! Int
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
                            let addDayDate = calendar.date(byAdding: .day, value: i, to: enterTimeDate)!
                            self.enterScheduleAndStayingTimeDic[dateFormatter.string(from: addDayDate)] = 24 * 60 * 60
                        }
                        // 退室日の00:00 と 退室時刻 の差, 秒
                        let leaveDayStartDate = calendar.startOfDay(for: leaveTimeDate)
                        let diffLeaveAndLeaveDayStart = leaveTimeDate.timeIntervalSince(leaveDayStartDate)
                        self.enterScheduleAndStayingTimeDic[dateFormatter.string(from: leaveTimeDate)] = Int(diffLeaveAndLeaveDayStart)
                        // 入室日の滞在時間を調整
                        self.enterScheduleAndStayingTimeDic[dateFormatter.string(from: enterTimeDate)]! += Int(diffEnterAndNextDayStart)
                    }
                }
                
                self.setupLayout()
                self.setupFloatingPanel()
                HUD.hide()
            }
            .disposed(by: disposeBag)
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        
        // カレンダー の描画
        calendarView = CalendarView(dateAndStayingTimeDic: enterScheduleAndStayingTimeDic)
        calendarView.calendarViewDelegate = self   // 画面遷移のために指定
        
        // 円グラフ
        doneContentChartView = DoneContentsChartView()
        doneContentChartView.delegate = self
        
        // 円グラフのアイコン
        doneContentUIImageView = DoneContentUIImageView(uiImage: UIImage())
        
        // MARK: - addSubview/layer
        contentsView.addSubview(calendarView)
        calendarView.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.top.equalTo(view.bounds.height * 0.1)
            make.width.equalTo(view.bounds.width * 0.9)
            make.height.equalTo(view.bounds.height * 0.5)
        }
        
        /*
        contentsView.addSubview(doneContentChartView)
        doneContentChartView.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.centerY.equalTo(view.bounds.height * 0.8)
            make.width.equalTo(300)
            make.height.equalTo(300)
        }
        
        contentsView.addSubview(doneContentUIImageView)
        doneContentUIImageView.backgroundColor = .white
        doneContentUIImageView.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.centerY.equalTo(view.bounds.height * 0.8)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        */
        
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
    
}

// MARK: - CalendarViewDelegate
extension CalendarViewController: CalendarViewDelegate {
    func presentTransition(date: String) {
        // モーダル表示, setupFloatingPanel() 実行ずみ の状態で呼ばれる
        let calendarDetailViewCotroller = CalendarDetailViewController(date: date)
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

