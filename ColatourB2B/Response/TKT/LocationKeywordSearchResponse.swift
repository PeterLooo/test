//
//  LocationKeywordSearchResponse.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/18.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
import ObjectMapper

class LocationKeywordSearchResponse: BaseModel {
    
    var keywordResultData: AirTicketKeywordData?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        keywordResultData <- map["AirTicketKeyword_Data"]
    }
    
    class AirTicketKeywordData: BaseModel {
        
        var cityList: [City] = []
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            
            cityList <- map["City_List"]
        }
    }
    
    class City: BaseModel {
        
        var cityId: String?
        var cityName: String?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            
            cityId <- map["City_Id"]
            cityName <- map["City_Name"]
        }
    }
}
