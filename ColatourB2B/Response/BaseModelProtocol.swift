//
//  ss.swift
//  colatour
//
//  Created by M6853 on 2018/5/2.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit
import ObjectMapper

protocol BaseModelProtocol {
    init?(map: Map)
    func getValue<T>(Type: T.Type) -> T
}


