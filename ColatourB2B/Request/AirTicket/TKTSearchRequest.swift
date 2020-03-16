//
//  TKTSearchRequest.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2020/3/9.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation

class TKTSearchRequest: NSObject {

    var service: TKTInitResponse.TicketResponse.ServiceClass?
    var identityType: String?
    var journeyType: String?
    var airline: TKTInitResponse.TicketResponse.Airline?
    var departure: TKTInitResponse.TicketResponse.OriginCode?
    var destination: TKTInitResponse.TicketResponse.City?
    var startTravelDate: String?
    var endTravelDate: TKTInitResponse.TicketResponse.EndTravelDate?
    var returnCode:TKTInitResponse.TicketResponse.City?
    var isNonStop: Bool = true
    
    convenience init(service: TKTInitResponse.TicketResponse.ServiceClass?,
                     identityType: String?,
                     journeyType: String?,
                     airline: TKTInitResponse.TicketResponse.Airline?,
                     departure: TKTInitResponse.TicketResponse.OriginCode?,
                     destination: TKTInitResponse.TicketResponse.City?,
                     startTravelDate: String?,
                     endTravelDate: TKTInitResponse.TicketResponse.EndTravelDate?,
                     returnCode: TKTInitResponse.TicketResponse.City?,
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
        self.returnCode = returnCode
        self.isNonStop = isNonStop
    }
    
    func getDictionary() -> [String : Any] {
        
        var params = ["Source_Info": "Ticket",
                      "Service_Class" : service?.serviceId ?? "",
                      "Identity_Type" : identityType ?? "",
                      "Journey_Type" : journeyType ?? "",
                      "Airline_Id" : airline?.airlineId ?? "",
                      "Origin_Code" : departure?.departureCodeId ?? "",
                      "Destination_Code" : destination?.cityId ?? ""] as [String : Any]
        params["Return_Code"] = ""
        params["Start_Date"] = startTravelDate ?? ""
        params["End_Date"] = endTravelDate?.endTravelDateId ?? ""
        params["Transit_Mark"] = !isNonStop
        
        return params
    }
    
    func getAirTicketRequest(response: TKTInitResponse.TicketResponse) -> TKTSearchRequest {
        
        return TKTSearchRequest(service: response.serviceClassList.first,
                                identityType: response.identityTypeList.first,
                                journeyType: response.journeyTypeList.first,
                                airline: response.airlineList.first,
                                departure: response.departureCodeList.first,
                                destination: nil,
                                startTravelDate: response.startTravelDate,
                                endTravelDate: response.endTravelDateList.first,
                                returnCode:nil,
                                isNonStop: true)
    }
}
