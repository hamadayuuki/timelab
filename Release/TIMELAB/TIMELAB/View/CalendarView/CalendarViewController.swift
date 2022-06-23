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

// 画面遷移用
protocol CalendarViewDelegate {
    func presentTransition(date: String)
}

class CalendarViewController: UIViewController {
    
    var dateDictionary = ["2022/04/16", "2022/04/20", "2022/04/21", "2022/06/20", "2022/06/21", "2022/06/22",  "2022/06/30"]   // 背景色変更 や 画像追加 を行う日付, TODO: FireStore から取得する
    var fpc: FloatingPanelController!
    
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
        
        setupLayout()
        setupFloatingPanel()
    }
    
    //画面を去るときにセミモーダルビューを非表示にする
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // セミモーダルビューを非表示にする
        self.fpc.removePanelFromParent(animated: true)
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
        appearance.cornerRadius = 36.0
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
