//
//  SaveRoomQrCodeViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/06/07.
//

import SwiftUI
import SnapKit
import RxSwift
import RxCocoa
import PKHUD

class SaveRoomQrCodeViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    //var registerUserViewModel: RegisterUserViewModel!
    var isProgressView  = false
    
    // MARK: - UI Parts
    var introductionLabel: RegisterRoomLabel!
    var explanationNextStepLabel: RegisterRoomLabel!
    
    var roomQrCodeUIImageView: RoomQrCodeUIImageView!
    var qrCodeData: Data!
    
    var saveRoomQrCodeButton: SaveRoomQrCodeButton!
    
    var introductionUIImageView: RegisterRoomUIImageView!
    var explanationLabel: RegisterRoomLabel!
    
    init(qrCodeData: Data) {
        super.init(nibName: nil, bundle: nil)
        
        self.qrCodeData = qrCodeData
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        displayRoomQrOnboardingView()
        setupLayout()
        setupBinding()
    }
    
    // MARK: - Function

    private func displayRoomQrOnboardingView() {
        let roomQrOnboardingVC = UIHostingController(rootView: RoomQrOnboardingView(dismiss: {
            self.dismiss(animated: true)
        }))
        roomQrOnboardingVC.view.backgroundColor = .clear
        self.modalPresentationStyle = .popover
        self.present(roomQrOnboardingVC, animated: true)
    }
    
    private func setupLayout() {
        self.view.backgroundColor = .white
        
        let width = view.bounds.width
        let height = view.bounds.height
        
        introductionUIImageView = RegisterRoomUIImageView(name: "ChatRobot", size: CGSize(width: 263, height: 197))
        introductionLabel = RegisterRoomLabel(text: "QRコード作成完了！", size: 25, color: Color.orange.UIColor)
        //explanationNextStepLabel = RegisterRoomLabel(text: "続きてID登録に入ります", size: 12)
        explanationNextStepLabel = RegisterRoomLabel(text: "", size: 12)
        
        roomQrCodeUIImageView = RoomQrCodeUIImageView(qrCodeData: qrCodeData)
        
        saveRoomQrCodeButton = SaveRoomQrCodeButton(text: "保存", textSize: 15)
        
        explanationLabel = RegisterRoomLabel(text: "QRコードを保存・印刷して\n使う部屋のドアに貼って\nみんなで使いましょう！", size: 12)
        
        let introductionVertical = UIStackView(arrangedSubviews: [introductionLabel, explanationNextStepLabel])
        introductionVertical.axis = .vertical
        introductionVertical.spacing = 10
        
        // MARK: - addSubview/layer
        view.addSubview(roomQrCodeUIImageView)
        roomQrCodeUIImageView.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(self.view.bounds.height * 0.45)
            make.centerX.equalTo(self.view.bounds.width * 0.5)
        }
        
        view.addSubview(introductionVertical)
        introductionVertical.snp.makeConstraints { make -> Void in
            make.bottom.equalTo(roomQrCodeUIImageView.snp.top).offset(-40)
            make.centerX.equalTo(self.view.bounds.width * 0.5)
        }
        
        view.addSubview(saveRoomQrCodeButton)
        saveRoomQrCodeButton.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.top.equalTo(roomQrCodeUIImageView.snp.bottom).offset(40)
        }
        
        view.addSubview(introductionUIImageView)
        introductionUIImageView.snp.makeConstraints { make -> Void in
            make.top.equalTo(saveRoomQrCodeButton.snp.bottom).offset(10)
            make.left.equalTo(137)
        }
        
        view.addSubview(explanationLabel)
        explanationLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(introductionUIImageView.snp.top).offset(120)
            make.centerX.equalTo(introductionUIImageView.snp.left)
        }
        
    }
    
    private func setupBinding() {
         let saveRoomQrCodeViewModel: SaveRoomQrCodeViewModel!
        
        saveRoomQrCodeViewModel = SaveRoomQrCodeViewModel(saveButton: saveRoomQrCodeButton.rx.tap.asSignal(), qrCodeData: qrCodeData)
        
        // 背景をタップしたらキーボードを隠す
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)
        
        saveRoomQrCodeButton.rx.tap
            .subscribe { _ in
                HUD.show(.progress)   // ローディング表示
                self.saveRoomQrCodeButton.isSelected = !self.saveRoomQrCodeButton.isSelected
                self.saveRoomQrCodeButton.backgroundColor = self.saveRoomQrCodeButton.isSelected ? Color.lightGray.UIColor : Color.navyBlue.UIColor
                // 0.5秒後にローディングを消す
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    HUD.hide()
                    self.saveRoomQrCodeButton.isSelected = !self.saveRoomQrCodeButton.isSelected
                    self.saveRoomQrCodeButton.backgroundColor = self.saveRoomQrCodeButton.isSelected ? Color.lightGray.UIColor : Color.navyBlue.UIColor
                    // push画面遷移
                    let tabBarViewController = TabBarViewController()
                    tabBarViewController.hidesBottomBarWhenPushed = true   // 遷移後画面でタブバーを隠す
                    self.navigationController?.pushViewController(tabBarViewController, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        saveRoomQrCodeViewModel.isSaveRoomQrCode
            .drive { isSaveQrCode in
                print("QRコードの保存: ", isSaveQrCode)
            }
            .disposed(by: disposeBag)
        
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
