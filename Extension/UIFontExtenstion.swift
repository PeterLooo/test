//
//  UIViewExtenstion.swift
//  colatour
//
//  Created by M6853 on 2019/4/24.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit

enum FontThickness {
    case medium
    case regular
    case semibold
}

extension UIFont {
    convenience init(thickness: FontThickness, size: CGFloat) {
        switch thickness {
        case .medium:
            self.init(name: "PingFangTC-Medium", size: size)!
        case .regular:
            self.init(name: "PingFangTC-Regular", size: size)!
        case .semibold:
            self.init(name: "PingFangTC-Semibold", size: size)!
       }
    }
}
