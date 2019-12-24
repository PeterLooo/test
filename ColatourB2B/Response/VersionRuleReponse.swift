//
//  VersionRuleReponse.swift
//  colatour
//
//  Created by M7268 on 2019/1/23.
//  Copyright © 2019 Colatour. All rights reserved.
//

import Foundation

import ObjectMapper

class VersionRuleReponse: BaseModel {
    
    var update: Update?
    override func mapping(map: Map) {
        super.mapping(map: map)
        update <- map["Update"]
    }
    class Update: BaseModel {
        var updateNo: Int?
        var updateMode: String?
        var updateUrl: String?
        var updateMessage: String?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            updateNo <- map["Update_No"]
            updateMode <- map["Update_Mode"]
            updateUrl <- map["Update_Url"]
            updateMessage <- map["Update_Message"]
        }
    }
}
