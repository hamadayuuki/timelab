//
//  MaskCALayer.swift
//  TIMELAB-Prototype
//
//  Created by 濵田　悠樹 on 2022/03/13.
//

import UIKit

// マスク(灰色の背景に 透明の正方形)を描画
class MaskCALayer: CALayer {
    init(view: UIView, maskWidth: CGFloat, maskHeight: CGFloat) {
        let centerX = view.bounds.width / 2.0
        let centerY = view.bounds.height / 2.0
        super.init()
        
        // くり抜かれる レイヤー
        self.bounds = view.bounds
        self.position = view.center
        self.backgroundColor = UIColor.black.cgColor
        self.opacity = 0.2

        // くり抜く レイヤー
        let maskLayer = CAShapeLayer()
        maskLayer.bounds = self.bounds
        let startPosition: [String: CGFloat] = ["x": centerX - (maskWidth / 2.0), "y": centerY - (maskHeight / 2.0)]
        let maskRect =  CGRect(x: startPosition["x"]!, y: startPosition["y"]!, width: maskWidth, height: maskHeight)
        
        // 描画
        let path =  UIBezierPath(rect: maskRect)
        path.append(UIBezierPath(rect: maskLayer.bounds))
        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.path = path.cgPath
        maskLayer.position = CGPoint(x: centerX, y: centerY)
        
        // マスクのルールをeven/oddに設定する
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        self.mask = maskLayer
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
