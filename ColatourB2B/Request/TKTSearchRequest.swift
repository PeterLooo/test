//
//  TKTSearchRequest.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2020/3/9.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation
class TKTSearchRequest: NSObject {
    
    var startTourDate: String?
    var selectedID: AirTicketSearchResponse.AirInfo?
    var selectedSitClass: AirTicketSearchResponse.AirInfo?
    var selectedAirlineCode: AirTicketSearchResponse.AirInfo?
    var selectedDateRange: AirTicketSearchResponse.AirInfo?
    var selectedTourWay: AirTicketSearchResponse.AirInfo?
    var selectedDeparture: AirTicketSearchResponse.AirInfo?
    var selectedDestinatione: AirTicketSearchResponse.AirInfo?
    var selectedBackDeparture: AirTicketSearchResponse.AirInfo?
    var isNonStop: Bool = true
    
    func getDictionary() -> [String:Any] {
        var params = ["Tour_Date": "\(startTourDate ?? "")"
            , "Sit_Class": selectedSitClass?.value ?? ""
            , "Airline_Code": selectedAirlineCode?.value ?? ""
            , "ID": selectedID?.value ?? ""
            , "Date_Raneg": selectedDateRange?.value ?? ""
            , "Tour_Way": selectedTourWay?.value ?? ""
            , "Departure": selectedDeparture?.value ?? ""
            
            , "Non_Stop_Mark": isNonStop ] as [String : Any]
        params["Destination"] =  selectedDestinatione?.value ?? ""
        params["Back_Departure"] =  selectedBackDeparture?.value ?? ""
        return params
    }
}
