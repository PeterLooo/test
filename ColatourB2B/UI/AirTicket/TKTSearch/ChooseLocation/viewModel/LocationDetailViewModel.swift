//
//  LocationDetailViewModel.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/7/9.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation

class LocationDetailViewModel {
    
    var country: TKTInitResponse.TicketResponse.Country?
    
    required init(countryInfo: TKTInitResponse.TicketResponse.Country) {
        self.country = countryInfo
    }
}
