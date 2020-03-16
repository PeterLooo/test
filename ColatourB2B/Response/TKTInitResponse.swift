//
//  TKTInitResponse.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/13.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
import ObjectMapper

class TKTInitResponse: BaseModel {
    
    var initResponse: TicketResponse?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        initResponse <- map["AirTicketSearchInitial_Data"]
    }
    
    class TicketResponse: BaseModel {
        
        var identityTypeList: [String] = []
        var serviceClassList: [ServiceClass] = []
        var airlineList: [Airline] = []
        var startTravelDate: String?
        var endTravelDateList: [EndTravelDate] = []
        var journeyTypeList: [String] = []
        var departureCodeList: [OriginCode] = []
        var destinationCodeList: [DestinationCode] = []
        var areaList: [Area] = []
        var countryList: [Country] = []
        var effectEndDate: String?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            
            identityTypeList <- map["IdentityType_List"]
            serviceClassList <- map["ServiceClass_List"]
            airlineList <- map["Airline_List"]
            startTravelDate <- map["StartTravelDate"]
            endTravelDateList <- map["EndTravelDate_List"]
            journeyTypeList <- map["JourneyType_List"]
            departureCodeList <- map["OriginCode_List"]
            destinationCodeList <- map["DestinationCode_List"]
            areaList <- map["Area_List"]
            countryList <- map["Country_List"]
            effectEndDate <- map["Effect_End_Date"]
        }
        
        class ServiceClass: BaseModel {
            
            var serviceId: String?
            var serviceName: String?
            
            override func mapping(map: Map) {
                super.mapping(map: map)
                
                serviceId <- map["ServiceClass_Id"]
                serviceName <- map["ServiceClass_Name"]
            }
        }
        
        class Airline: BaseModel {
            
            var airlineId: String?
            var airlineName: String?
            
            override func mapping(map: Map) {
                super.mapping(map: map)
                
                airlineId <- map["Airline_Id"]
                airlineName <- map["Airline_Name"]
            }
        }
        
        class EndTravelDate: BaseModel {
            
            var endTravelDateId: String?
            var endTravelDateName: String?
            
            override func mapping(map: Map) {
                super.mapping(map: map)
                
                endTravelDateId <- map["EndTravelDate_Id"]
                endTravelDateName <- map["EndTravelDate_Name"]
            }
        }
        
        class OriginCode: BaseModel {
            
            var departureCodeId: String?
            var departureCodeName: String?
            
            override func mapping(map: Map) {
                super.mapping(map: map)
                
                departureCodeId <- map["OriginCode_Id"]
                departureCodeName <- map["OriginCode_Name"]
            }
        }
        
        class DestinationCode: BaseModel {
            
            var destinationCodeId: String?
            var destinationCodeName: String?
            
            override func mapping(map: Map) {
                super.mapping(map: map)
                
                destinationCodeId <- map["DestinationCode_Id"]
                destinationCodeName <- map["DestinationCode_Name"]
            }
        }
        
        class Area: BaseModel {
            
            var areaId: String?
            var areaName: String?
            var isSelected = false
            
            override func mapping(map: Map) {
            super.mapping(map: map)
                
                areaId <- map["Area_Id"]
                areaName <- map["Area_Name"]
            }
        }
        
        class Country: BaseModel {
            
            var areaId: String?
            var countryId: String?
            var countryName: String?
            var cityList: [City] = []
            
            override func mapping(map: Map) {
                super.mapping(map: map)
                
                areaId <- map["Area_Id"]
                countryId <- map["Country_Id"]
                countryName <- map["Country_Name"]
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
}
