//
//  NotificationResponse.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/8.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
import ObjectMapper

class NoticeResponse: BaseModel {
    
    var message : [Item] = []
    var news : [Item] = []
    var order : [Item] = []

    override func mapping(map: Map) {
    super.mapping(map: map)
        
        message <- map["Message"]
        news <- map["News"]
        order <- map["Order"]
    }
    
    class Item: BaseModel {
        
        var linkType : LinkType?
        var linkValue : String?
        var noTiNo : String?
        var notiTitle : String?
        var remark : String?
        var unreadMark : Bool?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            
            noTiNo <- map["NoTi_No"]
            notiTitle <- map["Noti_Title"]
            remark <- map["Remark"]
            unreadMark <- map["Unread_Mark"]
            linkType <- map["Link_Type"]
            
            var type = ""
            type <- map["Link_Type"]
            linkType = LinkType(rawValue: type)
            if (linkType == nil) { linkType = .unknown }
            linkValue <- map["Link_Value"]
        }
    }
}
class NoticeUnreadCountResponse: BaseModel {

    var unreadCount: Int!
    override func mapping(map: Map) {
        super.mapping(map: map)
        unreadCount <- map["Unread_Count"]
    }
    
}
