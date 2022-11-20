//
//  SlideMenuViewController.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/11/20.
//

import Foundation
import UIKit
import SnapKit

protocol SideMenuViewControllerDelegate: class{
    func parentViewControllerForSideMenuViewController(_ sidemenuViewController: SlideMenuViewController) -> UIViewController
    func shouldPresentForSideMenuViewController(_ sidemenuViewController: SlideMenuViewController) -> Bool
    func sideMenuViewControllerDidRequestShowing(_ sidemenuViewController: SlideMenuViewController, contentAvailability: Bool, animated: Bool)
    func sideMenuViewControllerDidRequestHiding(_ sidemenuViewController: SlideMenuViewController, animated: Bool)
    func sideMenuViewController(_ sidemenuViewController: SlideMenuViewController, didSelectItemAt indexPath: IndexPath)
}

class SlideMenuViewController: ViewController, UIGestureRecognizerDelegate {
    var delegate: SideMenuViewControllerDelegate?
    let contentView = UIView(frame: .zero)
    var contentMaxWidth: CGFloat { return view.bounds.width * 0.8 }
    var contentRatio: CGFloat {   // 1.0: 表示, 0.0: 非表示
        get { return contentView.frame.maxX / contentMaxWidth }
        set {
            let ratio = min(max(newValue, 0), 1)
            contentView.frame.origin.x = contentMaxWidth * ratio - contentView.frame.width
            contentView.layer.shadowColor = UIColor.black.cgColor
            contentView.layer.shadowRadius = 3.0
            contentView.layer.shadowOpacity = 0.8
            
            view.backgroundColor = UIColor(white: 0, alpha: 0.3 * ratio)
        }
    }
    // 画面のスライドに関する
    // 訳 pan: 左右に動く
    var screenEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    var panGestureRecognizer: UIPanGestureRecognizer!
    var beganLocation: CGPoint = .zero
    var beganState: Bool = false
    var isShown: Bool { return self.parent != nil }
    
    var profileButton: MenuButton!
    var formButton: MenuButton!
    var termOfUseButton: MenuButton!
    var privacyPolicyButton: MenuButton!
    var logoutButton: MenuButton!
    var unsubscribeButton: MenuButton!
    
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 13.0, *) { presentingViewController?.beginAppearanceTransition(false, animated: animated) }
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupGesture()
    }
    
    // MARK: - Function
    func setupLayout() {
        
        // 画面の大きさ
        var contentRect = view.bounds
        contentRect.size.width = contentMaxWidth
        contentRect.origin.x = -contentRect.width
        contentView.frame = contentRect
        contentView.backgroundColor = .white
        contentView.autoresizingMask = .flexibleHeight
        view.addSubview(contentView)
        
        profileButton = MenuButton(text: "マイページ", textSize: 15)
        formButton = MenuButton(text: "お問い合せ", textSize: 15)
        termOfUseButton = MenuButton(text: "利用規約", textSize: 15)
        privacyPolicyButton = MenuButton(text: "プライバシーポリシー", textSize: 15)
        logoutButton = MenuButton(text: "ログアウト", textSize: 15)
        unsubscribeButton = MenuButton(text: "アカウント削除", textSize: 15, backgroundColor: Color.orange.UIColor)
        let menuVerticallView = UIStackView(arrangedSubviews: [profileButton, formButton, termOfUseButton, privacyPolicyButton, logoutButton, unsubscribeButton])
        menuVerticallView.axis = .vertical
        menuVerticallView.distribution = .fillEqually   // 全ての要素の大きさを均等に
        menuVerticallView.spacing = 15
        
        contentView.addSubview(menuVerticallView)
        menuVerticallView.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(contentView.bounds.width * 0.5)
            make.centerY.equalTo(contentView.bounds.height * 0.5)
        }
    }
    
    // MARK: - Gesture
    func setupGesture() {
        // メニュー画面以外の領域タップでメニュー画面を閉じる
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(sender:)))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func backgroundTapped(sender: UITapGestureRecognizer) {
        hideContentView(animated: true) { (_) in
            self.willMove(toParent: nil)
            self.removeFromParent()
            self.view.removeFromSuperview()
        }
    }
    func hideContentView(animated: Bool, completion: ((Bool) -> Swift.Void)?) {
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.contentRatio = 0
            }, completion: { (finished) in
                completion?(finished)
            })
        } else {
            contentRatio = 0
            completion?(true)
        }
    }
    
    func showContentView(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3) { self.contentRatio = 1.0 }
        } else { contentRatio = 1.0 }
    }
    
    // 指の動きを検知
    func startPanGestureRecognizing() {
        if let parentViewController = self.delegate?.parentViewControllerForSideMenuViewController(self) {
            screenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandled(panGestureRecognizer:)))
            screenEdgePanGestureRecognizer.edges = [.left]
            screenEdgePanGestureRecognizer.delegate = self
            parentViewController.view.addGestureRecognizer(screenEdgePanGestureRecognizer)
            
            panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandled(panGestureRecognizer:)))
            panGestureRecognizer.delegate = self
            parentViewController.view.addGestureRecognizer(panGestureRecognizer)
        }
    }
    
    @objc func panGestureRecognizerHandled(panGestureRecognizer: UIPanGestureRecognizer) {
        guard let shouldPresent = self.delegate?.shouldPresentForSideMenuViewController(self) else {
            return
        }
        
        let translation = panGestureRecognizer.translation(in: view)   // 初期タップ位置からの移動量
        if translation.x > 0 && contentRatio == 1.0 { return }
        
        let location = panGestureRecognizer.location(in: view)   // 現在のタップ位置
        switch panGestureRecognizer.state {
        case .began:
            beganState = isShown
            beganLocation = location
            if translation.x >= 0 && location.x < 100 { self.delegate?.sideMenuViewControllerDidRequestShowing(self, contentAvailability: false, animated: false) }
        case .changed:
            let distance = beganState ? beganLocation.x - location.x : location.x - beganLocation.x
            if distance >= 0 {
                let ratio = distance / (beganState ? beganLocation.x : (view.bounds.width - beganLocation.x))
                let contentRatio = beganState ? 1 - ratio : ratio
                self.contentRatio = contentRatio
            }
            
        case .ended, .cancelled, .failed:
            if contentRatio <= 1.0, contentRatio >= 0 {
                if location.x > beganLocation.x { showContentView(animated: true) }
                else { self.delegate?.sideMenuViewControllerDidRequestHiding(self, animated: true) }
            }
            beganLocation = .zero
            beganState = false
            
        default: break
        }
    }
    
}
