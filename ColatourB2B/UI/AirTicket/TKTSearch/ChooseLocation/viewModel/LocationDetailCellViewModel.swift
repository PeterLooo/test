//
//  LocationDetailCellViewModel.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/7/9.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation

class LocationDetailCellViewModel {
    
    var cityInfo: TKTInitResponse.TicketResponse.City?
    
    required init(cityInfo: TKTInitResponse.TicketResponse.City) {
        self.cityInfo = cityInfo
    }
}
