//
//  RegisterAgentModel.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/12/7.
//  Copyright © 2021 Colatour. All rights reserved.
//
import UIKit
import ObjectMapper

class RegisterAgentModel: BaseModel {
    
    var errorMessage: String?
    var agentIsExist: Bool?
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        errorMessage <- map["Error_Message"]
        agentIsExist <- map["Agent_IsExist"]
    }
}
