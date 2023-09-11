//
//  FirebaseDynamicLinks.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2023/06/11.
//

import Firebase

class FirebaseDynamicLinks {
    
    func sendSingInLink(email: String, password: String) async throws {
        let actionUrl = "https://timelab.page.link/usersignup"
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: actionUrl)
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        
        // メール送信
        do {
            try await Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings)
            UserDefaults.standard.set(email, forKey: "email")
            UserDefaults.standard.set(password, forKey: "password")
            print("success sendSignInLink")
        } catch {
            // エラー処理
        }
    }
    
    
}
