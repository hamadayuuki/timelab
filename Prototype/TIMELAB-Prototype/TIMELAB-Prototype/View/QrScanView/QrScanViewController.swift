//
//  QrScanViewController.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/12.
//

import UIKit
import QRScanner

class QrScanViewController: UIViewController {

    private var qrFrameSize: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // QRScanner - メルカリ
        qrFrameSize = CGRect(x: 0.0, y: 0.0, width: 500, height: 500)
        let qrScannerView = QRScannerView(frame: qrFrameSize)
        qrScannerView.backgroundColor = .red
        view.addSubview(qrScannerView)
        qrScannerView.configure(delegate: self)
        qrScannerView.startRunning()
    }


}

extension QrScanViewController: QRScannerViewDelegate {
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        print(error)
    }
    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        print(code)
    }
}

