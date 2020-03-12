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
    
    convenience init(startTourDate: String?,
                     selectedID: AirTicketSearchResponse.AirInfo?,
                     selectedSitClass: AirTicketSearchResponse.AirInfo?,
                     selectedAirlineCode: AirTicketSearchResponse.AirInfo?,
                     selectedDateRange: AirTicketSearchResponse.AirInfo?,
                     selectedTourWay: AirTicketSearchResponse.AirInfo?,
                     selectedDeparture: AirTicketSearchResponse.AirInfo?,
                     selectedDestinatione: AirTicketSearchResponse.AirInfo?,
                     selectedBackDeparture: AirTicketSearchResponse.AirInfo?,
                     isNonStop: Bool) {
        self.init()
        self.startTourDate = startTourDate
        self.selectedID = selectedID
        self.selectedSitClass = selectedSitClass
        self.selectedAirlineCode = selectedAirlineCode
        self.selectedDateRange = selectedDateRange
        self.selectedTourWay = selectedTourWay
        self.selectedDestinatione = selectedDestinatione
        self.selectedDeparture = selectedDeparture
        self.selectedBackDeparture = selectedBackDeparture
        self.isNonStop = isNonStop
    }
    
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
    
    func getGroupTicketRequest(response: AirTicketSearchResponse) -> TKTSearchRequest {
        return TKTSearchRequest(startTourDate: response.minDate,
                                selectedID: response.identity.first,
                                selectedSitClass: response.sitClass.first,
                                selectedAirlineCode: response.groupAir?.airline.first,
                                selectedDateRange: response.daterange.first,
                                selectedTourWay: response.groupAir?.tourType.first,
                                selectedDeparture: response.groupAir?.departure.first,
                                selectedDestinatione: nil,
                                selectedBackDeparture: nil,
                                isNonStop: true)
    }
    
    func getSOTOTicketRequest(response: AirTicketSearchResponse) -> TKTSearchRequest {
        return TKTSearchRequest(startTourDate: response.minDate,
                                selectedID: response.identity.first,
                                selectedSitClass: response.sitClass.first,
                                selectedAirlineCode: response.sOTOTicket?.airline.first,
                                selectedDateRange: response.daterange.first,
                                selectedTourWay: response.sOTOTicket?.tourType.first,
                                selectedDeparture: response.sOTOTicket?.departure.first,
                                selectedDestinatione: response.sOTOTicket?.arrivals.first,
                                selectedBackDeparture: nil,
                                isNonStop: true)
    }
}
