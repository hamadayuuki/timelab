//
//  CustomFloatingPanelLayout.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/23.
//

import UIKit
import FloatingPanel

// モーダル実装(FloatingPanel)の設定
class CustomFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .full
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            // 全モーダル時のレイアウト
            .full: FloatingPanelLayoutAnchor(absoluteInset: 50.0, edge: .top, referenceGuide: .safeArea),
            // 半モーダル時のレイアウト, スライドした時に非表示にする
            .tip: FloatingPanelLayoutAnchor(absoluteInset: -50.0, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
}
