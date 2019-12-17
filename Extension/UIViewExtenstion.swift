//
//  UIViewExtenstion.swift
//  colatour
//
//  Created by M6853 on 2019/4/24.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit

extension UIView {
    
    func clip(withRect rect: CGRect, cornerRadius: CGFloat) {
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)

        let clippedPath = UIBezierPath(rect: self.bounds)
        clippedPath.append(path)
        
        if let originalMask = self.layer.mask
            , let originalShape = originalMask as? CAShapeLayer
            , let originalPath = originalShape.path {

            let originalBezierPath = UIBezierPath(cgPath: originalPath)
            clippedPath.append(UIBezierPath(rect: self.bounds))
            clippedPath.append(originalBezierPath)
        }
        
        shapeLayer.path = clippedPath.cgPath
        shapeLayer.fillRule = kCAFillRuleEvenOdd
        self.layer.mask = shapeLayer
    }
    
}
