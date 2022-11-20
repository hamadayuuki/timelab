//
//  TabBarViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/05/02.
//

import UIKit
import PKHUD
import RxSwift
import RxCocoa

class TabBarViewController: UITabBarController {
    let disposeBag = DisposeBag()
    
    let contentViewController = UINavigationController(rootViewController: UIViewController())
    let slideMenuViewController = SlideMenuViewController()
    var isShownSlideMenu: Bool { return slideMenuViewController.parent == self }
    
    var userName = ""
    var userIconName = "UserIcon1"

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        view.backgroundColor = .white
        HUD.show(.progress)
        setupBinding()   // TODO: setupTabBar()/setupLayoutNavigationAndTab() を呼び出さない
//        setupTabBar()
//        setupLayoutNavigationAndTab()
        
        slideMenuViewController.delegate = self
        slideMenuViewController.startPanGestureRecognizing()
    }
    
    // 実行中のアプリがiPhoneのメモリを使いすぎた際に呼び出される
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Function
    func setupTabBar() {
        // カレンダー画面
        let calendarView = CalendarViewController()
        let calendarViewIcon = UIImage(named: "CalendarViewIcon")?.reSizeImage(reSize: CGSize(width: 23,height: 23))
        calendarView.tabBarItem = UITabBarItem(title: "メモを見る", image: calendarViewIcon, selectedImage: calendarViewIcon)
        let calendarNavigationView = UINavigationController(rootViewController: calendarView)
        
        // QR読み取り画面
        //let qrScanView = QrCodeScannerViewController()
        let qrScanView = TransitionToQrCodeScannerViewController()
        let qrScanViewIcon = UIImage(named: "QrScanViewIcon")?.reSizeImage(reSize: CGSize(width: 23,height: 23))
        qrScanView.tabBarItem = UITabBarItem(title: "入退室する", image: qrScanViewIcon, selectedImage: qrScanViewIcon)
        let qrScanNavigationView = UINavigationController(rootViewController: qrScanView)
        
        // ランキング画面
        let rankingView = RankingViewController()
        let rankingViewIcon = UIImage(named: "RankingViewIcon")?.reSizeImage(reSize: CGSize(width: 23,height: 23))
        rankingView.tabBarItem = UITabBarItem(title: "ランキング", image: rankingViewIcon, selectedImage: rankingViewIcon)
        let rankingNavigationView = UINavigationController(rootViewController: rankingView)
        
        // メンバーの滞在状態確認画面
        let confirmOtherMemberStayStateView = ConfirmOtherMemberStayStateViewController()
        let confirmOtherMemberStayStateViewIcon = UIImage(named: "CheckMemberViewIcon")?.reSizeImage(reSize: CGSize(width: 23,height: 23))
        confirmOtherMemberStayStateView.tabBarItem = UITabBarItem(title: "他メンバー", image: confirmOtherMemberStayStateViewIcon, selectedImage: confirmOtherMemberStayStateViewIcon)
        let confirmOtherMemberStayStateNavigationView = UINavigationController(rootViewController: confirmOtherMemberStayStateView)
        
        setViewControllers([calendarNavigationView, qrScanNavigationView, rankingNavigationView, confirmOtherMemberStayStateNavigationView], animated: true)
    }
    
    func setupLayoutNavigationAndTab() {
        // iOS13以上 の ナビゲーションバー/タブバー の背景色を指定, 背景色はここで指定
        if #available(iOS 13.0, *) {
            // ナビゲーションバー (画面上)
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.backgroundColor = .white
            navigationBarAppearance.titleTextAttributes = [.foregroundColor: Color.navyBlue.UIColor]   // タイトルの色
            navigationBarAppearance.configureWithTransparentBackground()
            UINavigationBar.appearance().tintColor = .red   // アイテムの色
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            
            // タブバー(画面下)
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.backgroundColor = Color.white.UIColor   // 背景色
            UITabBar.appearance().tintColor = Color.navyBlue.UIColor   // 選択時
            UITabBar.appearance().unselectedItemTintColor = Color.navyBlue.UIColor   // 非選択時
            UITabBar.appearance().isTranslucent = false
            UITabBar.appearance().standardAppearance = tabBarAppearance   // 通常時の設定
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance   // スクロール画面の端についた時の設定
        } else {
            // ナビゲーションバー
            UINavigationBar.appearance().barTintColor = Color.white.UIColor
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: Color.navyBlue.UIColor]
            UINavigationBar.appearance().tintColor = Color.white.UIColor
            
            // タブバー
            UITabBar.appearance().barTintColor = Color.navyBlue.UIColor
            UITabBar.appearance().tintColor = Color.orange.UIColor
            UITabBar.appearance().unselectedItemTintColor = Color.navyBlue.UIColor
            UITabBar.appearance().isTranslucent = false
        }
    }
    
    func showSlideMenu(contentAvailability: Bool = true, animated: Bool) {
        if isShownSlideMenu { return }
        
        addChild(slideMenuViewController)
        slideMenuViewController.view.autoresizingMask = .flexibleHeight
        slideMenuViewController.view.frame = contentViewController.view.bounds
        view.insertSubview(slideMenuViewController.view, aboveSubview: contentViewController.view)
        slideMenuViewController.didMove(toParent: self)
        if contentAvailability { slideMenuViewController.showContentView(animated: true) }
    }
    
    func hideSlideMenu(animated: Bool) {
        if !isShownSlideMenu { return }
        
        slideMenuViewController.hideContentView(animated: animated, completion: { (_) in
            self.slideMenuViewController.willMove(toParent: nil)
            self.slideMenuViewController.removeFromParent()
            self.slideMenuViewController.view.removeFromSuperview()
        })
    }
    
    // MARK: - Binding
    func setupBinding() {
        let tabBarViewModel = TabBarViewModel()
        
        tabBarViewModel.user
            .drive { user in
                self.userName = user["name"] as? String ?? ""
                self.userIconName = user["iconName"] as? String ?? "UserIcon1"
                self.setupTabBar()
                self.setupLayoutNavigationAndTab()
                HUD.hide()
            }
            .disposed(by: disposeBag)
    }
    
}

extension TabBarViewController: SideMenuViewControllerDelegate {
    func parentViewControllerForSideMenuViewController(_ sidemenuViewController: SlideMenuViewController) -> UIViewController {
        return self
    }
    
    func shouldPresentForSideMenuViewController(_ sidemenuViewController: SlideMenuViewController) -> Bool {
        return true
    }
    
    func sideMenuViewControllerDidRequestShowing(_ sidemenuViewController: SlideMenuViewController, contentAvailability: Bool, animated: Bool) {
        showSlideMenu(contentAvailability: contentAvailability, animated: animated)
    }
    
    func sideMenuViewControllerDidRequestHiding(_ sidemenuViewController: SlideMenuViewController, animated: Bool) {
        hideSlideMenu(animated: animated)
    }
    
    func sideMenuViewController(_ sidemenuViewController: SlideMenuViewController, didSelectItemAt indexPath: IndexPath) {
        hideSlideMenu(animated: true)
    }
}



