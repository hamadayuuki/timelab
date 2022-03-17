//
//  RegisterLabRoomViewController.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/13.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterLabRoomViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    // UI Parts
    var universityLabel: RegisterLabel!   // 大学
    var universityTextField: RegisterTextField!
    var validateUniversityLabel: RegisterLabel!
    var departmentLabel: RegisterLabel!   // 学部
    var departmentTextField: RegisterTextField!
    var validateDepartmentLabel: RegisterLabel!
    var courseLabel: RegisterLabel!   // 学科
    var courseTextField: RegisterTextField!
    var validateCourseLabel: RegisterLabel!
    var labLabel: RegisterLabel!   // 研究室
    var labTextField: RegisterTextField!
    var validateLabLabel: RegisterLabel!
    var registerButton: RegisterButton!   // 登録ボタン
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBinding()
    }
    
    private func setupLayout() {
        self.view.backgroundColor = .white
        
        let width = view.bounds.width
        let height = view.bounds.height
        
        universityLabel = RegisterLabel(text: "大学名", size: 18)
        universityTextField = RegisterTextField(placeholder: "")
        validateUniversityLabel = RegisterLabel(text: "", size: 10)
        departmentLabel = RegisterLabel(text: "学部", size: 18)
        departmentTextField = RegisterTextField(placeholder: "")
        validateDepartmentLabel = RegisterLabel(text: "", size: 10)
        courseLabel = RegisterLabel(text: "学科/コース", size: 18)
        courseTextField = RegisterTextField(placeholder: "")
        validateCourseLabel = RegisterLabel(text: "", size: 10)
        labLabel = RegisterLabel(text: "研究室/ゼミ", size: 18)
        labTextField = RegisterTextField(placeholder: "")
        validateLabLabel = RegisterLabel(text: "", size: 10)
        
        registerButton = RegisterButton()
        
        let universityVerticalView = UIStackView(arrangedSubviews: [universityLabel, universityTextField, validateUniversityLabel])
        universityVerticalView.axis = .vertical
        universityVerticalView.spacing = 5
        let departmentVerticalView = UIStackView(arrangedSubviews: [departmentLabel, departmentTextField, validateDepartmentLabel])
        departmentVerticalView.axis = .vertical
        departmentVerticalView.spacing = 5
        let courseVerticalView = UIStackView(arrangedSubviews: [courseLabel, courseTextField, validateCourseLabel])
        courseVerticalView.axis = .vertical
        courseVerticalView.spacing = 5
        let labVerticalView = UIStackView(arrangedSubviews: [labLabel, labTextField, validateLabLabel])
        labVerticalView.axis = .vertical
        labVerticalView.spacing = 5
        
        let registerVerticalView = UIStackView(arrangedSubviews: [universityVerticalView, departmentVerticalView, courseVerticalView, labVerticalView])
        registerVerticalView.axis = .vertical
        registerVerticalView.distribution = .fillEqually   // 要素の大きさを均等にする
        registerVerticalView.spacing = 20
        
        view.addSubview(registerVerticalView)
        registerVerticalView.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width / 2)
            make.top.equalTo(view.bounds.height * 0.2)
        }
        
        view.addSubview(registerButton)
        registerButton.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width / 2)
            make.top.equalTo(registerVerticalView.snp.bottom).offset(50)
            make.width.equalTo(100)
            make.height.equalTo(70)
        }
        
        // 背景をタップしたらキーボードを隠す
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)
    }
    
    private func setupBinding() {
        registerButton.rx.tap
            .subscribe { [weak self] _ in
                // FireStore への登録
                print("登録ボタンが押されました")
            }
            .disposed(by: disposeBag)
    }
}
