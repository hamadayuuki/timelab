//
//  RegisterLabValidationModel.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/18.
//

import RxSwift
import RxCocoa

// データの状態を確認して、返す
class RegisterLabValidationModel {
    
    //                                   ↓ データの状態(enum)
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
    
    func ValidateCanRegister(universityIsValid: Bool, departmentIsValid: Bool, courseIsValid: Bool, labIsValid: Bool) -> Bool {
        if (universityIsValid && departmentIsValid && courseIsValid && labIsValid) {
            return true
        }
        return false
    }
}
