//
//  BulletinResponse.swift
//  colatour
//
//  Created by M7268 on 2019/1/21.
//  Copyright © 2019 Colatour. All rights reserved.
//

import Foundation

import ObjectMapper

class BulletinResponse: BaseModel {
    
    var bulletin: Bulletin?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        bulletin <- map["Bulletin"]
    }
    
    class Bulletin: BaseModel {
        var bulletinNo: Int?
        var bulletinClass: String?
        var bulletinTitle: String?
        var bulletinContent: String?
        var bulletinImage: String?
        var linkType: LinkType!
        var actionParam: String?
        var actionName: String?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            bulletinNo <- map["Bulletin_No"]
            bulletinClass <- map["Bulletin_Class"]
            bulletinTitle <- map["Bulletin_Title"]
            bulletinContent <- map["Bulletin_Content"]
            bulletinImage <- map["Bulletin_Image"]
            var type = ""
            type <- map["Link_Type"]
            linkType = LinkType(rawValue: type)
            if (linkType == nil) { linkType = .unknown }
            actionParam <- map["Action_Param"]
            actionName <- map["Action_Name"]
        }
    }
}
