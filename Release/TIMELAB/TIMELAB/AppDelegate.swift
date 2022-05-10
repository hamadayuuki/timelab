//
//  AppDelegate.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/06.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true   // TextField の高さを自動変更可能にする
        
        // 実行環境によって Firebase の切り替えを行う
        var resource = "GoogleService-Info-Develop"
        #if Develop
            resource = "GoogleService-Info-Develop"
        #elseif Debug
            resource = "GoogleService-Info-Debug"
        #else
            resource = "GoogleService-Info-Release"
        #endif
        
        if let filePath = Bundle.main.path(forResource: resource, ofType: "plist") {
            guard let options = FirebaseOptions(contentsOfFile: filePath) else {
                assert(false, "Could not load config file.")
            }
            FirebaseApp.configure(options: options)
        } else {
            FirebaseApp.configure()
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }


}

