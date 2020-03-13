//
//  SOTOTicketRequest.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/13.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation

class SOTOTicketRequest: NSObject {
    
    var identityType: String?
    var service: SOTOTicketResponse.ServiceClass?
    var airline: SOTOTicketResponse.Airline?
    var startTravelDate: String?
    var endTravelDate: SOTOTicketResponse.EndTravelDate?
    var journeyType: String?
    var departure: SOTOTicketResponse.OriginCode?
    var destination: SOTOTicketResponse.DestinationCode?
    var isNonStop: Bool = true
    
    convenience init(identityType: String?,
                     service: SOTOTicketResponse.ServiceClass?,
                     airline: SOTOTicketResponse.Airline?,
                     startTravelDate: String?,
                     endTravelDate: SOTOTicketResponse.EndTravelDate?,
                     journeyType: String?,
                     departure: SOTOTicketResponse.OriginCode?,
                     destination: SOTOTicketResponse.DestinationCode?,
                     isNonStop: Bool) {
        self.init()
        self.identityType = identityType
        self.service = service
        self.airline = airline
        self.startTravelDate = startTravelDate
        self.endTravelDate = endTravelDate
        self.journeyType = journeyType
        self.departure = departure
        self.destination = destination
        self.isNonStop = isNonStop
    }
    
    func getDictionary() -> [String : Any] {
        
        let params = ["Source_Info" : "Ticket",
                      "Service_Class" : service?.serviceId ?? "",
                      "Identity_Type" : identityType ?? "",
                      "Journey_Type" : journeyType ?? "",
                      "Airline_Id" : "",
                      "Origin_Code" : departure?.departureCodeId ?? "",
                      "Destination_Code" : "HKD",
                      "Return_Code" : "",
                      "Start_Date" : startTravelDate ?? "",
                      "End_Date" : endTravelDate?.endTravelDateId ?? "",
                      "Transit_Mark" : isNonStop] as [String : Any]
        
        return params
    }
    
    func getSOTOTicketRequest(response: SOTOTicketResponse) -> SOTOTicketRequest {
        
        return SOTOTicketRequest(identityType: response.identityTypeList.first,
                                 service: response.serviceClassList.first,
                                 airline: response.airlineList.first,
                                 startTravelDate: response.startTravelDate,
                                 endTravelDate: response.endTravelDateList.first,
                                 journeyType: response.journeyTypeList.first,
                                 departure: response.departureCodeList.first,
                                 destination: response.destinationCodeList.first,
                                 isNonStop: true)
    }
}
