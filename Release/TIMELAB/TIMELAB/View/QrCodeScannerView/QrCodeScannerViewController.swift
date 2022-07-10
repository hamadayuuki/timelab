//
//  QrCodeScannerViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/06.
//

import UIKit
import SnapKit
import QRScanner
import RxCocoa
import RxSwift

class QrCodeScannerViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    // MARK: - UI Parts
    private var qrCodeScannerView: QRScannerView!
    private var maskCaLayer: MaskCaLayer!
    var qrTextLabel: QrCodeScannerLabel!
    var reloadButton: QrCodeScannerButton!
    var createRoomButton: QrCodeScannerButton!
    var qrWindowUIImageView: QrCodeScannerUIImageView!
    var qrCodeUIImageView: QrCodeScannerUIImageView!
    var flashButton: QrCodeScannerButton!
    var moveIdAndPasswordViewButton: QrCodeScannerButton!
    var moveIdAndPasswordLabel: QrCodeScannerLabel!
    var moveHorizontalCenterLine: QrCodeScannerUIImageView!
    var moveQrCodeScannerViewButton: QrCodeScannerButton!
    var moveQrCodeScannerLabel: QrCodeScannerLabel!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupQrScanner()
        setLayout()
        setupBinding()
    }
    
    // MARK: - Functions
    private func setupQrScanner() {
        // QRScanner - メルカリ
        qrCodeScannerView = QRScannerView(frame: view.bounds)
        qrCodeScannerView.focusImage = UIImage()
        view.addSubview(qrCodeScannerView)   // qrScannerView 直後に置かないとエラー発生
        qrCodeScannerView.configure(delegate: self, input: .init(isBlurEffectEnabled: true))
        qrCodeScannerView.startRunning()
    }
    
    private func setLayout() {
        self.title = "QRコード"
        
        maskCaLayer = MaskCaLayer(view: self.view, maskWidth: 300, maskHeight: 300, cornerRadius: 10.0)
        
        qrTextLabel = QrCodeScannerLabel(text: "", size: 20.0, weight: .bold, color: Color.navyBlue.UIColor, backgroundColor: Color.white.UIColor)
        qrTextLabel.adjustsFontSizeToFitWidth = true   // 大きさを自動で変更
        qrTextLabel.textAlignment = .center
        
        // 再読み込みボタン
        reloadButton = QrCodeScannerButton(text: "再読み込み", textColor: Color.white.UIColor, backgroudColor: Color.orange.UIColor, cornerRadius: 20)
        createRoomButton = QrCodeScannerButton(text: "+", backgroudColor: Color.white.UIColor, cornerRadius: 10)
        qrWindowUIImageView = QrCodeScannerUIImageView(name: "QrWindow")
        qrCodeUIImageView = QrCodeScannerUIImageView(name: "WrCode")
        
        flashButton = QrCodeScannerButton(imageName: "Flash", imageSize: CGSize(width: 30, height: 30), text: "ライト", textColor: Color.white.UIColor, backgroudColor: Color.navyBlue.UIColor, cornerRadius: 20)
        
        // ID・パスワードでの入室画面への遷移ボタン
        moveIdAndPasswordViewButton = QrCodeScannerButton(imageName: "IdAndPassword", imageSize: CGSize(width: 60.0, height: 60.0), textColor: Color.white.UIColor)
        moveIdAndPasswordLabel = QrCodeScannerLabel(text: "ID・パスワードで入室", size: 11, weight: .regular, color: Color.white.UIColor)
        moveIdAndPasswordLabel.textAlignment = .center
        let moveIdAndPasswordVertical = UIStackView(arrangedSubviews: [moveIdAndPasswordViewButton, moveIdAndPasswordLabel])
        moveIdAndPasswordVertical.axis = .vertical
        
        // QRコード読み取りでの入室画面への遷移ボタン
        moveQrCodeScannerViewButton = QrCodeScannerButton(imageName: "QrCodeIcon", imageSize: CGSize(width: 30.0, height: 30.0), textColor: Color.white.UIColor)
        moveQrCodeScannerLabel = QrCodeScannerLabel(text: "QRコード読み取り", size: 11, weight: .regular, color: Color.white.UIColor)
        moveQrCodeScannerLabel.textAlignment = .center
        let moveQrCodeScannerVertical = UIStackView(arrangedSubviews: [moveQrCodeScannerViewButton, moveQrCodeScannerLabel])
        moveQrCodeScannerVertical.axis = .vertical
        
        let moveButtonHorizontalView = UIStackView(arrangedSubviews: [moveIdAndPasswordVertical, moveQrCodeScannerVertical])
        moveButtonHorizontalView.axis = .horizontal
        moveButtonHorizontalView.distribution = .fillProportionally
        moveButtonHorizontalView.backgroundColor = Color.navyBlue.UIColor
        
        // 遷移ボタンを分ける中央線
        moveHorizontalCenterLine = QrCodeScannerUIImageView(name: "CenterLine")
        moveHorizontalCenterLine.backgroundColor = Color.navyBlue.UIColor
        
        // MARK: - addSubview/layer
        // 最背面に配置する
        view.layer.addSublayer(maskCaLayer)
        qrCodeScannerView.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(self.view)
            make.width.equalTo(view.bounds.width)
            make.height.equalTo(view.bounds.height)
         }
        
        view.addSubview(createRoomButton)
        createRoomButton.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.8)
            make.centerY.equalTo(view.bounds.height * 0.2)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
        view.addSubview(qrTextLabel)
        qrTextLabel.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.4)
            make.centerY.equalTo(view.bounds.height * 0.2)
            make.width.equalTo(200)
            make.height.equalTo(100)
        }
        
        view.addSubview(qrCodeUIImageView)
        qrCodeUIImageView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view.bounds.width / 2)
            make.centerY.equalTo(view.bounds.height / 2)
            make.width.equalTo(280)
            make.height.equalTo(280)
         }
        
        view.addSubview(qrWindowUIImageView)
        qrWindowUIImageView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view.bounds.width / 2)
            make.centerY.equalTo(view.bounds.height / 2)
            make.width.equalTo(300)   // 画像が描画される時にできる余白 100
            make.height.equalTo(300)
         }
        
        view.addSubview(flashButton)
        flashButton.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.top.equalTo(qrWindowUIImageView.snp.bottom).offset(20)
            make.width.equalTo(100)   // 画像が描画される時にできる余白 100
            make.height.equalTo(50)
         }
        
        view.addSubview(reloadButton)
        reloadButton.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.8)
            make.centerY.equalTo(view.bounds.height * 0.8)
            make.width.equalTo(130)
            make.height.equalTo(65)
        }
        
        moveIdAndPasswordLabel.snp.makeConstraints { make -> Void in
            make.height.equalTo(30)
        }
        moveIdAndPasswordVertical.snp.makeConstraints { make -> Void in
            make.width.equalTo(view.bounds.width * 0.5)
            make.height.equalTo(90)
        }
        moveQrCodeScannerLabel.snp.makeConstraints { make -> Void in
            make.height.equalTo(30)
        }
        moveQrCodeScannerVertical.snp.makeConstraints { make -> Void in
            make.width.equalTo(view.bounds.width * 0.5)
            make.height.equalTo(90)
        }
        
        view.addSubview(moveButtonHorizontalView)
        moveButtonHorizontalView.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.centerY.equalTo(view.bounds.height - 70)
            make.width.equalTo(view.bounds.width)
            make.height.equalTo(90)
        }
        
        view.addSubview(moveHorizontalCenterLine)
        moveHorizontalCenterLine.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.centerY.equalTo(view.bounds.height - 70)
            make.height.equalTo(50)
        }
        
    }
    
    func setupBinding() {
        flashButton.rx.tap
            .subscribe { _ in
                self.qrCodeScannerView.setTorchActive(isOn: !self.flashButton.isSelected)
            }
            .disposed(by: disposeBag)
    }
    
}

extension QrCodeScannerViewController: QRScannerViewDelegate {
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        print(error)
    }
    
    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        print(code)
        qrTextLabel.text = code
        
//        qrScanViewModel = QrScanViewModel(roomId: code)
        let qrCodeScannerViewModel = QrCodeScannerViewModel(roomId: code)
        
        qrCodeScannerViewModel.isRegisterUserState
            .drive { isSuccess in
                print("ユーザーの滞在状況登録: ", isSuccess)
            }
            .disposed(by: disposeBag)
        
//        // ! ここで定義しないと VM, M のプログラムは動かない
//        qrScanViewModel.isCheckAndRegistRoom
//            .drive { isCheckAndRegist in
//                print("V, ユーザーが対象の研究室を登録しているか: ", isCheckAndRegist)
//            }
//            .disposed(by: disposeBag)
//
//        qrScanViewModel.isRegisterEnterTime   // ?filter で除外された時は 何も返ってこないため、ここは実行されない
//            .drive { isEnter in
//                print("V, ユーザーの入室登録: ", isEnter)
//                if isEnter {
//                    // TODO: 入室後の画面を作成し遷移する
//                    let calendarViewController = CalendarViewController()
//                    self.present(calendarViewController, animated: true, completion: nil)
//                }
//            }
//            .disposed(by: disposeBag)
//
//        qrScanViewModel.isRegistUserStateToRooms
//            .drive { isRegistUserState in
//                print("研究室ごとのユーザー滞在状態の更新: ", isRegistUserState)
//            }
//            .disposed(by: disposeBag)
//
//        qrScanViewModel.isRegisterLeaveTime
//            .drive { isLeave in
//                print("V, ユーザーの退室登録: ", isLeave)
//                if isLeave {
//                    // TODO: 退室後の画面を作成し遷移する
//                    let rankingView = RankingViewController()
//                    self.present(rankingView, animated: true, completion: nil)
//                }
//            }
//            .disposed(by: disposeBag)
    }
    
    // ライトのオンオフ
    func qrScannerView(_ qrScannerView: QRScannerView, didChangeTorchActive isOn: Bool) {
        self.flashButton.isSelected = isOn
    }
}
