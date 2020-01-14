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
        
        salseList <- map["Sales_List"]
    }
    
    class Sales: BaseModel {
        
        var dedicatedLine : String?
        var email : String?
        var introduction : String?
        var lineID : String?
        var mobile : String?
        var phone : String?
        var salesName : String?
        var salesTitle : String?
        var ext : String?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            
            dedicatedLine <- map["Dedicated_Line"]
            email <- map["Email"]
            introduction <- map["Introduction"]
            lineID <- map["Line_Id"]
            mobile <- map["Mobile"]
            phone <- map["Phone"]
            salesName <- map["Sales_Name"]
            salesTitle <- map["Sales_Title"]
            ext <- map["Ext"]
        }
    }
}
