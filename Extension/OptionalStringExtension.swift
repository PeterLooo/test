//
//  UILabelExtension.swift
//  colatour
//
//  Created by M6853 on 2018/10/30.
//  Copyright © 2018年 Colatour. All rights reserved.
//

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        return self == "" || self == nil
    }
    
    var isNotNilOrEmpty: Bool {
        return !(self == "" || self == nil)
    }
}
