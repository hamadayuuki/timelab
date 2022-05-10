//
//  ValidationResult.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/05/10.
//

import UIKit

// データの状態(テキスト と 文字色)
enum ValidationResult {
    case ok(message: String)
    case empty(message: String)
    case validating
    case failed(message: String)

    var description: String {
        switch self {
        case let .ok(message) : return message
        case let .empty(message) : return message
        case .validating : return ""
        case let .failed(message) : return message
        }
    }

    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
    
    var testColor: UIColor {
        switch self {
        case .ok:
            return UIColor.green
        case .empty:
            return UIColor.black
        case .validating:
            return UIColor.black
        case .failed:
            return UIColor.red
        }
    }
}
