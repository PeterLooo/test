//
//  UINavigationBarExtension.swift
//  colatour
//
//  Created by M3758 on 2018/3/29.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    func setGradientBackground(colors: [UIColor]) {
        
        var updatedFrame = bounds
        updatedFrame.size.height += self.frame.origin.y
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
        
        setBackgroundImage(gradientLayer.createGradientImage(), for: UIBarMetrics.default)
    }
}
