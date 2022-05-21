//
//  LogInResult.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/05/22.
//

import UIKit

struct LogInResult {
    var errorMessage: String
    var isLogIn: Bool
    
    init(errorMessage: String, isLogIn: Bool) {
        self.errorMessage = errorMessage
        self.isLogIn = isLogIn
    }
}
