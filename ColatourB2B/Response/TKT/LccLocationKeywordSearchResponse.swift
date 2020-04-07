//
//  LccLocationKeywordSearchResponse.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/20.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
import ObjectMapper

class LccLocationKeywordSearchResponse: BaseModel {
    
    var keywordResultData: LCCSearchKeywordData?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        keywordResultData <- map["LCCSearchKeyword_Data"]
    }
    
    class LCCSearchKeywordData: BaseModel {
        
        var cityList: [TKTInitResponse.TicketResponse.City] = []
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            
            cityList <- map["City_List"]
        }
    }
}
