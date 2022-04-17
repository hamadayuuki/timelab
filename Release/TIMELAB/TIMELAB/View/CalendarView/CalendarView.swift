//
//  CalendarView.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/17.
//

import UIKit
import FSCalendar

class CalendarView: FSCalendar {
    
    var dateDictionary: [String]!
    
    init(deteDictionary: [String]) {
        super.init(frame: .zero)
        
        self.dateDictionary = deteDictionary
        setupFSCalendar()
    }
    
    func setupFSCalendar() {
        self.dataSource = self
        self.delegate = self
        
        // 表示
        self.scrollDirection = .vertical //スクロールの方向
        self.scope = .month //表示の単位（週単位: .week or 月単位: .month）
        self.locale = Locale(identifier: "ja") //表示の言語の設置（日本語表示の場合は"ja"）
        // ヘッダー
        self.appearance.headerTitleFont = UIFont.systemFont(ofSize: 20) //ヘッダーテキストサイズ
        self.appearance.headerDateFormat = "yyyy/MM" //ヘッダー表示のフォーマット
        self.appearance.headerTitleColor = UIColor.label //ヘッダーテキストカラー
        // 曜日表示
        self.appearance.weekdayFont = UIFont.systemFont(ofSize: 20) //曜日表示のテキストサイズ
        self.appearance.weekdayTextColor = .darkGray //曜日表示のテキストカラー
        self.appearance.titleWeekendColor = .red //週末（土、日曜の日付表示カラー）
        // カレンダー日付表示
        self.appearance.titleFont = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold) //日付のテキスト、ウェイトサイズ
        self.appearance.titleOffset = CGPoint(x: 0, y: -10)   // 日付の位置をずらす
        self.appearance.todayColor = .clear //本日の選択カラー
        self.appearance.titleTodayColor = .orange //本日のテキストカラー
        
        self.appearance.selectionColor = .blue //選択した日付のカラー
        self.appearance.borderSelectionColor = .blue //選択した日付のボーダーカラー
        self.appearance.titleSelectionColor = .black //選択した日付のテキストカラー
                
        self.appearance.borderRadius = 0 //本日・選択日の塗りつぶし角丸量
        
        self.appearance.imageOffset = CGPoint(x: 0, y: -5)   // 画像の位置をずらす
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - FSCalendar Delegate
extension CalendarView: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    // イベントの有無で背景色を変更する
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        // カレンダーから日付を取得
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        let calendarDay = formatter.string(from: date)   // 1月分のカレンダー画面に表示されている日付(yyyy/mm/dd)が全て呼ばれる
        
        // 背景を描画, ユーザーの行動によって背景色が変化, TODO: 描画する背景色を可変に
        let cellWidth = cell.bounds.width
        let cellHeight = cell.bounds.height
        cell.bounds = CGRect(x: 0, y: 0, width: cellWidth - 3, height: cellHeight - 3)
        // 予定がある時
        if self.dateDictionary.contains(calendarDay) {
            cell.backgroundColor = .orange
        } else {
            cell.backgroundColor = .clear
        }
        cell.layer.cornerRadius = 5
    }
    
    // タップされた日付を取得する
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let tmpDate = Calendar(identifier: .gregorian)
        let year = tmpDate.component(.year, from: date)
        let month = tmpDate.component(.month, from: date)
        let day = tmpDate.component(.day, from: date)
        let dateString = "\(year)/\(month)/\(day)"
        print("dateString: ", dateString)
    }
    
    // カレンダーの日付に画像を描画する
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        let calendarDay = formatter.string(from: date)   // 1月分のカレンダー画面に表示されている日付(yyyy/mm/dd)が全て呼ばれる
        
        // 画像を描画, TODO: 描画する画像を可変に
        let pencilAndNote = UIImage(named: "PencilAndNote")
        let Resize: CGSize = CGSize.init(width: 20, height: 20) // サイズ指定
        let pencilAndNoteResize = pencilAndNote?.reSizeImage(reSize: Resize)
        
        if self.dateDictionary.contains(calendarDay) {
            return pencilAndNoteResize
        } else {
            return UIImage()
        }
    }
    
}
