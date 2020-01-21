//
//  GroupTourSearchInitResponse.swift
//  ColatourB2B
//
//  Created by M6853 on 2020/1/17.
//  Copyright © 2020 Colatour. All rights reserved.
//

import ObjectMapper

class GroupTourSearchInitResponse: BaseModel {
    var groupTourSearchInit: GroupTourSearchInit?
    
    class GroupTourSearchInit: BaseModel {
        var defaultStarTourDate: String?
        var defaultTourDays: Int?
        var inputDescription: String?
        var regionCodeList: [KeyValue] = []
        var departureCityList: [KeyValue] = []
        var airlineCodeList: [KeyValue] = []
        var tourTypeList: [KeyValue] = []
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            
            defaultStarTourDate <- map["Default_StarTourDate"]
            defaultTourDays <- map["Default_TourDays"]
            inputDescription <- map["Input_Description"]
            regionCodeList <- map["Region_Code_List"]
            departureCityList <- map["DepartureCity_List"]
            airlineCodeList <- map["AirlineCode_List"]
            tourTypeList <- map["TourType_List"]
        }
    }
}

class KeyValue: BaseModel {
    var key: String?
    var value: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        key <- map["Key"]
        value <- map["Value"]
    }
}
