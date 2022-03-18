//
//  RegisterValidationModel.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/18.
//

import RxSwift
import RxCocoa

// データの状態を確認して、返す
class RegisterValidationModel {
    
    //                                   ↓ データの状態(enum)
    func ValidateEmail(email: String) -> ValidationResult {
        if (email.count == 0) { return .empty(message: "") }
        return .ok(message: "")
    }
    
    func ValidatePassword(password: String) -> ValidationResult {
        if (password.count == 0) { return .empty(message: "") }
        if (password.count < 8) { return .failed(message: "8文字以上にしてください") }
        return .ok(message: "OK")
    }
    
    func ValidatePasswordConfirm(password: String, passwordConfirm: String) -> ValidationResult {
        if (passwordConfirm.count == 0) { return .empty(message: "") }
        if (passwordConfirm.count < 8) { return .failed(message: "") }
        if (password == passwordConfirm) { return .ok(message: "OK") }
        return .failed(message: "")
    }
    
    func ValidateCanRegister(emailIsValid: Bool, passwordIsValid: Bool, passwordConfirmIsValid: Bool) -> Bool {
        print("emailIsValid: ", emailIsValid)
        print("passwordIsValid: ", passwordIsValid)
        print("passwordConfirmIsValid: ", passwordConfirmIsValid)
        if (emailIsValid && passwordIsValid && passwordConfirmIsValid) {
            return true
        }
        return false
    }
}
