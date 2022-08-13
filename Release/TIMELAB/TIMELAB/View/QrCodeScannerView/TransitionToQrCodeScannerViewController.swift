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
    
    // MARK: - UI Parts
    var userStayingStatusLabel: QrCodeScannerLabel!
    var userStayingTimeLabel = QrCodeScannerLabel(text: "", size: 15)   // 滞在中のみ表示する
    var userStayingStatusUIImageView: QrCodeScannerUIImageView!
    var transitionButton: TransitionButton!
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 13.0, *) { presentingViewController?.beginAppearanceTransition(false, animated: animated) }
        super.viewWillAppear(animated)
        
        HUD.show(.progress)
        self.loadView()
        view.backgroundColor = .white
        setupViewType()
        // setupLayout()   // setupViewType() 内で呼び出されます
    }
    
    // MARK: - Function
    func setupViewType() {
        let transitionToQrCodeScannerViewModel = TransitionToQrCodeScannerViewModel()
        transitionToQrCodeScannerViewModel.userStateFromRooms
            .drive { userState in
                switch userState {
                case "stay": self.viewType = .stay
                case "home": self.viewType = .home
                default: self.viewType = .home
                }
                HUD.hide()
                self.loadView()
                self.setupLayout()
                self.setupBinding()
                print("UserState: \(userState)")
            }
            .disposed(by: disposeBag)
    }
    
    func setupLayout() {
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
        case .none:
            self.statusText = ""
            self.statusImageName = ""
            self.transitionButtonText = ""
        }
        print("switch 完了")
        
        view.backgroundColor = Color.white.UIColor
        
        userStayingStatusLabel = QrCodeScannerLabel(text: self.statusText, size: 30)
        userStayingStatusUIImageView = QrCodeScannerUIImageView(name: self.statusImageName)
        transitionButton = TransitionButton(text: self.transitionButtonText, textSize: 15)
        transitionButton.isSelected = false
        userStayingTimeLabel = QrCodeScannerLabel(text: "", size: 15)
        
        var transitionVerticalView = UIStackView(arrangedSubviews: [userStayingStatusLabel, userStayingTimeLabel,userStayingStatusUIImageView])
        var verticalSpacing = 35.0
        if (viewType == .stay) {
            // TODO: - ①入室時刻をFireStoreから取得して, ②滞在時間を計算する
            userStayingTimeLabel.text = "滞在時間 : 2時間43分"
            verticalSpacing = 20.0
        }
        transitionVerticalView.axis = .vertical
        transitionVerticalView.alignment = .center
        transitionVerticalView.spacing = verticalSpacing
        
        if viewType == .home {
            userStayingTimeLabel.snp.makeConstraints { make -> Void in
                make.width.equalTo(0)
                make.height.equalTo(0)
            }
        }
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
        
        transitionButton.rx.tap.asDriver()
            .drive { _ in
                print("ボタンが押されました")
                // モーダル画面遷移
                let qrCodeScannerViewController = QrCodeScannerViewController()
                self.present(qrCodeScannerViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
