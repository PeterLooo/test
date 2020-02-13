//
//  ContactInfoResponse.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/2/7.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation
import ObjectMapper

class ContactInfoResponse: BaseModel {
    
    var contactInfoList: [ContactInfo] = []
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        contactInfoList <- map["ContactInfo_List"]
    }
}

class ContactInfo: BaseModel {
    
    var contactInfoTitle: String?
    var contactInfoDataList: [Info] = []
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        contactInfoTitle <- map["ContactInfo_Title"]
        contactInfoDataList <- map["ContactInfoData_List"]
    }
}

class Info: BaseModel {
    
    var infoName: String?
    var infoPhone: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        infoName <- map["Info_Name"]
        infoPhone <- map["Info_Phone"]
    }
}
