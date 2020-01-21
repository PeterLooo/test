//
//  GroupTourSearchRequest.swift
//  ColatourB2B
//
//  Created by M6853 on 2020/1/21.
//  Copyright © 2020 Colatour. All rights reserved.
//

class GroupTourSearchRequest: NSObject {
    var startTourDate: String?
    var tourDays: Int?
    var selectedRegionCode: KeyValue?
    var selectedDepartureCity: KeyValue?
    var selectedAirlineCode: KeyValue?
    var selectedTourType: KeyValue?
    var isBookingTour: Bool = true
}
