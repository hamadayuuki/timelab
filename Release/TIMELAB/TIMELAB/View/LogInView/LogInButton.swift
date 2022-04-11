//
//  LogInButton.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/10.
//

import UIKit
import SnapKit

class LogInButton: UIButton {
    init(text: String, textSize: CGFloat) {
        super.init(frame: .zero)
        
        self.backgroundColor = Color.navyBlue.UIColor
        self.layer.cornerRadius = 30
        self.setTitle(text, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: textSize, weight: .bold)
        self.setTitleColor(Color.white.UIColor, for: .normal)
        
        self.snp.makeConstraints { make -> Void in
            make.width.equalTo(210)
            make.height.equalTo(60)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                // ボタンのアニメーション
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                    self.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
                }) { (_) in
                    //             ↓ アニメーション時間  ↓ 待機時間  ↓ バネのような動き 振幅の大きさ(0~1)   ↓ 初速                 ↓ 追加機能
                    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
                        self.transform = .identity
                        
                    }, completion: nil)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

