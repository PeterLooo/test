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
    
    var accessToken : String?
    var confirmRegisterData : Bool?
    var loginMessage : String?
    var loginResult : Bool?
    var passwordReset : Bool?
    var refreshToken : String?

    override func mapping(map: Map) {
        super.mapping(map: map)
        accessToken <- map["Access_Token"]
        confirmRegisterData <- map["Confirm_RegisterData"]
        loginMessage <- map["Login_Message"]
        loginResult <- map["Login_Result"]
        passwordReset <- map["Password_Reset"]
        refreshToken <- map["Refresh_Token"]

    }
    
    override func getValue<T>(Type: T.Type) -> T {
        return self as! T
    }
}

class AccessTokenResponse: BaseModel {
    var accessToken : String?
    var refreshToken : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        accessToken <- map["Access_Token"]
        refreshToken <- map["Refresh_Token"]
    }
    
    override func getValue<T>(Type: T.Type) -> T {
        return self as! T
    }
}
