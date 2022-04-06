//
//  UIColorExtension.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/06.
//

import UIKit

// HEX("#FFFFFF")からUIColorに変換する拡張
extension UIColor {
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        let validatedHexColorCode = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: validatedHexColorCode)
        var colorCode: UInt32 = 0
        
        guard scanner.scanHexInt32(&colorCode) else {
            print("ERROR: 色変換に失敗しました。")
            return nil
        }
        
        let R = CGFloat((colorCode & 0xFF0000) >> 16) / 255.0
        let G = CGFloat((colorCode & 0x00FF00) >> 8) / 255.0
        let B = CGFloat(colorCode & 0x0000FF) / 255.0
        self.init(displayP3Red: R, green: G, blue: B, alpha: alpha)
    }
}
