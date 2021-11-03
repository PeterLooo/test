//
//  SotoAirCellViewModel.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/7/7.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation

class SotoAirCellViewModel {
    
    var identity: String?
    var sitClass: String?
    var airline: String?
    var startDate: String?
    var dateRange: String?
    var tourWay: String?
    var departure: String?
    var destination: String?
    var isNonStop: Bool?
    
    var onTouchSelection: ((_ selection: TKTInputFieldType, _ searchType: SearchByType) -> ())?
    var onTouchDate: ((_ searchType: SearchByType) -> ())?
    var onTouchNonStop: ((_ searchType: SearchByType) -> ())?
    var onTouchSearch: ((_ searchType: SearchByType) -> ())?
    
    required init (info: SotoTicketRequest) {
        self.identity = info.identityType
        self.sitClass = info.service?.serviceName
        self.airline = info.airline?.airlineName
        self.startDate = info.startTravelDate
        self.dateRange = info.endTravelDate?.endTravelDateName
        self.tourWay = info.journeyType
        self.departure = info.departure?.departureCodeName
        self.destination = info.destination?.destinationCodeName
        self.isNonStop = info.isNonStop
    }
    
    func onTouchTopSelection(tag: Int) {
        switch tag {
        case 0:
            onTouchSelection?(.id, .soto)
        case 1:
            onTouchSelection?(.sitClass, .soto)
        case 2:
            onTouchSelection?(.airlineCode, .soto)
        case 3:
            onTouchDate?(.soto)
        case 4:
            onTouchSelection?(.dateRange, .soto)
        case 5:
            onTouchSelection?(.tourType, .soto)
        case 6:
            onTouchSelection?(.departureCity, .soto)
        case 7:
            onTouchNonStop?(.soto)
        default:
            ()
        }
    }
    
    func onTouchArrvial() {
        onTouchSelection?(.sotoArrival, .soto)
    }
    
    func onTouchToSearch() {
        onTouchSearch?(.soto)
    }
}
