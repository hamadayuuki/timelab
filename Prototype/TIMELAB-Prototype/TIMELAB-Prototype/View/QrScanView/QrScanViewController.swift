//
//  QrScanViewController.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/12.
//

import UIKit
import QRScanner
import SnapKit
import RxSwift
import RxCocoa

class QrScanViewController: UIViewController {

    private var qrScannerView: QRScannerView!
    private var qrFrameSize: CGRect!
    private var maskCALayer: MaskCALayer!
    private let disposeBag  = DisposeBag()
    private var qrScanViewModel: QrScanViewModel!
    
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
        setupBinding()
    }
    
    private func setupQrScanner() {
        // QRScanner - メルカリ
        qrScannerView = QRScannerView(frame: view.bounds)
        qrScannerView.focusImage = UIImage()
        view.addSubview(qrScannerView)   // qrScannerView 直後に置かないとエラー発生
        qrScannerView.configure(delegate: self, input: .init(isBlurEffectEnabled: true))
        qrScannerView.startRunning()
    }
    
    private func setLayout() {
        self.title = "QRコード"
        qrTextLabel.text = ""
        
        // 最背面に配置する
        maskCALayer = MaskCALayer(view: self.view, maskWidth: 300, maskHeight: 300)
        view.layer.addSublayer(maskCALayer)
        qrScannerView.snp.makeConstraints { (make) -> Void in
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
    
    private func setupBinding() {
        reloadButton.rx.tap
            .subscribe { [weak self] _ in
                self?.loadView()
                self?.viewDidLoad()
            }
            .disposed(by: disposeBag)
        
        createLabRoomButton.rx.tap
            .subscribe { [weak self] _ in
                
            }
            .disposed(by: disposeBag)
    }

}

extension QrScanViewController: QRScannerViewDelegate {
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        print(error)
    }
    
    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        qrScanViewModel = QrScanViewModel(roomId: code)
        print(code)
        qrTextLabel.text = code
        qrScanViewModel.isCheckAndRegistRoom
            .drive { result in
                print("V, ユーザーの入退室結果: ", result)
            }
            .disposed(by: disposeBag)
    }
}

