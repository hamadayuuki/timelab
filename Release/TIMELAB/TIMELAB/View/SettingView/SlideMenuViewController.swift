//
//  SlideMenuViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/11/20.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import PKHUD

protocol SideMenuViewControllerDelegate: class{
    func parentViewControllerForSideMenuViewController(_ sidemenuViewController: SlideMenuViewController) -> UIViewController
    func shouldPresentForSideMenuViewController(_ sidemenuViewController: SlideMenuViewController) -> Bool
    func sideMenuViewControllerDidRequestShowing(_ sidemenuViewController: SlideMenuViewController, contentAvailability: Bool, animated: Bool)
    func sideMenuViewControllerDidRequestHiding(_ sidemenuViewController: SlideMenuViewController, animated: Bool)
    func sideMenuViewController(_ sidemenuViewController: SlideMenuViewController, didSelectItemAt indexPath: IndexPath)
}

class SlideMenuViewController: ViewController, UIGestureRecognizerDelegate {
    let disposeBag = DisposeBag()
    var slideMenuViewModel: SlideMenuViewModel!
    var delegate: SideMenuViewControllerDelegate?
    var user: [String: Any] = ["": ""]
    var room: [String: Any] = ["": ""]
    
    // MARK: - UI Parts
    let contentView = UIView(frame: .zero)
    var contentMaxWidth: CGFloat { return view.bounds.width * 0.8 }
    var contentRatio: CGFloat {   // 1.0: 表示, 0.0: 非表示
        get { return contentView.frame.maxX / contentMaxWidth }
        set {
            let ratio = min(max(newValue, 0), 1)
            contentView.frame.origin.x = contentMaxWidth * ratio - contentView.frame.width
            contentView.layer.shadowColor = UIColor.black.cgColor
            contentView.layer.shadowRadius = 3.0
            contentView.layer.shadowOpacity = 0.8
            
            view.backgroundColor = UIColor(white: 0, alpha: 0.3 * ratio)
        }
    }
    // 画面のスライドに関する
    // 訳 pan: 左右に動く
    var screenEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    var panGestureRecognizer: UIPanGestureRecognizer!
    var beganLocation: CGPoint = .zero
    var beganState: Bool = false
    var isShown: Bool { return self.parent != nil }
    
    var userIcon: UserIconButton!
    var userNameLabel: ProfileLabel!
    var profileButton: MenuButton!
    var formButton: MenuButton!
    var termOfUseButton: MenuButton!
    var privacyPolicyButton: MenuButton!
    var logoutButton: MenuButton!
    var unsubscribeButton: MenuButton!
    
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 13.0, *) { presentingViewController?.beginAppearanceTransition(false, animated: animated) }
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBinding()
        setupGesture()
    }
    
    // MARK: - Function
    func setupLayout() {
        
        // 画面の大きさ
        var contentRect = view.bounds
        contentRect.size.width = contentMaxWidth
        contentRect.origin.x = -contentRect.width
        contentView.frame = contentRect
        contentView.backgroundColor = .white
        contentView.autoresizingMask = .flexibleHeight
        view.addSubview(contentView)
        
        userIcon = UserIconButton(imageName: self.user["iconName"] as? String ?? "UserIcon1", imageSize: CGSize(width: 70, height: 70))
        userNameLabel = ProfileLabel(text: self.user["name"] as? String ?? "", size: 20)
        let userHorizontalView = UIStackView(arrangedSubviews: [userIcon, userNameLabel])
        userHorizontalView.axis = .horizontal
        userHorizontalView.spacing = 13
        let underLine = UILabel()   // 線を描画するためだけ
        underLine.underLine(color: Color.navyBlue.UIColor, thickness: 1, frame: CGSize(width: 250, height: 1))
        profileButton = MenuButton(text: "プロフィール", textSize: 15)
        formButton = MenuButton(text: "お問い合せ", textSize: 15)
        termOfUseButton = MenuButton(text: "利用規約", textSize: 15)
        privacyPolicyButton = MenuButton(text: "プライバシーポリシー", textSize: 15)
        logoutButton = MenuButton(text: "ログアウト", textSize: 15)
        unsubscribeButton = MenuButton(text: "アカウント削除", textSize: 15, backgroundColor: Color.orange.UIColor)
        let menuVerticallView = UIStackView(arrangedSubviews: [profileButton, formButton, termOfUseButton, privacyPolicyButton, logoutButton, unsubscribeButton])
        menuVerticallView.axis = .vertical
        menuVerticallView.distribution = .fillEqually   // 全ての要素の大きさを均等に
        menuVerticallView.spacing = 15
        
        contentView.addSubview(userHorizontalView)
        userHorizontalView.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(contentView.bounds.width * 0.4)   // アイコンの位置を左にしたい
            make.top.equalTo(68)
        }
        
        contentView.addSubview(underLine)
        underLine.snp.makeConstraints { make -> Void in
            make.left.equalTo(userHorizontalView.snp.left).offset(-20)
            make.top.equalTo(userHorizontalView.snp.bottom).offset(15)
        }
        
        contentView.addSubview(menuVerticallView)
        menuVerticallView.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(contentView.bounds.width * 0.5)
            make.top.equalTo(userHorizontalView.snp.bottom).offset(50)
        }
    }
    
    func setupBinding() {
        self.slideMenuViewModel = SlideMenuViewModel()
        
        self.profileButton.rx.tap
            .subscribe { _ in
                print("プロフィールボタン")
                let myProfileViewController = UINavigationController(rootViewController: MyProfileViewController(setting: .myProfile, user: self.user, room: self.room))
                self.present(myProfileViewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        self.formButton.rx.tap
            .subscribe { _ in
                let webUIViewController = WebUIViewContorller(setting: .form)
                let webNavigationController = UINavigationController(rootViewController: webUIViewController)   // 遷移先画面で NavigationBar を表示させるため
                self.present(webNavigationController, animated: true)
            }
            .disposed(by: disposeBag)
        
        self.termOfUseButton.rx.tap
            .subscribe { _ in
                let webUIViewController = WebUIViewContorller(setting: .termOfUse)
                let webNavigationController = UINavigationController(rootViewController: webUIViewController)
                self.present(webNavigationController, animated: true)
            }
            .disposed(by: disposeBag)
        
        self.privacyPolicyButton.rx.tap
            .subscribe { _ in
                let webUIViewController = WebUIViewContorller(setting: .privacyPolicy)
                let webNavigationController = UINavigationController(rootViewController: webUIViewController)
                self.present(webNavigationController, animated: true)
            }
            .disposed(by: disposeBag)
        
        self.logoutButton.rx.tap
            .subscribe { _ in
                print("ログアウトボタン")
                let alert = UIAlertController(title: "ログアウトしますか？", message: "再度ログインする必要があります", preferredStyle: .alert)
                let signOutAction = UIAlertAction(title: "ログアウト", style: .destructive) { (action) in
                    // TODO: リファクタリング
                    HUD.show(.progress)
                    self.slideMenuViewModel.signOutAction()
                        .drive { isSignOut in
                            print("isSignOut: \(isSignOut)")
                            if isSignOut {
                                HUD.hide()
                                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)   // 画面破棄
                                let chooseRegisterOrLogInViewController = ChooseRegisterOrLogInViewController()
                                let navigationController = UINavigationController(rootViewController: chooseRegisterOrLogInViewController)
                                self.view.window?.rootViewController = navigationController
                            }
                        }
                        .disposed(by: self.disposeBag)
                }
                let cancellAction = UIAlertAction(title: "キャンセル", style: .default) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(signOutAction)
                alert.addAction(cancellAction)
                self.present(alert, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        self.unsubscribeButton.rx.tap
            .subscribe { _ in
                print("アカウント削除ボタン")
                let alert = UIAlertController(title: "アカウント削除しますか？", message: "復元できません", preferredStyle: .alert)
                let deleteUserAction = UIAlertAction(title: "アカウント削除", style: .destructive) { (action) in
                    // 再度確認
                    let confirmAlert = UIAlertController(title: "本当に良いですか？", message: "", preferredStyle: .actionSheet)
                    let confirmDeleteUserAction = UIAlertAction(title: "イエス", style: .destructive) { (action) in
                        print("イエス")
                        HUD.show(.progress)
                        // TODO: - Drive の入れ子を改善
                        Driver.zip(self.slideMenuViewModel.deleteUserFireStore(uid: self.user["uid"] as! String), self.slideMenuViewModel.deleteUserFireAuth())
                            .drive { (isStore, isAuth) in
                                if(isStore && isAuth) {
                                    self.slideMenuViewModel.signOutAction()
                                        .drive { isSignOut in
                                            HUD.hide()
                                            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)   // 画面破棄
                                            let chooseRegisterOrLogInViewController = ChooseRegisterOrLogInViewController()
                                            let navigationController = UINavigationController(rootViewController: chooseRegisterOrLogInViewController)
                                            self.view.window?.rootViewController = navigationController
                                        }
                                    
                                } else {
                                    print("isStore:\(isStore), isAuth:\(isAuth)")
                                }
                            }
                            .disposed(by: self.disposeBag)
                    }
                    let confirmCancellAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                        self.dismiss(animated: true, completion: nil)
                    }
                    confirmAlert.addAction(confirmDeleteUserAction)
                    confirmAlert.addAction(confirmCancellAction)
                    self.present(confirmAlert, animated: true, completion: nil)
                    // == 再度確認
                }
                let cancellAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(deleteUserAction)
                alert.addAction(cancellAction)
                self.present(alert, animated: true, completion: nil)
                
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Gesture
    func setupGesture() {
        // メニュー画面以外の領域タップでメニュー画面を閉じる
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(sender:)))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func backgroundTapped(sender: UITapGestureRecognizer) {
        hideContentView(animated: true) { (_) in
            self.willMove(toParent: nil)
            self.removeFromParent()
            self.view.removeFromSuperview()
        }
    }
    func hideContentView(animated: Bool, completion: ((Bool) -> Swift.Void)?) {
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.contentRatio = 0
            }, completion: { (finished) in
                completion?(finished)
            })
        } else {
            contentRatio = 0
            completion?(true)
        }
    }
    
    func showContentView(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3) { self.contentRatio = 1.0 }
        } else { contentRatio = 1.0 }
    }
    
    // 指の動きを検知
    func startPanGestureRecognizing() {
        if let parentViewController = self.delegate?.parentViewControllerForSideMenuViewController(self) {
            screenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandled(panGestureRecognizer:)))
            screenEdgePanGestureRecognizer.edges = [.left]
            screenEdgePanGestureRecognizer.delegate = self
            parentViewController.view.addGestureRecognizer(screenEdgePanGestureRecognizer)
            
            panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandled(panGestureRecognizer:)))
            panGestureRecognizer.delegate = self
            parentViewController.view.addGestureRecognizer(panGestureRecognizer)
        }
    }
    
    @objc func panGestureRecognizerHandled(panGestureRecognizer: UIPanGestureRecognizer) {
        guard let shouldPresent = self.delegate?.shouldPresentForSideMenuViewController(self) else {
            return
        }
        
        let translation = panGestureRecognizer.translation(in: view)   // 初期タップ位置からの移動量
        if translation.x > 0 && contentRatio == 1.0 { return }
        
        let location = panGestureRecognizer.location(in: view)   // 現在のタップ位置
        switch panGestureRecognizer.state {
        case .began:
            beganState = isShown
            beganLocation = location
            if translation.x >= 0 && location.x < 100 { self.delegate?.sideMenuViewControllerDidRequestShowing(self, contentAvailability: false, animated: false) }
        case .changed:
            let distance = beganState ? beganLocation.x - location.x : location.x - beganLocation.x
            if distance >= 0 {
                let ratio = distance / (beganState ? beganLocation.x : (view.bounds.width - beganLocation.x))
                let contentRatio = beganState ? 1 - ratio : ratio
                self.contentRatio = contentRatio
            }
            
        case .ended, .cancelled, .failed:
            if contentRatio <= 1.0, contentRatio >= 0 {
                if location.x > beganLocation.x { showContentView(animated: true) }
                else { self.delegate?.sideMenuViewControllerDidRequestHiding(self, animated: true) }
            }
            beganLocation = .zero
            beganState = false
            
        default: break
        }
    }
    
}
