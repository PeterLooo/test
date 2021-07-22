//
//  AirPaxViewModel.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/7/9.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation

class AirPaxViewModel {
    
    var lccTicketRequest = LccTicketRequest()
    
    required init(lccTicketRequest: LccTicketRequest) {
        self.lccTicketRequest = lccTicketRequest
    }
}
