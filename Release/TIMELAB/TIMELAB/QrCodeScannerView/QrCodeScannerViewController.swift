//
//  QrCodeScannerViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/06.
//

import UIKit
import SnapKit
import QRScanner

class QrCodeScannerViewController: UIViewController {
    
    // MARK: UI Parts
    private var qrCodeScannerView: QRScannerView!
    private var maskCaLayer: MaskCaLayer!
    
    let qrTextLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.adjustsFontSizeToFitWidth = true   // 大きさを自動で変更
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()
    
    let reloadButton: UIButton = {
       let button = UIButton()
        button.setTitle("再読み込み", for: .normal)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 10
        return button
    }()
    
    let createLabRoomButton: UIButton = {
        let button = UIButton()
         button.setTitle("+", for: .normal)
         button.titleLabel?.textColor = .white
         button.backgroundColor = .blue
         button.layer.cornerRadius = 30
         return button
     }()
    
    var qrCodeUIImageView: UIImageView = {
        let image = UIImage(named: "qrCode")
        let uiImageView = UIImageView(image: image ?? UIImage())
        return uiImageView
    }()
    var qrWindowUIImageView: UIImageView = {
        let image = UIImage(named: "qrWindow")
        let uiImageView = UIImageView(image: image ?? UIImage())
        return uiImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupQrScanner()
        setLayout()
    }
    
    // MARK: Layout Functions
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
        qrTextLabel.text = ""
        
        // 最背面に配置する
        maskCaLayer = MaskCaLayer(view: self.view, maskWidth: 300, maskHeight: 300, cornerRadius: 10.0)
        view.layer.addSublayer(maskCaLayer)
        qrCodeScannerView.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(self.view)
            make.width.equalTo(view.bounds.width)
            make.height.equalTo(view.bounds.height)
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
        
        view.addSubview(qrTextLabel)
        qrTextLabel.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width / 2)
            make.centerY.equalTo((view.bounds.height / 2) + 100)
            make.width.equalTo(200)
            make.height.equalTo(100)
        }
        
        view.addSubview(reloadButton)
        reloadButton.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width / 2)
            make.centerY.equalTo(view.bounds.height * 0.8)
            make.width.equalTo(200)
            make.height.equalTo(100)
        }
        
        view.addSubview(createLabRoomButton)
        createLabRoomButton.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.8)
            make.centerY.equalTo(view.bounds.height * 0.2)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
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
}
