//
//  UITextFieldExtension.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/13.
//

import UIKit

extension UITextField {
    func setUnderLine(color: UIColor, thickness: CGFloat) {
        print("frame: ", frame)
        // 枠線を非表示にする
        borderStyle = .none
        let underline = UIView()
        // heightにはアンダーラインの高さを入れる, 標準が 0.5
        underline.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: thickness)
        // 枠線の色
        underline.backgroundColor = color
        addSubview(underline)
        // 枠線を最前面に
        bringSubviewToFront(underline)
    }
}
