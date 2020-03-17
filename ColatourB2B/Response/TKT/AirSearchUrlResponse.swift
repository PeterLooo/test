//
//  AirSearchUrlResponse.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2020/3/16.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
import ObjectMapper
class AirSearchUrlResponse: BaseModel {
    var airUrlResult:AirUrlResult?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
               
        airUrlResult <- map["AirTicketSearch_Data"]
    }
    
    class AirUrlResult: BaseModel {
        
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
