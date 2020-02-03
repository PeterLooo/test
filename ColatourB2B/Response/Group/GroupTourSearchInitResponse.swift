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
        var defaultDepartureDate: String?
        var regionList: [Region] = []
        var departureCityList: [DepartureCity] = []
        var airlineCodeList: [AirlineCode] = []
        var tourTypeList: [TourType] = []
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            
            defaultDepartureDate <- map["Default_Departure_Date"]
            regionList <- map["Region_List"]
            departureCityList <- map["DepartureCity_List"]
            airlineCodeList <- map["AirlineCode_List"]
            tourTypeList <- map["TourType_List"]
        }
    }
}

class DepartureCity: BaseModel {
    var departureName: String?
    var departureCode: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        departureName <- map["Departure_Name"]
        departureCode <- map["Departure_Code"]
    }
}

class AirlineCode: BaseModel {
    var airlineName: String?
    var airlineCode: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        airlineName <- map["Airline_Name"]
        airlineCode <- map["Airline_Code"]
    }
}

class Region: BaseModel {
    var regionCode: String?
    var regionName: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        regionCode <- map["Region_Code"]
        regionName <- map["Region_Name"]
    }
}

class TourType: BaseModel {
    var tourTypeCode: String?
    var tourTypeName: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        tourTypeCode <- map["TourType_Code"]
        tourTypeName <- map["TourType_Name"]
    }
}

class KeyValue: BaseModel {
    var key: String?
    var value: String?
    
    convenience init(key: String?, value: String?) {
        self.init()
        
        self.key = key
        self.value = value
    }
}
