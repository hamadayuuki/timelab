//
//  DateExtension.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/07/16.
//

import UIKit

extension Date {
    func UTCtoJST(date: Date) -> Date {
        return Calendar.current.date(byAdding: .hour, value: 9, to: date)!
    }
}
