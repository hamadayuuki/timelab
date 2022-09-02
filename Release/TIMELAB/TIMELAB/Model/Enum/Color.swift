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
    //case orange          = "F29021"
    case lightOrange       = "FCA747"
    case superLightOrange  = "FFC481"
    case paleOrange        = "FCE3C6"
    case superLightGray    = "EDEDED"
    
    var UIColor: UIKit.UIColor {
        return UIKit.UIColor(hex: self.rawValue)!
    }
    var cgColor: UIKit.CGColor {
        return self.UIColor.cgColor
    }
}
