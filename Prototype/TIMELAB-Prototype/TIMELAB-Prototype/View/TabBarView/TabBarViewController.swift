//
//  TabBarViewController.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/22.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initTabBar()
    }

    func initTabBar() {
        // 遷移先の画面登録
        let qrScanView = QrScanViewController()
        qrScanView.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        let qrScanNavigationView = NavigationController(rootViewController: qrScanView)
        
        let calendarView = CalendarViewController()
        calendarView.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        let calendarNavigationView = NavigationController(rootViewController: calendarView)
        
        let rankingView = RankingViewController()
        rankingView.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 2)
        let rankingNavigationView = NavigationController(rootViewController: rankingView)

        // Tabs
        setViewControllers([qrScanNavigationView, calendarNavigationView, rankingNavigationView], animated: true)
    }
    
    // 実行中のアプリがiPhoneのメモリを使いすぎた際に呼び出される
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

