//
//  NewsResponse.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/22.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
import ObjectMapper

class NewsResponse: BaseModel {
    
    var newsList : [NewsItem] = []

    override func mapping(map: Map) {
    super.mapping(map: map)
        newsList <- map["eDM_List"]
        
    }
    
    class NewsItem : BaseModel {
        
        var linkType : LinkType?
        var linkValue : String!
        var publishDate : String?
        var unreadMark : Bool?
        var eDMTitle : String?
        var eDMType : String?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            
            linkValue <- map["Link_Value"]
            publishDate <- map["Publish_Date"]
            unreadMark <- map["Unread_Mark"]
            eDMTitle <- map["eDM_Title"]
            eDMType <- map["eDM_Type"]
            
            var type = ""
            type <- map["Link_Type"]
            linkType = LinkType(rawValue: type)
            if (linkType == nil) { linkType = .unknown }
            
        }
    }
}
