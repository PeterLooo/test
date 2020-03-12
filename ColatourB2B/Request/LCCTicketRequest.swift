//
//  LCCSearchRequest.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2020/3/11.
//  Copyright © 2020 Colatour. All rights reserved.
//


class LCCTicketRequest: NSObject {
    
    var startTourDate: String?
    var endTourDate: String?
    var selectedID: AirTicketSearchResponse.AirInfo?
    var selectedSitClass: AirTicketSearchResponse.AirInfo?
    var selectedAirlineCode: AirTicketSearchResponse.AirInfo?
    var selectedDeparture: AirTicketSearchResponse.AirInfo?
    var selectedDestinatione: AirTicketSearchResponse.AirInfo?
    var adultCount: Int = 1
    var childCount: Int = 0
    var infanCount: Int = 0
    var isToAndFro: Bool = true
    var isSameAirline: Bool = true
}
