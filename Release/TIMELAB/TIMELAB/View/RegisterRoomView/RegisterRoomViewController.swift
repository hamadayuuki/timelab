//
//  RegisterRoomViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/06/02.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import PKHUD

class RegisterRoomViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    //var registerUserViewModel: RegisterUserViewModel!
    var isProgressView  = false
    var isRegisterRoom = false
    
    // MARK: - UI Parts
    var introductionUIImageView: RegisterRoomUIImageView!
    var introductionLabel: RegisterRoomLabel!
    
    var univercityLabel: RegisterRoomLabel!
    var univercityTextField: RegisterRoomTextField!
    var validateUnivercityLabel: RegisterRoomLabel!
    
    var departmentLabel: RegisterRoomLabel!
    var departmentTextField: RegisterRoomTextField!
    var validateDepartmentLabel: RegisterRoomLabel!
    
    var courseLabel: RegisterRoomLabel!
    var courseTextField: RegisterRoomTextField!
    var validateCourseLabel: RegisterRoomLabel!
    
    var roomLabel: RegisterRoomLabel!
    var roomTextField: RegisterRoomTextField!
    var validateRoomLabel: RegisterRoomLabel!
    
    var registerRoomButton: RegisterRoomButton!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBinding()
    }
    
    // MARK: - Function
    private func setupLayout() {
        self.view.backgroundColor = .white
        
        let width = view.bounds.width
        let height = view.bounds.height
        
        introductionUIImageView = RegisterRoomUIImageView(name: "DiscussionWomanAndMan", size: CGSize(width: 174, height: 131))
        introductionLabel = RegisterRoomLabel(text: "部屋情報の入力",textAlignment: .left, size: 25)
        
        univercityLabel = RegisterRoomLabel(text: "大学", textAlignment: .left, size: 15)
        univercityTextField = RegisterRoomTextField(placeholder: "", isSecretButton: false)
        validateUnivercityLabel = RegisterRoomLabel(text: "", size: 13)
        
        departmentLabel = RegisterRoomLabel(text: "学部", textAlignment: .left, size: 15)
        departmentTextField = RegisterRoomTextField(placeholder: "", isSecretButton: false)
        validateDepartmentLabel = RegisterRoomLabel(text: "", size: 13)
        
        courseLabel = RegisterRoomLabel(text: "学科", textAlignment: .left, size: 15)
        courseTextField = RegisterRoomTextField(placeholder: "", isSecretButton: true)
        validateCourseLabel = RegisterRoomLabel(text: "", size: 13)
        
        roomLabel = RegisterRoomLabel(text: "使う部屋の名前", textAlignment: .left, size: 15)
        roomTextField = RegisterRoomTextField(placeholder: "〇〇研究室", isSecretButton: true)
        validateRoomLabel = RegisterRoomLabel(text: "", textAlignment: .left, size: 13)
        
        registerRoomButton = RegisterRoomButton(text: "OK", textSize: 15)
        
        let registerVerticalView = setupRegisterVerticalView()
        
        // MARK: - addSubview/layer
        view.addSubview(registerVerticalView)
        registerVerticalView.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width / 2)
            make.top.equalTo(view.bounds.height * 0.3)
        }
        
        view.addSubview(introductionLabel)
        introductionLabel.snp.makeConstraints { make -> Void in
            make.bottom.equalTo(registerVerticalView.snp.top).offset(-20)
            make.left.equalTo(registerVerticalView.snp.left)
        }
        
        view.addSubview(introductionUIImageView)
        introductionUIImageView.snp.makeConstraints { make -> Void in
            make.bottom.equalTo(introductionLabel.snp.top).offset(-10)
            make.left.equalTo(184)
        }

        registerRoomButton.backgroundColor = Color.lightGray.UIColor
        view.addSubview(registerRoomButton)
        registerRoomButton.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.top.equalTo(registerVerticalView.snp.bottom).offset(40)
        }
        
    }
    
    func setupRegisterVerticalView() -> UIStackView {
        // 大学
        let univercityVerticalView = UIStackView(arrangedSubviews: [univercityLabel, univercityTextField])
        univercityVerticalView.axis = .vertical
        univercityVerticalView.spacing = 5
        let univercityHorizontalView = UIStackView(arrangedSubviews: [univercityVerticalView, validateUnivercityLabel])
        univercityHorizontalView.axis = .horizontal
        univercityHorizontalView.spacing = 5
        
        // 学部
        let departmentVerticalView = UIStackView(arrangedSubviews: [departmentLabel, departmentTextField])
        departmentVerticalView.axis = .vertical
        departmentVerticalView.spacing = 5
        let departmentHorizontalView = UIStackView(arrangedSubviews: [departmentVerticalView, validateUnivercityLabel])
        departmentHorizontalView.axis = .horizontal
        departmentHorizontalView.spacing = 5
        
        // 学科
        let courseVerticalView = UIStackView(arrangedSubviews: [courseLabel, courseTextField])
        courseVerticalView.axis = .vertical
        courseVerticalView.spacing = 5
        let courseHorizontalView = UIStackView(arrangedSubviews: [courseVerticalView, validateCourseLabel])
        courseHorizontalView.axis = .horizontal
        courseHorizontalView.spacing = 5
        
        // 部屋名
        let roomVerticalView = UIStackView(arrangedSubviews: [roomLabel, roomTextField])
        roomVerticalView.axis = .vertical
        roomVerticalView.spacing = 5
        let roomHorizontalView = UIStackView(arrangedSubviews: [roomVerticalView, validateRoomLabel])
        roomHorizontalView.axis = .horizontal
        roomHorizontalView.spacing = 5
        
        // 全体
        let registerVerticalView = UIStackView(arrangedSubviews: [univercityHorizontalView, departmentHorizontalView, courseHorizontalView, roomHorizontalView])
        registerVerticalView.axis = .vertical
        registerVerticalView.distribution = .fillEqually   // 要素の大きさを均等にする
        registerVerticalView.spacing = 20
        
        return registerVerticalView
    }
    
    private func setupBinding() {
        let registerRoomViewModel: RegisterRoomViewModel!
        
        registerRoomViewModel = RegisterRoomViewModel(input: (
            university: univercityTextField.rx.text.orEmpty.asDriver(),
            department: departmentTextField.rx.text.orEmpty.asDriver(),
            course: courseTextField.rx.text.orEmpty.asDriver(),
            room: roomTextField.rx.text.orEmpty.asDriver(),
            registerButton: registerRoomButton.rx.tap.asSignal()
        ))
        
        // MV からデータ受け取る, データの値を変更
        registerRoomViewModel.universityValidation
            .drive(validateUnivercityLabel.rx.validationResult)
            .disposed(by: disposeBag)
        
        registerRoomViewModel.departmentValidation
            .drive(validateDepartmentLabel.rx.validationResult)
            .disposed(by: disposeBag)
        
        registerRoomViewModel.courseValidation
            .drive(validateCourseLabel.rx.validationResult)
            .disposed(by: disposeBag)
        
        registerRoomViewModel.roomValidation
            .drive(validateRoomLabel.rx.validationResult)
            .disposed(by: disposeBag)

        Observable.combineLatest(
            registerRoomViewModel.universityValidation.asObservable(),
            registerRoomViewModel.departmentValidation.asObservable(),
            registerRoomViewModel.courseValidation.asObservable(),
            registerRoomViewModel.roomValidation.asObservable()
        )
        .subscribe { [weak self] (university, department, course, room) in
            guard let self else { return }

            self.isRegisterRoom = university.isValid && department.isValid && course.isValid && room.isValid
            self.registerRoomButton.backgroundColor = self.isRegisterRoom ? Color.navyBlue.UIColor : Color.lightGray.UIColor
        }
        .disposed(by: disposeBag)

        // ! ローディング画面を閉じるプログラムより 先(上) に書く必要がある, 後(下) に書くと実行が後回しになる
        registerRoomButton.rx.tap
            .subscribe { [weak self] _ in
                guard let self else { return }

                if self.isRegisterRoom {
                    print("登録ボタンをタップしました")
                    print("rx.tap selfisProgressView: ", self.isProgressView)
                    HUD.show(.progress)
                    self.isProgressView = true
                }
            }
            .disposed(by: disposeBag)
        
        // これがないと アカウント登録メソッド(M) が呼ばれない
        registerRoomViewModel.isSignUp
            .drive { result in
                print("result: ", result)
                print("self.isProgressView: ", self.isProgressView)
            }
            .disposed(by: disposeBag)
        
        registerRoomViewModel.qrCodeData
            .drive { qrCodeData in
                if qrCodeData != Data() {
                    HUD.hide()
                    
                    // push画面遷移
                    let saveRoomQrCodeViewController = SaveRoomQrCodeViewController(qrCodeData: qrCodeData)
                    saveRoomQrCodeViewController.hidesBottomBarWhenPushed = true   // 遷移後画面でタブバーを隠す
                    self.navigationController?.pushViewController(saveRoomQrCodeViewController, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        // 背景をタップしたらキーボードを隠す
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)
        
    }
}
