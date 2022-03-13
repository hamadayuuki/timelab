//
//  QrScanViewController.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/12.
//

import UIKit
import QRScanner
import SnapKit
import CoreAudio

class QrScanViewController: UIViewController {

    private var qrScannerView: QRScannerView!
    private var qrFrameSize: CGRect!
    private var maskCALayer: MaskCALayer!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupQrScanner()
        setLayout()
    }
    
    private func setupQrScanner() {
        // QRScanner - メルカリ
        qrScannerView = QRScannerView(frame: view.bounds)
        view.addSubview(qrScannerView)   // qrScannerView 直後に置かないとエラー発生
        qrScannerView.configure(delegate: self, input: .init(isBlurEffectEnabled: true))
        qrScannerView.startRunning()
    }
    
    private func setLayout() {
        view.addSubview(qrTextLabel)
        qrTextLabel.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width / 2)
            make.centerY.equalTo((view.bounds.height / 2) + 100)
            make.width.equalTo(200)
            make.height.equalTo(100)
        }
        
//        maskCALayer = MaskCALayer(view: self.view, maskWidth: 300, maskHeight: 300)
//        view.layer.addSublayer(maskCALayer)
//        qrScannerView.snp.makeConstraints { (make) -> Void in
//            make.center.equalTo(self.view)
//            make.width.equalTo(view.bounds.width)
//            make.height.equalTo(view.bounds.height)
//         }
    }

}

extension QrScanViewController: QRScannerViewDelegate {
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        print(error)
    }
    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        print(code)
        qrTextLabel.text = code
    }
}

