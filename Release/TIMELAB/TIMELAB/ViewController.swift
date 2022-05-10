//
//  ViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/06.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        
        // 実行環境分け の確認
        #if Develop
            print("🐵")
        #elseif Debug
            print("🐥")
        #else
            print("🐻")
        #endif
    }


}

