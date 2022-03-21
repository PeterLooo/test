//
//  LoginResponse.swift
//  colatour
//
//  Created by AppDemo on 2018/1/17.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit
import ObjectMapper

class LoginResponse: BaseModel {
    
    var loginResult : Bool?
    var loginMessage : String?
    var passwordReset : Bool?
    var accessToken : String?
    var refreshToken : String?
    var linkType: TabBarLinkType?
    var linkValue: String?
    var allowTour: Bool?
    var allowTkt: Bool?
    var employeeMark: Bool?
    var pageId: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        loginResult <- map["Login_Result"]
        loginMessage <- map["Login_Message"]
        passwordReset <- map["Password_Reset"]
        accessToken <- map["Access_Token"]
        refreshToken <- map["Refresh_Token"]
    
        var type = ""
        type <- map["Link_Type"]
        linkType = TabBarLinkType(rawValue: type)
        if (linkType == nil) { linkType = .unknown }
        
        linkValue <- map["Link_Value"]
        allowTour <- map["Allow_Tour"]
        allowTkt <- map["Allow_Tkt"]
        employeeMark <- map["Employee_Mark"]
        pageId <- map["Page_Id"]
    }
    
    override func getValue<T>(Type: T.Type) -> T {
        return self as! T
    }
}

class AccessTokenResponse: BaseModel {
    
    var accessToken : String?
    var refreshToken : String?
    var allowTour: Bool?
    var allowTkt: Bool?
    var defaultLinkType: String?
    var defaultLinkValue: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        accessToken <- map["Access_Token"]
        refreshToken <- map["Refresh_Token"]
        allowTour <- map["Allow_Tour"]
        allowTkt <- map["Allow_Tkt"]
        defaultLinkType <- map["Default_Link_Type"]
        defaultLinkValue <- map["Default_Link_Value"]
    }
    
    override func getValue<T>(Type: T.Type) -> T {
        return self as! T
    }
}
