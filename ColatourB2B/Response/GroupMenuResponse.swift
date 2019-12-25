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
    
    var contactList : [ServerData] = []
    var serverList : [ServerItem] = []
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        contactList <- map["Contact_List"]
        serverList <- map["Server_Item"]
        
    }
    
    class ServerItem : BaseModel {
        
        var itemDataList : [ServerData] = []
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            itemDataList <- map["Server_List"]
        }
    }
    
    class ServerData: BaseModel {
        
        var linkType : LinkType!
        var linkValue : String?
        var server : String?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            
            var type = ""
            type <- map["Link_Type"]
            linkType = LinkType(rawValue: type)
            if (linkType == nil) { linkType = .unknown }
            linkValue <- map["Link_Value"]
            server <- map["Server"]

        }
    }
    
}
