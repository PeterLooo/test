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
    
    var groupAir : GroupAir?
    var daterange : [AirInfo] = []
    var identity : [AirInfo] = []
    var lCC : LCC?
    var maxDate : String?
    var minDate : String?
    var sOTOTicket : SOTOTicket?
    var sitClass : [AirInfo] = []
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        groupAir <- map["Group_Air"]
        daterange <- map["Daterange"]
        identity <- map["Identity"]
        lCC <- map["LCC"]
        maxDate <- map["Max_Date"]
        minDate <- map["Min_Date"]
        sOTOTicket <- map["SOTO_Ticket"]
        sitClass <- map["Sit_Class"]
        
    }
    
    class SOTOTicket : BaseModel {
        
        var airline : [AirInfo] = []
        var departure : [AirInfo] = []
        var tourType : [AirInfo] = []
        var arrivals : [AirInfo] = []
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            airline <- map["Airline"]
            departure <- map["Departure"]
            tourType <- map["Tour_Type"]
            arrivals <- map["Arrivals"]
            
        }
    }
    
    class LCC : BaseModel {
        
        var countryList : [CountryInfo] = []
        var unlimitedReturnInfo : String?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            countryList <- map["Country_list"]
            unlimitedReturnInfo <- map["Unlimited_Return_Info"]
            
        }
    }
    
    class GroupAir : BaseModel{
        
        var airline : [AirInfo] = []
        var continentList : [ContinentInfo] = []
        var departure : [AirInfo] = []
        var tourType : [AirInfo] = []
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            airline <- map["Airline"]
            continentList <- map["Continent_List"]
            departure <- map["Departure"]
            tourType <- map["Tour_Type"]
            
        }
    }
    
    class ContinentInfo : BaseModel {
        
        var continent : String?
        var countryList : [CountryInfo] = []
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            continent <- map["Continent"]
            countryList <- map["Country_list"]
            
        }
    }
    
    class CountryInfo : BaseModel {
        
        var airportList : [AirInfo]?
        var country : String?
        var isSelected = false
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            
            airportList <- map["Airport_List"]
            country <- map["Country"]
            
        }
    }
    
    class AirInfo : BaseModel {
        
        var text : String?
        var value : String?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            text <- map["Text"]
            value <- map["Value"]
            
        }
    }
}
