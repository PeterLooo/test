//
//  GroupTourSearchUrlResponse.swift
//  ColatourB2B
//
//  Created by M6853 on 2020/1/30.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
import ObjectMapper

class GroupTourSearchUrlResponse: BaseModel {
    var groupTourSearchUrl: GroupTourSearchUrl?
    
    class GroupTourSearchUrl: BaseModel {
        var linkType: LinkType?
        var linkValue: String?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
                   
            linkType <- map["Link_Type"]
            if (linkType == nil) { linkType = .unknown }
            linkValue <- map["Link_Value"]
        }
    }
}
