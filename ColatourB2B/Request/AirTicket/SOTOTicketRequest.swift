//
//  SotoTicketRequest.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/13.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation

class SotoTicketRequest: NSObject {
    
    var service: TKTInitResponse.TicketResponse.ServiceClass?
    var identityType: String?
    var journeyType: String?
    var airline: TKTInitResponse.TicketResponse.Airline?
    var departure: TKTInitResponse.TicketResponse.OriginCode?
    var destination: TKTInitResponse.TicketResponse.DestinationCode?
    var startTravelDate: String?
    var endTravelDate: TKTInitResponse.TicketResponse.EndTravelDate?
    var isNonStop: Bool = true
    
    convenience init(service: TKTInitResponse.TicketResponse.ServiceClass?,
                     identityType: String?,
                     journeyType: String?,
                     airline: TKTInitResponse.TicketResponse.Airline?,
                     departure: TKTInitResponse.TicketResponse.OriginCode?,
                     destination: TKTInitResponse.TicketResponse.DestinationCode?,
                     startTravelDate: String?,
                     endTravelDate: TKTInitResponse.TicketResponse.EndTravelDate?,
                     isNonStop: Bool) {
        self.init()
        self.service = service
        self.identityType = identityType
        self.journeyType = journeyType
        self.airline = airline
        self.departure = departure
        self.destination = destination
        self.startTravelDate = startTravelDate
        self.endTravelDate = endTravelDate
        self.isNonStop = isNonStop
    }
    
    func getDictionary() -> [String : Any] {
        
        var params = ["Source_Info": "SOTO",
                      "Service_Class": service?.serviceId ?? "",
                      "Identity_Type": identityType ?? "",
                      "Journey_Type" : journeyType ?? "",
                      "Airline_Id" : airline?.airlineId ?? "",
                      "Origin_Code" : departure?.departureCodeId ?? "",
                      "Destination_Code" : destination?.destinationCodeId ?? ""] as [String : Any]
        params["Return_Code"] = ""
        params["Start_Date"] = startTravelDate ?? ""
        params["End_Date"] = endTravelDate?.endTravelDateId ?? ""
        params["Transit_Mark"] = !isNonStop
        
        return params
    }
    
    func getSotoTicketRequest(response: TKTInitResponse.TicketResponse) -> SotoTicketRequest {
        
        return SotoTicketRequest(service: response.serviceClassList.first,
                                 identityType: response.identityTypeList.first,
                                 journeyType: response.journeyTypeList.first,
                                 airline: response.airlineList.first,
                                 departure: response.departureCodeList.first,
                                 destination: response.destinationCodeList.first,
                                 startTravelDate: response.startTravelDate,
                                 endTravelDate: response.endTravelDateList.first,
                                 isNonStop: true)
    }
}
