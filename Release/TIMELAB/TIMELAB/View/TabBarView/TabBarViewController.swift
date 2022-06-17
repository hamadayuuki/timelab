//
//  TabBarViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/05/02.
//

import UIKit

class TabBarViewController: UITabBarController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setupLayoutNavigationAndTab()
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
        let qrScanView = TransitionToQrCodeScannerViewController(viewType: .home)
        let qrScanViewIcon = UIImage(named: "QrScanViewIcon")?.reSizeImage(reSize: CGSize(width: 23,height: 23))
        qrScanView.tabBarItem = UITabBarItem(title: "入退室する", image: qrScanViewIcon, selectedImage: qrScanViewIcon)
        let qrScanNavigationView = UINavigationController(rootViewController: qrScanView)
        
        // ランキング画面
        let rankingView = RankingViewController()
        let rankingViewIcon = UIImage(named: "RankingViewIcon")?.reSizeImage(reSize: CGSize(width: 23,height: 23))
        rankingView.tabBarItem = UITabBarItem(title: "ランキング", image: rankingViewIcon, selectedImage: rankingViewIcon)
        let rankingNavigationView = UINavigationController(rootViewController: rankingView)
        
        // メンバーの滞在状態確認画面
        let confirmOtherMemberStayStatusView = ConfirmOtherMemberStayStatusViewController()
        let confirmOtherMemberStayStatusViewIcon = UIImage(named: "CheckMemberViewIcon")?.reSizeImage(reSize: CGSize(width: 23,height: 23))
        confirmOtherMemberStayStatusView.tabBarItem = UITabBarItem(title: "他メンバー", image: confirmOtherMemberStayStatusViewIcon, selectedImage: confirmOtherMemberStayStatusViewIcon)
        let confirmOtherMemberStayStatusNavigationView = UINavigationController(rootViewController: confirmOtherMemberStayStatusView)
        
        setViewControllers([calendarNavigationView, qrScanNavigationView, rankingNavigationView, confirmOtherMemberStayStatusNavigationView], animated: true)
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
}



