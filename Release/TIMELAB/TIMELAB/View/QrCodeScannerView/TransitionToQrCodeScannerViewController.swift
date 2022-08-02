//
//  TransitionToQrCodeScannerViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/05/24.
//

import UIKit
import SnapKit
import PKHUD
import RxCocoa
import RxSwift

class TransitionToQrCodeScannerViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    var viewType: TransitionQrScannerType!   // TODO: FireStoreから取得したデータを使用する
    var statusText = ""
    var statusImageName = ""
    var transitionButtonText = ""
    
    init(viewType: TransitionQrScannerType) {
        super.init(nibName: nil, bundle: nil)
        
        self.viewType = viewType
        switch viewType {
        case .home:
            self.statusText = "お休み中･･･"
            self.statusImageName = "WomanReading"
            self.transitionButtonText = "入室する"
        case .stay:
            self.statusText = "滞在中"
            self.statusImageName = "WorkingInALaboratory"
            self.transitionButtonText = "退室する"
        case .transitioned:
            self.statusText = "頑張りましょう！"
            self.statusImageName = "BusinessMeeting"
            self.transitionButtonText = "OK"
        }
        
    }
    
    // MARK: - UI Parts
    var userStayingStatusLabel: QrCodeScannerLabel!
    var userStayingTimeLabel = QrCodeScannerLabel(text: "", size: 15)   // 滞在中のみ表示する
    var userStayingStatusUIImageView: QrCodeScannerUIImageView!
    var transitionButton: TransitionButton!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBinding()
    }
    
    // MARK: - Function
    func setupLayout() {
        view.backgroundColor = Color.white.UIColor
        
        userStayingStatusLabel = QrCodeScannerLabel(text: self.statusText, size: 30)
        userStayingStatusUIImageView = QrCodeScannerUIImageView(name: self.statusImageName)
        transitionButton = TransitionButton(text: self.transitionButtonText, textSize: 15)
        
        var transitionVerticalView = UIStackView(arrangedSubviews: [userStayingStatusLabel, userStayingStatusUIImageView])
        var verticalSpacing = 80.0
        if (viewType == .stay) {
            // TODO: - ①入室時刻をFireStoreから取得して, ②滞在時間を計算する
            userStayingTimeLabel = QrCodeScannerLabel(text: "滞在時間 : 2時間43分", size: 15)
            transitionVerticalView = UIStackView(arrangedSubviews: [userStayingStatusLabel, userStayingTimeLabel,  userStayingStatusUIImageView])
            verticalSpacing = 20.0
        }
        transitionVerticalView.axis = .vertical
        transitionVerticalView.alignment = .center
        transitionVerticalView.spacing = verticalSpacing
        
        userStayingStatusUIImageView.snp.makeConstraints { make -> Void in
            make.width.equalTo(390)
            make.height.equalTo(295)
        }
        
        // MARK: - addSubview/layer
        view.addSubview(transitionVerticalView)
        transitionVerticalView.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.centerY.equalTo(view.bounds.height * 0.45)
        }
        
        view.addSubview(transitionButton)
        transitionButton.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.top.equalTo(transitionVerticalView.snp.bottom).offset(35)
        }
        
    }
    
    func setupBinding() {
        // 背景をタップしたらキーボードを隠す
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)
        
        transitionButton.rx.tap
            .subscribe { _ in
                HUD.show(.progress)   // ローディング表示
                self.transitionButton.isSelected = !self.transitionButton.isSelected
                self.transitionButton.backgroundColor = self.transitionButton.isSelected ? Color.lightGray.UIColor : Color.navyBlue.UIColor
                // 3秒後にローディングを消す
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    HUD.hide()
                    self.transitionButton.isSelected = !self.transitionButton.isSelected
                    self.transitionButton.backgroundColor = self.transitionButton.isSelected ? Color.lightGray.UIColor : Color.navyBlue.UIColor
                    // push画面遷移
                    let qrCodeScannerViewController = QrCodeScannerViewController()
                    qrCodeScannerViewController.hidesBottomBarWhenPushed = true   // 遷移後画面でタブバーを隠す
                    self.navigationController?.pushViewController(qrCodeScannerViewController, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
