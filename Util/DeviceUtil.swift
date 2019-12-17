//
//  DeviceUtil.swift
//  colatour
//
//  Created by AppDemo on 2018/1/9.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit

class DeviceUtil: NSObject {
    
    static func appBuildVersion() -> String?{
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
    
    static func appVersion() -> String?{
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    static func osVersion() -> String?{
        return UIDevice.current.systemVersion
    }
    
    static func phoneName() -> String?{
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
