//
//  MessageSendResponse.swift
//  ColatourB2B
//
//  Created by M7635 on 2020/1/22.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
import ObjectMapper

class MessageSendUserListResponse: BaseModel {
    
    var sendUserList: [UserStatus] = []
    
    override func mapping(map: Map) {
        super.mapping(map: map)
    
        sendUserList <- map["SendUser_List"]
    }
}

class UserStatus: BaseModel {
    
    var sendKey: String?
    var sendName: String?
    var defaultMark: Bool?
    var enabledMark: Bool?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
    
        sendKey <- map["Send_Key"]
        sendName <- map["Send_Name"]
        defaultMark <- map["Default_Mark"]
        enabledMark <- map["Enabled_Mark"]
    }
}
