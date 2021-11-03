//
//  LccAirCellViewModel.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/7/7.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation

class LccAirCellViewModel {
    
    var isToAndFro: Bool?
    var sameAirlineSwitch: Bool?
    var departure: String?
    var departureColor: String?
    var destination: String?
    var destinationColor: String?
    var tourDate: String?
    var paxInfo: String?
    
    var onTouchLccDate: (() -> ())?
    var onTouchAirlineSwitch: (() -> ())?
    var onTouchPax: (() -> ())?
    var onTouchLccRequestByPerson: (() -> ())?
    var onTouchLccSearch: (() -> ())?
    var onTouchLccDeparture: (() -> ())?
    var onTouchLccDestination: (() -> ())?
    
    var onTouchRadio: ((_ isToAndFor: Bool) -> ())?
    
    required init(lccInfo: LccTicketRequest) {
        self.isToAndFro = lccInfo.isToAndFro
        self.departure = lccInfo.departure == nil ? "輸入 國家/城市/機場代碼" : lccInfo.departure?.cityName
        self.departureColor = lccInfo.departure == nil ? "預設文字" : "標題黑"
        self.destination = lccInfo.destination == nil ? "輸入 國家/城市/機場代碼" : lccInfo.destination?.cityName
        self.destinationColor = lccInfo.destination == nil ? "預設文字" : "標題黑"
        self.tourDate = lccInfo.isToAndFro ? "\(lccInfo.startTravelDate ?? "") ~ \(lccInfo.endTravelDate ?? "")" : "\(lccInfo.startTravelDate ?? "")"
        self.sameAirlineSwitch = lccInfo.isSameAirline
        self.paxInfo = "\(lccInfo.adultCount) 大人 \(lccInfo.childCount) 小孩 \(lccInfo.infanCount) 嬰兒"
    }
    
    func onTouchRadioButton(tag: Int) {
        
        switch tag {
        case 0:
            onTouchRadio?(true)
        case 1:
            onTouchRadio?(false)
        default:
            ()
        }
    }
}
