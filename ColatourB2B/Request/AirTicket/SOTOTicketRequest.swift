//
//  SotoTicketRequest.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/13.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation

class SotoTicketRequest: NSObject {
    
    var identityType: String?
    var service: SotoTicketResponse.ServiceClass?
    var airline: SotoTicketResponse.Airline?
    var startTravelDate: String?
    var endTravelDate: SotoTicketResponse.EndTravelDate?
    var journeyType: String?
    var departure: SotoTicketResponse.OriginCode?
    var destination: SotoTicketResponse.DestinationCode?
    var isNonStop: Bool = true
    
    convenience init(identityType: String?,
                     service: SotoTicketResponse.ServiceClass?,
                     airline: SotoTicketResponse.Airline?,
                     startTravelDate: String?,
                     endTravelDate: SotoTicketResponse.EndTravelDate?,
                     journeyType: String?,
                     departure: SotoTicketResponse.OriginCode?,
                     destination: SotoTicketResponse.DestinationCode?,
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
    
    func getSotoTicketRequest(response: SotoTicketResponse) -> SotoTicketRequest {
        
        return SotoTicketRequest(identityType: response.identityTypeList.first,
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
