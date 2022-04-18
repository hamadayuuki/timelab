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
    func presentTransition()
}

class CalendarViewController: UIViewController, CalendarViewDelegate {
    
    var calendarView: CalendarView!
    var dateDictionary = ["2022/04/16", "2022/04/20", "2022/04/21"]   // 背景色変更 や 画像追加 を行う日付, TODO: FireStore から取得する
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // カレンダー の描画
        calendarView = CalendarView(deteDictionary: dateDictionary)
        calendarView.calendarViewDelegate = self
        view.addSubview(calendarView)
        calendarView.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.centerY.equalTo(view.bounds.height * 0.5)
            make.width.equalTo(view.bounds.width * 0.9)
            make.height.equalTo(view.bounds.height * 0.5)
        }
        
    }
    
    // MARK: - CalendarViewDelegate
    func presentTransition() {
        self.present(CalendarDetailViewController(), animated: true, completion: nil)
    }
    
}
