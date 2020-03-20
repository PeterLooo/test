//
//  LccResponse.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2020/3/19.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
import ObjectMapper

class LccResponse: BaseModel {
    
    var lCCSearchInitialData : LCCSearchInitialData?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        lCCSearchInitialData <- map["LCCSearchInitial_Data"]
    }
    
    class LCCSearchInitialData: BaseModel{
        
        var countryList : [TKTInitResponse.TicketResponse.Country] = []
        var defaultEndDate : String?
        var defaultStartDate : String?
        var effectEndDate : String?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            countryList <- map["Origin_Country_List"]
            defaultEndDate <- map["Default_End_Date"]
            defaultStartDate <- map["Default_Start_Date"]
            effectEndDate <- map["Effect_End_Date"]
        }
    }
}
