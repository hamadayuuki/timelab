//
//  ChartColorTemplates+Extension.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2023/03/13.
//

import Charts
import UIKit

extension ChartColorTemplates {
    @objc open class func timesOfDay() -> [UIColor] {
        return [
            Color.superLightGray.UIColor,
            Color.navyBlue.UIColor,
        ]
    }
    
    // 00:00時点に研究室へ滞在している場合を想定
    @objc open class func timesOfDayAllNight() -> [UIColor] {
        return [
            Color.navyBlue.UIColor,
            Color.superLightGray.UIColor,
        ]
    }
}
