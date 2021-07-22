//
//  AirTktCellViewModel.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/7/7.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation

class AirTktCellViewModel {
    
    var info: TKTSearchRequest?
    var identity: String?
    var sitClass: String?
    var airline: String?
    var startDate: String?
    var dateRange: String?
    var tourWay: String?
    var departure: String?
    var destination: String?
    var destinationColor: String?
    var backDeparture: String?
    var backDepartureColor: String?
    var isNonStop: Bool?
    var backViewHidden: Bool?
    
    var onTouchSelection: ((_ selection: TKTInputFieldType, _ searchType: SearchByType) -> ())?
    var onTouchArrival: ((_ arrival: ArrivalType, _ searchType: SearchByType) -> ())?
    var onTouchDate: ((_ searchType: SearchByType) -> ())?
    var onTouchNonStop: ((_ searchType: SearchByType) -> ())?
    var onTouchSearch: ((_ searchType: SearchByType) -> ())?
    
    required init(info: TKTSearchRequest) {
        self.info = info
        self.identity = info.identityType
        self.sitClass = info.service?.serviceName
        self.airline = info.airline?.airlineName
        self.startDate = info.startTravelDate
        self.dateRange = info.endTravelDate?.endTravelDateName
        self.tourWay = info.journeyType
        self.departure = info.departure?.departureCodeName
        self.destination = info.destination == nil ? "輸入 目的城市/機場代碼" : info.destination?.cityName
        self.destinationColor = info.destination == nil ?  "預設文字" : "標題黑"
        self.backDeparture = info.returnCode == nil ? "輸入 目的城市/機場代碼": info.returnCode?.cityName
        self.backDepartureColor = info.returnCode == nil ? "預設文字" : "標題黑"
        self.isNonStop = info.isNonStop
        self.backViewHidden = !(info.journeyType == "雙程" || info.journeyType == "環遊")
    }
    
    func onTouchToSelection(tag: Int) {
        
        switch tag {
        case 0:
            onTouchSelection?(.id, .airTkt)
        case 1:
            onTouchSelection?(.sitClass, .airTkt)
        case 2:
            onTouchSelection?(.airlineCode, .airTkt)
        case 3:
            onTouchDate?(.airTkt)
        case 4:
            onTouchSelection?(.dateRange, .airTkt)
        case 5:
            onTouchSelection?(.tourType, .airTkt)
        case 6:
            onTouchSelection?(.departureCity, .airTkt)
        case 7:
            onTouchNonStop?(.airTkt )
        default:
            ()
        }
    }
    
    func onTouchToArrvial() {
        onTouchArrival?(.departureCity, .airTkt)
    }
    
    func onTouchToBack() {
        onTouchArrival?(.backStartingCity, .airTkt)
    }
    
    func onTouchToSearch() {
        onTouchSearch?(.airTkt)
    }
}
