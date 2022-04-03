//
//  ConfirmRoomQrCodeViewController.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/04/04.
//

import UIKit
import SnapKit

class ConfirmRoomQrCodeViewController: UIViewController {
    
    var confirmQrCodeUIImageView: UIImageView!
    
    init(qrCodeData: Data) {
        super.init(nibName: nil, bundle: nil)
        
        self.confirmQrCodeUIImageView = {
            let uiImage = UIImage(data: qrCodeData)!
            let uiImageView = UIImageView(image: uiImage)
            return uiImageView
        }()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    func setupLayout() {
        view.addSubview(self.confirmQrCodeUIImageView)
        self.confirmQrCodeUIImageView.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width / 2)
            make.top.equalTo((view.bounds.height/2) - 150)
            make.width.equalTo(300)
            make.height.equalTo(300)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



