//
//  MemberIndexResponse.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/31.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit
import ObjectMapper

class MemberIndexResponse: BaseModel {
    
    var memberIndexList:[ServerData] = []

    override func mapping(map: Map) {
        super.mapping(map: map)
        memberIndexList <- map["MemberIndex_List"]

    }
    
}

