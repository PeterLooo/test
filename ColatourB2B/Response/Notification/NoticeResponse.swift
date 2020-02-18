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
    
    var notification : Notification?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        notification <- map["Notification"]
    }
    
    class Notification : BaseModel{
        var notiItemList : [Item] = []
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            
            notiItemList <- map["Notification_List"]
        }
    }
    
    class Item: BaseModel {
        
        var inputTime : String?
        var notiId : String?
        var notiType : String?
        var pushContent : String?
        var pushTitle : String?
        var pushType : String?
        var unreadMark : Bool?
        var linkType : LinkType?
        var linkValue : String?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            
            inputTime <- map["Input_Time"]
            notiId <- map["Noti_Id"]
            notiType <- map["Noti_Type"]
            pushContent <- map["Push_Content"]
            pushTitle <- map["Push_Title"]
            pushType <- map["Push_Type"]
            unreadMark <- map["Unread_Mark"]
            
            var type = ""
            type <- map["Link_Type"]
            linkType = LinkType(rawValue: type)
            if (linkType == nil) { linkType = .unknown }
            linkValue <- map["Link_Params"]
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

class NotiItem: NSObject {
    
    var linkType : LinkType!
    var linkValue : String?
    var notiDate : String?
    var unreadMark : Bool?
    var notiTitle : String?
    var notiContent : String?
    var notiId: String?
    var apiNotiType: String?
    
    convenience init(notiTitle : String?,
                     notiContent : String?,
                     notiId: String?,
                     notiDate : String?,
                     unreadMark : Bool?,
                     linkType : LinkType!,
                     linkValue : String?,
                     apiNotiType: String?) {
        
        self.init()
        self.notiTitle = notiTitle
        self.notiContent = notiContent
        self.notiId = notiId
        self.notiDate = FormatUtil.convertStringToString(dateStringFrom: notiDate!, dateFormatTo: "MM/dd")
        self.unreadMark = unreadMark
        self.linkType = linkType
        self.linkValue = linkValue
        self.apiNotiType = apiNotiType
    }
}
