//
//  TimeDirection.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2023/03/13.
//

import Foundation

enum TimeDirection {
    case north
    case south
    case west
    case east
    
    var timeText: String {
        switch self {
        case .north: return "0"
        case .south: return "6"
        case .west: return "12"
        case .east: return "18"
        }
    }
}
