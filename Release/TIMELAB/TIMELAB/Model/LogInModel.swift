//
//  LogInModel.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/05/21.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth

class LogInModel {
    init() { }
    
    func logIn(email: String, password: String) -> Observable<LogInResult> {
        
        return Observable<LogInResult>.create { observer in
            
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                
                if let error = error {
                    // エラー文の作成
                    var errorMessage = ""
                    switch AuthErrorCode.Code(rawValue: (error as NSError).code) ?? .noSuchProvider {
                        case .networkError: errorMessage = "ネットワークに接続できません"
                        case .userNotFound: errorMessage = "メールアドレス と パスワード に誤りがあります"
                        case .invalidEmail: errorMessage = "メールアドレスに誤りがあります"
                        case .emailAlreadyInUse: errorMessage = "このメールアドレスは既に使われています"
                        case .wrongPassword: errorMessage = "パスワードに誤りがあります"
                        case .userDisabled: errorMessage = "このアカウントは無効です"
                        case .weakPassword: errorMessage = "パスワードが脆弱すぎます"
                        default: errorMessage = "原因不明のエラーが発生しました"
                    }
                    let logInResult = LogInResult(errorMessage: errorMessage, isLogIn: false)
                    observer.onNext(logInResult)
                }
                if let user = authResult?.user {
                    let logInResult = LogInResult(errorMessage: "", isLogIn: true)
                    observer.onNext(logInResult)
                }
                
            }
            return Disposables.create { print("Observable: Dispose") }
            
        }
        
    }
    
}
