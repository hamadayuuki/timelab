//
//  Color.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/06.
//
import UIKit

enum Color: String {
    case orange    = "F29021"
    case white     = "FFFFFF"
    case gray      = "707070"
    case lightGray = "CECECE"
    case navyBlue  = "111B3A"
    
    // カレンダーの日付背景色
    case paleOrange  = "FCDDBE"
    case lightBrown  = "F5BA7F"
    case lightOrange = "FFA858"
    
    var UIColor: UIKit.UIColor {
        return UIKit.UIColor(hex: self.rawValue)!
    }
    var cgColor: UIKit.CGColor {
        return self.UIColor.cgColor
    }
}
