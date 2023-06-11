//
//  SceneDelegate.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/06.
//

import UIKit
import Firebase
import AppTrackingTransparency  // ATT
import AdSupport  // ATT

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UISceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        // アプリ起動時に表示する画面の描画
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // 画面遷移
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        window.makeKeyAndVisible()
        
        // アプリのタスクが終了している状態から Firebase Dynamic Links を用いてアプリを起動した時
        if let userActivity = connectionOptions.userActivities.first(where: { $0.webpageURL != nil }) {
            guard let url = userActivity.webpageURL else { return }
            if let user = Auth.auth().currentUser { return }
            
            DynamicLinks.dynamicLinks().handleUniversalLink(url) { [weak self] dynamicLink, err in
                if err != nil { return } else {
                    guard let url = dynamicLink?.url else { return }
                    guard (dynamicLink?.matchType == .unique || dynamicLink?.matchType == .default) else { return }
                    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) ,let queryItems = components.queryItems else { return }

                    // ユーザー登録に関する Dynamic Links の場合
                    if url.absoluteString.components(separatedBy: "/usersignup").count >= 2 {
                        if let email = UserDefaults.standard.string(forKey: "email"), let password = UserDefaults.standard.string(forKey: "password") {   // ユーザー登録時(メール認証送信直前) UserDefaultを用いる
//                            self?.window?.rootViewController = LogInViewController()   // TODO: 他の画面が先に表示される。 クロージャの中で画面遷移を行っているから他画面と表示のタイミングがずれる。
                        }
                    }

                }
            }
        }
        
        if let user = Auth.auth().currentUser  {
            window.rootViewController = TabBarViewController()   // 起動時の画面遷移
        } else {
            // Push通知, 遷移先でPresent遷移を可能にするため
            let chooseRegisterOrLogInViewController = ChooseRegisterOrLogInViewController()   // 起動時の画面遷移
            let navigationController = UINavigationController(rootViewController: chooseRegisterOrLogInViewController)
            window.rootViewController = navigationController
        }
        
        // Present遷移
//       let window = UIWindow(windowScene: windowScene)
//       self.window = window
//       window.rootViewController = CalendarDetailViewController()
//       window.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard let url = userActivity.webpageURL else { return }
        if let user = Auth.auth().currentUser { return }
        
        // アプリのタスクが終了"していない"状態から Firebase Dynamic Links を用いてアプリを起動した時
        DynamicLinks.dynamicLinks().handleUniversalLink(url) { [weak self] dynamicLink, err in
            if err != nil { return } else {
                guard let url = dynamicLink?.url else { return }
                guard (dynamicLink?.matchType == .unique || dynamicLink?.matchType == .default) else { return }
                guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) ,let queryItems = components.queryItems else { return }

                if url.absoluteString.components(separatedBy: "/usersignup").count >= 2 {
                    if let email = UserDefaults.standard.string(forKey: "email"), let password = UserDefaults.standard.string(forKey: "password") {
//                        self?.window?.rootViewController = LogInViewController()
                    }
                }
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        requestAppTrackingTransparencyAuthorization()
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


}

extension SceneDelegate {
    // ATT 対応
    private func requestAppTrackingTransparencyAuthorization() {
        if #available(iOS 14.5, *) {
            // .notDeterminedの場合にだけリクエスト呼び出しを行う
            guard ATTrackingManager.trackingAuthorizationStatus == .notDetermined else { return }

            // タイミングを遅らせる為に処理を遅延させる
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                    // リクエスト後の状態に応じた処理を行う
                })
            }
        }
    }
}

