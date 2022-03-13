//
//  UITextFieldExtension.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/13.
//

import UIKit

extension UITextField {
    func setUnderLine(color: UIColor) {
        print("frame: ", frame)
        // 枠線を非表示にする
        borderStyle = .none
        let underline = UIView()
        // heightにはアンダーラインの高さを入れる
        underline.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: 0.5)
        // 枠線の色
        underline.backgroundColor = color
        addSubview(underline)
        // 枠線を最前面に
        bringSubviewToFront(underline)
    }
}
