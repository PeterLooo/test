//
//  BrickCellViewModel.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/7/9.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation

class BrickCellViewModel  {
    
    var onTouchBrick: ((_ countryInfo: TKTInitResponse.TicketResponse.Country?,_ cityInfo: TKTInitResponse.TicketResponse.City?,_ searchType: SearchByType?) -> ())?
    
    var countryInfo: TKTInitResponse.TicketResponse.Country?
    var cityInfo: TKTInitResponse.TicketResponse.City?
    var searchType: SearchByType?
    
    required init(countryInfo: TKTInitResponse.TicketResponse.Country?, cityInfo: TKTInitResponse.TicketResponse.City?, searchType: SearchByType) {
        
        self.searchType = searchType
        self.countryInfo = countryInfo
        self.cityInfo = cityInfo
    }
    
    func onTouchToBrick() {
        
        switch searchType {
        case .airTkt:
            onTouchBrick?(countryInfo, nil, .airTkt)
            
        case .lcc:
            onTouchBrick?(nil, cityInfo, .lcc)
            
        default:
            ()
        }
    }
}
