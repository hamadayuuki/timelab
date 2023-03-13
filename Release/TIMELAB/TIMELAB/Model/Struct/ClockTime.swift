//
//  ClockTime.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2023/03/13.
//

import Foundation

struct ClockTime {
    var start: String   // "HH:MM"
    var end: String   // "HH:MM"
    
    init(start: String, end: String) {
        self.start = start
        self.end = end
    }
}
