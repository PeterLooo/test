//
//  SOTOTicketResponse.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/13.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
import ObjectMapper

class SOTOTicketResponse: BaseModel {
    
    var identityTypeList: [String] = []
    var serviceClassList: [ServiceClass] = []
    var airlineList: [Airline] = []
    var startTravelDate: String?
    var endTravelDateList: [EndTravelDate] = []
    var journeyTypeList: [String] = []
    var originCodeList: [OriginCode] = []
    var destinationCodeList: [DestinationCode] = []
    var areaList: [Any] = []
    var countryList: [Any] = []
    var effectEndDate: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        identityTypeList <- map["IdentityType_List"]
        serviceClassList <- map["ServiceClass_List"]
        airlineList <- map["Airline_List"]
        startTravelDate <- map["StartTravelDate"]
        endTravelDateList <- map["EndTravelDate_List"]
        journeyTypeList <- map["JourneyType_List"]
        originCodeList <- map["OriginCode_List"]
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
        
        var originCodeId: String?
        var originCodeName: String?
        
        override func mapping(map: Map) {
        super.mapping(map: map)
            
            originCodeId <- map["OriginCode_Id"]
            originCodeName <- map["OriginCode_Name"]
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
}
