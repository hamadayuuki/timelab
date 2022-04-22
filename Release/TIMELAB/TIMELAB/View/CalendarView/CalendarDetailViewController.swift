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
    var date: String!
    
    init(date: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.date = date
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateLabel: UILabel = {
            let label = UILabel()
            label.text = self.date
            return label
        }()
        
        view.addSubview(uiView)
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(view.bounds.width * 0.5)
            make.centerY.equalTo(view.bounds.height * 0.5)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.uiView.frame = CGRect(x: 0, y: view.bounds.height * 0.2, width: view.bounds.width, height: view.bounds.height * 0.8)
        self.uiView.backgroundColor = .yellow
        self.uiView.layer.cornerRadius = 5
    }
    
}

