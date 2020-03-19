//
//  GroupMenuResponse.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/24.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit
import ObjectMapper
class GroupMenuResponse: BaseModel {
    
    var serverList : [[ServerData]] = []
    
    override func mapping(map: Map) {
        super.mapping(map: map)
    
        serverList <- map["ToolBar_List"]
    }
}

class ServerData: BaseModel {
    
    var linkType : LinkType!
    var linkValue : String?
    var linkName : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        var type = ""
        type <- map["Link_Type"]
        linkType = LinkType(rawValue: type)
        if (linkType == nil) { linkType = .unknown }
        linkValue <- map["Link_Value"]
        linkName <- map["Link_Name"]

    }
}

class WebUrl: BaseModel {
    
    var webUrl : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        webUrl <- map["Web_Url"]
    }
}