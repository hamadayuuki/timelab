//
//  ValidationModel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/05/10.
//

import RxSwift
import RxCocoa

// データの状態を確認して、返す
class ValidationModel {
    
    // MARK: - RegisterUser
    //                                 ↓ データの状態(enum)
    func ValidateEmail(email: String) -> ValidationResult {
        if (email.count == 0) { return .empty(message: " ※") }
        return .ok(message: "OK")
    }
    
    func ValidatePassword(password: String) -> ValidationResult {
        if (password.count == 0) { return .empty(message: " ※") }
        if (password.count < 8) { return .failed(message: "NG") }
        return .ok(message: "OK")
    }
    
    func ValidatePasswordConfirm(password: String, passwordConfirm: String) -> ValidationResult {
        if (passwordConfirm.count == 0) { return .empty(message: "※ ") }
        if (passwordConfirm.count < 8) { return .failed(message: "  ") }
        if (password == passwordConfirm) { return .ok(message: "OK") }
        return .failed(message: " ")
    }
    
    func ValidateCanRegister(emailIsValid: Bool, passwordIsValid: Bool, passwordConfirmIsValid: Bool) -> Bool {
        if (emailIsValid && passwordIsValid && passwordConfirmIsValid) {
            return true
        }
        return false
    }
    
    // MARK: - LogIn
    func validateLogInEmail(email: String) -> Bool {
        if (email.contains("@")) { return true }
        return false
    }
    
    func validateLogInPassword(password: String) -> Bool {
        if (password.count >= 8) { return true }
        return false
    }
    
    func validateCanLogIn(email: Bool, password: Bool) -> Bool {
        if (email && password) { return true }
        return false
    }
    
    // MARK: - RegisterRoom
    func ValidateUniversity(university: String) -> ValidationResult {
        if (university.count == 0) { return .empty(message: "") }
        return .ok(message: "OK")
    }
    
    func ValidateDepartment(department: String) -> ValidationResult {
        if (department.count == 0) { return .empty(message: "") }
        return .ok(message: "OK")
    }
    
    func ValidateCourse(course: String) -> ValidationResult {
        if (course.count == 0) { return .empty(message: "") }
        return .ok(message: "OK")
    }
    
    func ValidateLab(lab: String) -> ValidationResult {
        if (lab.count == 0) { return .empty(message: "") }
        return .ok(message: "OK")
    }
    
    func ValidateCanRegister(universityIsValid: Bool, departmentIsValid: Bool, courseIsValid: Bool, roomIsValid: Bool) -> Bool {
        if (universityIsValid && departmentIsValid && courseIsValid && roomIsValid) {
            return true
        }
        return false
    }
}

