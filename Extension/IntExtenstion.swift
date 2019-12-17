//
//  UIViewExtenstion.swift
//  colatour
//
//  Created by M6853 on 2019/4/24.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit

extension Int {
    var adjusted: CGFloat {
        return CGFloat(self) * Device.ratio
    }
}

class Device {
    //Note: 測試中
    //Note: iPhone 8s Plus
    static let base: CGFloat = 736
    static var ratio: CGFloat {
        return UIScreen.main.bounds.height / base
    }
}
