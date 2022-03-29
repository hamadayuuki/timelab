//
//  SceneDelegate.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/10.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // MARK: LifeCycle
    // ナビゲーションバー/タブバー の設定 や 初期表示の画面指定
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        setupLayoutNavigationAndTab()
        
        // アプリ起動時に表示する画面の描画
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        window.rootViewController = QrScanViewController()
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    // MARK: Function
    func setupLayoutNavigationAndTab() {
        // iOS13以上 の ナビゲーションバー/タブバー の背景色を指定, 背景色のみここで指定する必要あり
        if #available(iOS 13.0, *) {
            // ナビゲーションバー (画面上)
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.backgroundColor = .white
            navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.gray]   // タイトルの色
            UINavigationBar.appearance().tintColor = .red   // アイテムの色
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            
            // タブバー(画面下)
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.backgroundColor = .white   // 背景色
            UITabBar.appearance().tintColor = UIColor.orange   // 選択時
            UITabBar.appearance().unselectedItemTintColor = UIColor.gray   // 非選択時
            UITabBar.appearance().isTranslucent = false
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        } else {
            // ナビゲーションバー
            UINavigationBar.appearance().barTintColor = .white
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.gray]
            UINavigationBar.appearance().tintColor = .red
            
            // タブバー
            UITabBar.appearance().barTintColor = .red
            UITabBar.appearance().tintColor = UIColor.orange
            UITabBar.appearance().unselectedItemTintColor = UIColor.gray
            UITabBar.appearance().isTranslucent = false

        }
    }

}

