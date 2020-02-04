//
//  MessageSendResponse.swift
//  ColatourB2B
//
//  Created by M7635 on 2020/1/30.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
import ObjectMapper

class MessageSendResponse: BaseModel {
    
    var messageSendAlertMsg: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
    
        messageSendAlertMsg <- map["AlertMsg"]
    }
}
