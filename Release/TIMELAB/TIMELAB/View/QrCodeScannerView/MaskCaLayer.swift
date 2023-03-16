//
//  MaskCaLayer.swift
//  TIMELAB
//
//  Created by 濵田　悠樹 on 2022/04/06.
//

import UIKit

// マスク(灰色の背景に 透明の正方形)を描画
class MaskCaLayer: CALayer {
    init(view: UIView, maskWidth: CGFloat, maskHeight: CGFloat, diffY: CGFloat,cornerRadius: CGFloat) {
        let centerX = view.bounds.width / 2.0
        let centerY = (view.bounds.height / 2.0) - diffY
        super.init()
        
        // くり抜かれる レイヤー
        self.bounds = view.bounds
        self.position = view.center
        self.backgroundColor = UIColor.white.cgColor
        self.opacity = 0.8

        // くり抜く レイヤー
        let maskLayer = CAShapeLayer()
        maskLayer.bounds = self.bounds
        let startPosition: [String: CGFloat] = ["x": centerX - (maskWidth / 2.0), "y": centerY - (maskHeight / 2.0)]
        let maskRect =  CGRect(x: startPosition["x"]!, y: startPosition["y"]!, width: maskWidth, height: maskHeight)
        
        // 描画
        let path =  UIBezierPath(rect: maskLayer.bounds)   // くり抜く形
        path.append(UIBezierPath(roundedRect: maskRect, cornerRadius: cornerRadius))   // くり抜かれる形
        maskLayer.path = path.cgPath
        maskLayer.position = CGPoint(x: centerX, y: centerY)
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd   // マスクのルールをeven/oddに設定する
        self.mask = maskLayer
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
