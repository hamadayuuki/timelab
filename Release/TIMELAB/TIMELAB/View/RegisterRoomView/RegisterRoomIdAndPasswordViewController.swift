//
//  RegisterRoomIdAndPasswordViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/06/04.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import PKHUD

class RegisterRoomIdAndPasswordViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    //var registerUserViewModel: RegisterUserViewModel!
    var isProgressView  = false
    
    // MARK: - UI Parts
    var introductionUIImageView: RegisterRoomUIImageView!
    var introductionLabel: RegisterRoomLabel!
    
    var roomIdLabel: RegisterRoomLabel!
    var roomIdTextField: RegisterRoomTextField!
    
    var roomPasswordLabel: RegisterRoomLabel!
    var roomPasswordTextField: RegisterRoomTextField!
    
    var registerRoomButton: RegisterRoomButton!
    
    var explanationLabel: RegisterRoomLabel!
    
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
        
        introductionUIImageView = RegisterRoomUIImageView(name: "ChatRobot", size: CGSize(width: 263, height: 197))
        introductionLabel = RegisterRoomLabel(text: "ID の登録", size: 25)
        
        roomIdLabel = RegisterRoomLabel(text: "ID", size: 15)
        roomIdTextField = RegisterRoomTextField(placeholder: "", isSecretButton: false)
        
        roomPasswordLabel = RegisterRoomLabel(text: "パスワード", size: 15)
        roomPasswordTextField = RegisterRoomTextField(placeholder: "", isSecretButton: false)
        
        registerRoomButton = RegisterRoomButton(text: "OK", textSize: 15)
        
        explanationLabel = RegisterRoomLabel(text: "QRコードじゃなくても\nIDとパスワードで入退室できます！", size: 12)
        
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
        
        view.addSubview(registerRoomButton)
        registerRoomButton.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.top.equalTo(registerVerticalView.snp.bottom).offset(40)
        }
        
        view.addSubview(introductionUIImageView)
        introductionUIImageView.snp.makeConstraints { make -> Void in
            make.top.equalTo(registerRoomButton.snp.bottom).offset(55)
            make.left.equalTo(137)
        }
        
        view.addSubview(explanationLabel)
        explanationLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(introductionUIImageView.snp.top).offset(120)
            make.centerX.equalTo(introductionUIImageView.snp.left)
        }
        
    }
    
    func setupRegisterVerticalView() -> UIStackView {
        // ID
        let roomIdVerticalView = UIStackView(arrangedSubviews: [roomIdLabel, roomIdTextField])
        roomIdVerticalView.axis = .vertical
        roomIdVerticalView.spacing = 5
        
        // Password
        let roomPasswordVerticalView = UIStackView(arrangedSubviews: [roomPasswordLabel, roomPasswordTextField])
        roomPasswordVerticalView.axis = .vertical
        roomPasswordVerticalView.spacing = 5
        
        // 全体
        let registerVerticalView = UIStackView(arrangedSubviews: [roomIdVerticalView, roomPasswordVerticalView])
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

