//
//  RegisterResponse.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/12/15.
//  Copyright © 2021 Colatour. All rights reserved.
//

import UIKit
import ObjectMapper

class RegisterResponse: BaseModel {
    
    var errorMsgList: [ErrorMsgListModel]?
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        errorMsgList <- map["ErrorMsg_List"]
    }
    
    class ErrorMsgListModel: BaseModel {
        
        var columnName: String?
        var errorMessage: String?
        
        override init() {
            super.init()
        }
        
        required init?(map: Map) {
            super.init(map: map)
        }
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            
            columnName <- map["Column_Name"]
            errorMessage <- map["Error_Message"]
        }
    }
}
