//
//  LccTicketRequest.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2020/3/11.
//  Copyright © 2020 Colatour. All rights reserved.
//


class LccTicketRequest: NSObject {
    
    var startTravelDate: String?
    var endTravelDate: String?
    var departure: TKTInitResponse.TicketResponse.City?
    var destination: TKTInitResponse.TicketResponse.City?
    var adultCount: Int = 1
    var childCount: Int = 0
    var infanCount: Int = 0
    var isSameAirline: Bool = true
    var isToAndFro: Bool = true
    
    convenience init(startTravelDate: String?,
                     endTravelDate: String?,
                     departure: TKTInitResponse.TicketResponse.City?,
                     destination: TKTInitResponse.TicketResponse.City?,
                     isSameAirline: Bool) {
        self.init()
        self.departure = departure
        self.destination = destination
        self.startTravelDate = startTravelDate
        self.endTravelDate = endTravelDate
        self.isSameAirline = isSameAirline
    }
    
    func getLccTicketRequest (reponse:LccResponse.LCCSearchInitialData) -> LccTicketRequest {
        return LccTicketRequest(startTravelDate: reponse.defaultStartDate, endTravelDate: reponse.defaultEndDate,  departure: nil, destination: nil, isSameAirline: true)
    }
    
    func getDictionary() -> [String : Any] {
        
        var params = ["Start_Date" : startTravelDate ?? "",
                      "End_Date" : endTravelDate ?? "",
                      "Origin_Code" : departure?.cityId ?? "",
                      "Origin_Name" : departure?.cityName ?? "",
                      "Return_Code" : destination?.cityId ?? "",
                      "Return_Name" : destination?.cityName ?? "",] as [String : Any]
        params["TripType_Id"] = isToAndFro == true ? "Round" : "OneWay"
        // 若選項為單程，則此欄位要是True
        params["Change_Aviation"] = isToAndFro == true ? !isSameAirline : true
        params["Adt_Cnt"] = adultCount
        params["Chd_Cnt"] = childCount
        params["Infant_Cnt"] = infanCount
        
        return params
    }
}
