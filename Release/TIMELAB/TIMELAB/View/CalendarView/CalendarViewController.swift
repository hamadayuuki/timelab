//
//  CalendarViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/17.
//

import UIKit
import SnapKit
import FSCalendar

// 画面遷移用
protocol CalendarViewDelegate {
    func presentTransition(date: String)
}

class CalendarViewController: UIViewController, CalendarViewDelegate {
    
    var dateDictionary = ["2022/04/16", "2022/04/20", "2022/04/21"]   // 背景色変更 や 画像追加 を行う日付, TODO: FireStore から取得する
    
    // MARK: - UI Parts
    var calendarView: CalendarView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    // MARK: - Function
    private func setupLayout() {
        view.backgroundColor = .white
        
        // カレンダー の描画
        calendarView = CalendarView(deteDictionary: dateDictionary)
        calendarView.calendarViewDelegate = self   // 画面遷移のために指定
        
        // MARK: - addSubview/layer
        view.addSubview(calendarView)
        calendarView.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.centerY.equalTo(view.bounds.height * 0.5)
            make.width.equalTo(view.bounds.width * 0.9)
            make.height.equalTo(view.bounds.height * 0.5)
        }
    }
    
    // MARK: - CalendarViewDelegate
    func presentTransition(date: String) {
        self.present(CalendarDetailViewController(date: date), animated: true, completion: nil)
    }
    
}
