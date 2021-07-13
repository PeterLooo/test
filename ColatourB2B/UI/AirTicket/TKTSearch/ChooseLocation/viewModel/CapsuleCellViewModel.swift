//
//  CapsuleCellViewModel.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/7/9.
//  Copyright © 2021 Colatour. All rights reserved.
//
import Foundation

class CapsuleCellViewModel {
    
    var onTouchCapsule: ((_ areaInfo: TKTInitResponse.TicketResponse.Area?,_ countryInfo: TKTInitResponse.TicketResponse.Country?,_ searchType: SearchByType?) -> ())?
    
    var areaInfo: TKTInitResponse.TicketResponse.Area?
    var countryInfo: TKTInitResponse.TicketResponse.Country?
    var searchType: SearchByType?
    var selectedSign: Bool?
    
    required init(airTicketInfo: TKTInitResponse.TicketResponse?, lccAirInfo: LccResponse.LCCSearchInitialData?, searchType: SearchByType, row: Int) {
        
        self.searchType = searchType
        
        switch searchType {
        case .airTkt:
            areaInfo = airTicketInfo?.areaList[row]
            selectedSign = areaInfo?.isSelected
            
        case .soto:
            ()
            
        case .lcc:
            countryInfo = lccAirInfo?.countryList[row]
            selectedSign = countryInfo?.isSelected
        }
    }
    
    func onTouchToCapsule() {
        
        switch searchType {
        case .airTkt:
            onTouchCapsule?(areaInfo, nil, .airTkt)
            
        case .lcc:
            onTouchCapsule?(nil, countryInfo, .lcc)
            
        default:
            ()
        }
    }
}
