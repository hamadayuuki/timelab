//
//  CalendarDetailViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/18.
//

import UIKit
import SnapKit
import FSCalendar

class CalendarDetailViewController: UIViewController {
    
    var uiView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(uiView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.uiView.frame = CGRect(x: 0, y: view.bounds.height * 0.2, width: view.bounds.width, height: view.bounds.height * 0.8)
        self.uiView.backgroundColor = .yellow
        self.uiView.layer.cornerRadius = 5
    }
    
}

