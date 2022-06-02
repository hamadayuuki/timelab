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
    
    // MARK: - UI Parts
    var introductionUIImageView: RegisterUIImageView!
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
        
        introductionUIImageView = RegisterUIImageView(name: "DiscussionWomanAndMan")
        
        introductionLabel = RegisterRoomLabel(text: "ユーザー情報の入力", size: 25)
        
        univercityLabel = RegisterRoomLabel(text: "大学", size: 15)
        univercityTextField = RegisterRoomTextField(placeholder: "", isSecretButton: false)
        validateUnivercityLabel = RegisterRoomLabel(text: "", size: 13)
        
        departmentLabel = RegisterRoomLabel(text: "学部", size: 15)
        departmentTextField = RegisterRoomTextField(placeholder: "", isSecretButton: false)
        validateDepartmentLabel = RegisterRoomLabel(text: "", size: 13)
        
        courseLabel = RegisterRoomLabel(text: "学科", size: 15)
        courseTextField = RegisterRoomTextField(placeholder: "", isSecretButton: true)
        validateCourseLabel = RegisterRoomLabel(text: "", size: 13)
        
        roomLabel = RegisterRoomLabel(text: "使う部屋の名前", size: 15)
        roomTextField = RegisterRoomTextField(placeholder: "〇〇研究室", isSecretButton: true)
        validateRoomLabel = RegisterRoomLabel(text: "", size: 13)
        
        registerRoomButton = RegisterRoomButton(text: "OK", textSize: 15)
        
        let registerVerticalView = setupRegisterVerticalView()
        
        // MARK: - addSubview/layer
        view.addSubview(registerVerticalView)
        registerVerticalView.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width / 2)
            make.top.equalTo(view.bounds.height * 0.15)
        }
        
        view.addSubview(introductionUIImageView)
        introductionUIImageView.snp.makeConstraints { make -> Void in
            make.bottom.equalTo(registerVerticalView.snp.top).offset(-30)
            make.right.equalTo(view.bounds.height * 0.9)
        }
        
        view.addSubview(registerRoomButton)
        registerRoomButton.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.top.equalTo(registerVerticalView.snp.bottom).offset(55)
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
        let registerVerticalView = UIStackView(arrangedSubviews: [introductionLabel, univercityHorizontalView, departmentHorizontalView, courseHorizontalView, roomHorizontalView])
        registerVerticalView.axis = .vertical
        registerVerticalView.distribution = .fillEqually   // 要素の大きさを均等にする
        registerVerticalView.spacing = 20
        
        return registerVerticalView
    }
    
    private func setupBinding() {
        /*
        // VM とのつながり, input にイベントを送る(テキストの変更やボタンのタップ等), 送るだけ, 登録のようなイメージ
        registerUserViewModel = RegisterUserViewModel(input: (
            name: nameTextField.rx.text.orEmpty.asDriver(),
            email: emailTextField.rx.text.orEmpty.asDriver(),
            password: passwordTextField.rx.text.orEmpty.asDriver(),
            passwordConfirm: passwordConfirmTextField.rx.text.orEmpty.asDriver(),
            signUpTaps: RegisterRoomButton.rx.tap.asSignal()   // ボタンのタップには Single を使用する
        ), signUpAPI: RegisterUserModel())

        // MV からデータ受け取る, データの値を変更
        registerUserViewModel.nameValidation
            .drive(validateNameLabel.rx.validationResult)   // VM で 戻り値を ValidationResult にしているため,受け取りもvalidationResultにする, Rective の extension を実装する必要あり
            .disposed(by: disposeBag)

        registerUserViewModel.emailValidation
            .drive(validateEmailLabel.rx.validationResult)
            .disposed(by: disposeBag)

        registerUserViewModel.passwordValidation
            .drive(validatePasswordLabel.rx.validationResult)
            .disposed(by: disposeBag)

        registerUserViewModel.passwordConfirmValidation
            .drive(validatePasswordConfirmLabel.rx.validationResult)
            .disposed(by: disposeBag)

        // FireAuth への登録
        let canSingUp = registerUserViewModel.canSignUp
            .drive(onNext: { [weak self] canSingUp  in
                self?.RegisterRoomButton.isEnabled = canSingUp
                self?.RegisterRoomButton.backgroundColor = canSingUp ? Color.navyBlue.UIColor : Color.lightGray.UIColor
                print("canSingUp: ", canSingUp)
            })
            .disposed(by: disposeBag)
        
        // これがないと アカウント登録メソッド(M) が呼ばれない
        registerUserViewModel.isSignUp
            .drive { result in
                print("V, FireAuth へユーザー登録 result: ", result)
            }
            .disposed(by: disposeBag)

        registerUserViewModel.isUserToFireStore
            .drive { result in   // この後の .disposed(by: disposedBag) がないと Bool型 として受け取られない
                print("V, FireStore へユーザー登録: ", result)
                if self.isProgressView && result {
                    HUD.hide()
                    // push画面遷移
                    let welcomeViewController = WelcomeViewController()
                    self.navigationController?.pushViewController(welcomeViewController, animated: true)
                }
            }
            .disposed(by: disposeBag)

        registerUserViewModel.signUpResult
            .drive { user in
                if !user.isValid {   // false の場合、ユーザー情報をFireStoreへ登録する処理 は実行されない
                    // ×画面 を描画
                    HUD.flash(.error, delay: 1) { _ in
                        self.nameTextField.text = ""
                        self.validateNameLabel.text = "※ "
                        self.validateNameLabel.textColor = Color.navyBlue.UIColor
                        self.emailTextField.text = ""
                        self.validateEmailLabel.text = "※ "
                        self.validateEmailLabel.textColor = Color.navyBlue.UIColor
                        self.passwordTextField.text = ""
                        self.validatePasswordLabel.text = "※ "
                        self.validatePasswordLabel.textColor = Color.navyBlue.UIColor
                        self.passwordConfirmTextField.text = ""
                        self.validatePasswordConfirmLabel.text = "※ "
                        self.validatePasswordConfirmLabel.textColor = Color.navyBlue.UIColor
                        self.RegisterRoomButton.isSelected = false
                        self.RegisterRoomButton.isEnabled = false
                    }
                }
            }
            .disposed(by: disposeBag)
        */
        
        // 背景をタップしたらキーボードを隠す
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)
        
        registerRoomButton.rx.tap
            .subscribe { _ in
                HUD.show(.progress)   // ローディング表示
                self.isProgressView = true
                self.registerRoomButton.isSelected = !self.registerRoomButton.isSelected
                self.registerRoomButton.backgroundColor = self.registerRoomButton.isSelected ? Color.lightGray.UIColor : Color.navyBlue.UIColor
            }
            .disposed(by: disposeBag)
        
    }
}
