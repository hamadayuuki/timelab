//
//  TransitionToMemoViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/06/08.
//

import UIKit
import SnapKit
import PKHUD
import RxCocoa
import RxSwift

class TransitionToMemoViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    // MARK: - UI Parts
    var thanksCommentLabel: QrCodeScannerLabel!
    var userStayingTimeLabel = QrCodeScannerLabel(text: "", size: 15)   // 滞在中のみ表示する
    var thanksUIImageView: QrCodeScannerUIImageView!
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
        
        thanksCommentLabel = QrCodeScannerLabel(text: "お疲れ様でした！", size: 30)
        thanksUIImageView = QrCodeScannerUIImageView(name: "WebDevelopment")
        userStayingTimeLabel = QrCodeScannerLabel(text: "滞在時間 : 2時間43分", size: 15)
        transitionButton = TransitionButton(text: "今日のメモをする", textSize: 15, imageName: "RightArrow", textPosition: .left, backgroundColor: Color.orange.UIColor)
        var transitionVerticalView = UIStackView(arrangedSubviews: [thanksCommentLabel, thanksUIImageView, userStayingTimeLabel, transitionButton])
        
        transitionVerticalView.axis = .vertical
        transitionVerticalView.alignment = .center
        transitionVerticalView.spacing = 30
        
        thanksUIImageView.snp.makeConstraints { make -> Void in
            make.width.equalTo(390)
            make.height.equalTo(295)
        }
        
        // MARK: - addSubview/layer
        view.addSubview(transitionVerticalView)
        transitionVerticalView.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.centerY.equalTo(view.bounds.height * 0.5)
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
                    let registerNickNameViewController = RegisterNickNameViewController()
                    self.navigationController?.pushViewController(registerNickNameViewController, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
}
