//
//  NavigationController.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/22.
//

import UIKit
 
// ナビゲーションバー に関する設定
class NavigationController: UINavigationController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景色
        navigationBar.barTintColor = UIColor.black
        
        // アイテムの色
        navigationBar.tintColor = UIColor.white
        
        // テキスト
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}
