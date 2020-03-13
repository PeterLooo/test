//
//  AirTicketSearchResponse.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2020/3/9.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
import ObjectMapper

class AirTicketSearchResponse: BaseModel {
    
    var identityTypeList: [String] = []
    var serviceClassList: [ServiceClass] = []
    var airlineList: [Airline] = []
    var startTravelDate: String?
    var endTravelDateList: [EndTravelDate] = []
    var journeyTypeList: [String] = []
    var departureCodeList: [OriginCode] = []
    var destinationCodeList: [Any] = []
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
    
    class Area: BaseModel {
        
        var areaId: String?
        var areaName: String?
        
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
    
//    var groupAir : GroupAir?
//    var daterange : [AirInfo] = []
//    var identity : [AirInfo] = []
//    var lCC : LCC?
//    var maxDate : String?
//    var minDate : String?
//    var sOTOTicket : SOTOTicket?
//    var sitClass : [AirInfo] = []
//
//    override func mapping(map: Map) {
//        super.mapping(map: map)
//        groupAir <- map["Group_Air"]
//        daterange <- map["Date_Range"]
//        identity <- map["Identity"]
//        lCC <- map["LCC"]
//        maxDate <- map["Max_Date"]
//        minDate <- map["Min_Date"]
//        sOTOTicket <- map["SOTO_Ticket"]
//        sitClass <- map["Sit_Class"]
//
//    }
//
//    class SOTOTicket : BaseModel {
//
//        var airline : [AirInfo] = []
//        var departure : [AirInfo] = []
//        var tourType : [AirInfo] = []
//        var arrivals : [AirInfo] = []
//
//        override func mapping(map: Map) {
//            super.mapping(map: map)
//            airline <- map["Airline"]
//            departure <- map["Departure"]
//            tourType <- map["Tour_Type"]
//            arrivals <- map["Arrivals"]
//
//        }
//    }
//
//    class LCC : BaseModel {
//
//        var countryList : [CountryInfo] = []
//        var unlimitedReturnInfo : String?
//
//        override func mapping(map: Map) {
//            super.mapping(map: map)
//            countryList <- map["Country_list"]
//            unlimitedReturnInfo <- map["Unlimited_Return_Info"]
//
//        }
//    }
//
//    class GroupAir : BaseModel{
//
//        var airline : [AirInfo] = []
//        var continentList : [ContinentInfo] = []
//        var departure : [AirInfo] = []
//        var tourType : [AirInfo] = []
//
//        override func mapping(map: Map) {
//            super.mapping(map: map)
//            airline <- map["Airline"]
//            continentList <- map["Continent_List"]
//            departure <- map["Departure"]
//            tourType <- map["Tour_Type"]
//
//        }
//    }
//
//    class ContinentInfo : BaseModel {
//
//        var continent : String?
//        var countryList : [CountryInfo] = []
//        var isSelected = false
//
//        override func mapping(map: Map) {
//            super.mapping(map: map)
//            continent <- map["Continent"]
//            countryList <- map["Country_list"]
//
//        }
//    }
//
//    class CountryInfo : BaseModel {
//
//        var airportList : [AirInfo]?
//        var country : String?
//        var isSelected = false
//
//        override func mapping(map: Map) {
//            super.mapping(map: map)
//
//            airportList <- map["Airport_List"]
//            country <- map["Country"]
//
//        }
//    }
//
//    class AirInfo : BaseModel {
//
//        var text : String?
//        var value : String?
//
//        override func mapping(map: Map) {
//            super.mapping(map: map)
//            text <- map["Text"]
//            value <- map["Value"]
//
//        }
//    }
}
