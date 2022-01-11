//
//  CorrectEmailInfo.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/12/22.
//  Copyright © 2021 Colatour. All rights reserved.
//

import ObjectMapper

class CorrectEmailInfo: BaseModel {
    
    var name: String?
    var gender: String?
    var email: String?
    var sendEmailResult: String?
    var confirmResult: Bool?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        name <- map["Member_Name"]
        gender <- map["Member_Gender"]
        email <- map["Member_Email"]
        sendEmailResult <- map["Error_Message"]
        confirmResult <- map["Confirm_Mark"]
    }
}
