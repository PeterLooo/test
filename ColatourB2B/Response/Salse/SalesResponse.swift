//
//  SalesResponse.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/10.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
import ObjectMapper
class SalesResponse: BaseModel {
    
    var salseList:[Sales] = []
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        salseList <- map["WindowList_List"]
    }
    
    class Sales: BaseModel {
        
        var directPhone : String?
        var emailAddress : String?
        var sopMemo : String?
        var lineID : String?
        var mobilePhone : String?
        var officePhone : String?
        var salesName : String?
        var salesType : String?
        var sendType : MessageSendType!
        var officePhoneExt : String?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            
            directPhone <- map["Direct_Phone"]
            emailAddress <- map["Email_Address"]
            sopMemo <- map["SOP_Memo"]
            lineID <- map["Line_Id"]
            mobilePhone <- map["Mobile_Phone"]
            officePhone <- map["Office_Phone"]
            salesName <- map["Sales_Name"]
            salesType <- map["Sales_Type"]
            officePhoneExt <- map["Office_Phone_Ext"]
            
            var type = ""
            type <- map["Sales_Type"]
            sendType = MessageSendType(rawValue: type)
            if (sendType == nil) { sendType = .messageSend }
            
        }
    }
}
