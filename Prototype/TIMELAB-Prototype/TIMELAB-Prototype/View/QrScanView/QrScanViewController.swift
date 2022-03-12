//
//  QrScanViewController.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/12.
//

import UIKit
import QRScanner

class QrScanViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // QRScanner - メルカリ
        let qrScannerView = QRScannerView(frame: view.bounds)
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

