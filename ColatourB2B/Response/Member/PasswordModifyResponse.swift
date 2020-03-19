//
//  PasswordModifyResponse.swift
//  ColatourB2B
//
//  Created by M7635 on 2020/1/16.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
import ObjectMapper

class PasswordModifyResponse: BaseModel {
    
    var modifyPassowrd: PasswordModifyComponent?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        modifyPassowrd <- map["ModifyPassowrd"]
    }
}

class PasswordModifyComponent: BaseModel {
    
    var modifyMark: Bool?
    var modifyMessage: String?
    var accessToken: String?
    var refreshToken: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        modifyMark <- map["Modify_Mark"]
        modifyMessage <- map["Modify_Message"]
        accessToken <- map["Access_Token"]
        refreshToken <- map["Refresh_Token"]
    }
}
