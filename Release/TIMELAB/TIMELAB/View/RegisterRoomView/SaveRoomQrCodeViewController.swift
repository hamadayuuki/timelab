//
//  SaveRoomQrCodeViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/06/07.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import PKHUD

class SaveRoomQrCodeViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    //var registerUserViewModel: RegisterUserViewModel!
    var isProgressView  = false
    
    // MARK: - UI Parts
    var introductionLabel: RegisterRoomLabel!
    var explanationNextStepLabel: RegisterRoomLabel!
    
    var roomQrCodeUIImageView: RegisterRoomUIImageView!
    
    var saveRoomQrCodeButton: SaveRoomQrCodeButton!
    
    var introductionUIImageView: RegisterRoomUIImageView!
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
        introductionLabel = RegisterRoomLabel(text: "太田研究室\nQRコード作成完了！", size: 25, color: Color.orange.UIColor)
        //explanationNextStepLabel = RegisterRoomLabel(text: "続きてID登録に入ります", size: 12)
        explanationNextStepLabel = RegisterRoomLabel(text: "", size: 12)
        
        roomQrCodeUIImageView = RegisterRoomUIImageView(name: "RoomQrCode", size: CGSize(width: 200, height: 200), isBorderLine: true)
        
        saveRoomQrCodeButton = SaveRoomQrCodeButton(text: "保存", textSize: 15)
        
        explanationLabel = RegisterRoomLabel(text: "QRコードを保存・印刷して\n使う部屋のドアに貼って\nみんなで使いましょう！", size: 12)
        
        let introductionVertical = UIStackView(arrangedSubviews: [introductionLabel, explanationNextStepLabel])
        introductionVertical.axis = .vertical
        introductionVertical.spacing = 10
        
        // MARK: - addSubview/layer
        view.addSubview(roomQrCodeUIImageView)
        roomQrCodeUIImageView.snp.makeConstraints { make -> Void in
            make.centerY.equalTo(self.view.bounds.height * 0.45)
            make.centerX.equalTo(self.view.bounds.width * 0.5)
        }
        
        view.addSubview(introductionVertical)
        introductionVertical.snp.makeConstraints { make -> Void in
            make.bottom.equalTo(roomQrCodeUIImageView.snp.top).offset(-40)
            make.centerX.equalTo(self.view.bounds.width * 0.5)
        }
        
        view.addSubview(saveRoomQrCodeButton)
        saveRoomQrCodeButton.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.top.equalTo(roomQrCodeUIImageView.snp.bottom).offset(40)
        }
        
        view.addSubview(introductionUIImageView)
        introductionUIImageView.snp.makeConstraints { make -> Void in
            make.top.equalTo(saveRoomQrCodeButton.snp.bottom).offset(10)
            make.left.equalTo(137)
        }
        
        view.addSubview(explanationLabel)
        explanationLabel.snp.makeConstraints { make -> Void in
            make.top.equalTo(introductionUIImageView.snp.top).offset(120)
            make.centerX.equalTo(introductionUIImageView.snp.left)
        }
        
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
        
        saveRoomQrCodeButton.rx.tap
            .subscribe { _ in
                HUD.show(.progress)   // ローディング表示
                self.saveRoomQrCodeButton.isSelected = !self.saveRoomQrCodeButton.isSelected
                self.saveRoomQrCodeButton.backgroundColor = self.saveRoomQrCodeButton.isSelected ? Color.lightGray.UIColor : Color.navyBlue.UIColor
                // 0.5秒後にローディングを消す
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    HUD.hide()
                    self.saveRoomQrCodeButton.isSelected = !self.saveRoomQrCodeButton.isSelected
                    self.saveRoomQrCodeButton.backgroundColor = self.saveRoomQrCodeButton.isSelected ? Color.lightGray.UIColor : Color.navyBlue.UIColor
                    // push画面遷移
                    let tabBarViewController = TabBarViewController()
                    tabBarViewController.hidesBottomBarWhenPushed = true   // 遷移後画面でタブバーを隠す
                    self.navigationController?.pushViewController(tabBarViewController, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
    }
}
