//
//  Setting.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/12/09.
//

import UIKit

enum Setting {
    case myProfile
    case form
    case termOfUse
    case privacyPolicy
    
    var url: String {
        let baseURL = "https://"
        switch self{
        case .myProfile: return ""
        case .form: return baseURL + "forms.gle/emSdzssyEZeUr1bh7"
        case .termOfUse: return baseURL + "google.com"
        case .privacyPolicy: return baseURL + "sites.google.com/view/timelabprivacypolicy/%E3%83%9B%E3%83%BC%E3%83%A0"
        }
    }
    
    var title: String {
        switch self{
        case .myProfile: return "プロフィール"
        case .form: return "お問合せ"
        case .termOfUse: return "利用規約"
        case .privacyPolicy: return "プライバシーポリシー"
        }
    }
}
