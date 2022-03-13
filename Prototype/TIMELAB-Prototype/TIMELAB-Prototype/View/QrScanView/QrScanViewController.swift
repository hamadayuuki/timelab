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
    
    lazy var maskCALayer: CALayer = {
        
        let centerX = view.bounds.width / 2.0
        let centerY = view.bounds.height / 2.0
        let maskWidth = 350.0
        let maskHeight = 500.0
        
        // くり抜かれる レイヤー
        let maskBackgroundLayer = CALayer()
        maskBackgroundLayer.bounds = view.bounds
        maskBackgroundLayer.position = view.center
        maskBackgroundLayer.backgroundColor = UIColor.black.cgColor
        maskBackgroundLayer.opacity = 0.2

        // くり抜く レイヤー
        let maskLayer = CAShapeLayer()
        maskLayer.bounds = maskBackgroundLayer.bounds
        let startPosition: [String: CGFloat] = ["x": centerX - (maskWidth / 2.0), "y": centerY - (maskHeight / 2.0)]
        let maskRect =  CGRect(x: startPosition["x"]!, y: startPosition["y"]!, width: maskWidth, height: maskHeight)
        
        // 描画
        let path =  UIBezierPath(rect: maskRect)
        path.append(UIBezierPath(rect: maskLayer.bounds))
        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.path = path.cgPath
        maskLayer.position = CGPoint(x: centerX, y: centerY)
        
        // マスクのルールをeven/oddに設定する
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        maskBackgroundLayer.mask = maskLayer
        return maskBackgroundLayer
    }()
    
    let qrTextLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
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
            make.center.equalTo(self.view)
            make.width.equalTo(200)
            make.height.equalTo(100)
        }
        
       view.layer.addSublayer(maskCALayer)
        qrScannerView.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(self.view)
            make.width.equalTo(view.bounds.width)
            make.height.equalTo(view.bounds.height)
         }
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

