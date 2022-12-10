//
//  UILabelExtension.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/11.
//

import UIKit

// 未使用, SnapKit でレイアウトすると使用しづらい
extension UILabel {
    func underLine(color: UIColor, thickness: CGFloat, frame: CGSize) {
        print("frame: ", frame)
        // 枠線を非表示にする
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

