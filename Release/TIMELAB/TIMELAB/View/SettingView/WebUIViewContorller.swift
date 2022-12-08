//
//  WebUIViewContorller.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/12/09.
//

import Foundation
import UIKit
import WebKit

// URL に応じてWebページをUIViewControllerとして返す
// FloatingPanel でWebページを表示するために用意
class WebUIViewContorller: UIViewController {
    var url: String!
    var uiScrollView = UIScrollView()
    
    init(url: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.url = url
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupLayout()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Color.navyBlue.UIColor]
        navigationController?.navigationBar.tintColor = Color.navyBlue.UIColor
        navigationItem.title = self.url
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(tapDismissButton(_:)))
    }
    
    func setupLayout() {
        let webView = WKWebView(frame: view.frame)
        let request = URLRequest(url: URL(string: self.url)!)
        view.addSubview(webView)
        webView.load(request)
        
        view.addSubview(webView)
    }
    
    @objc func tapDismissButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

}
