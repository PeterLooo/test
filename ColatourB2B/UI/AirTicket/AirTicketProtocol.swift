//
//  AirTicketProtocol.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/6.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation
protocol AirTicketViewProtocol: BaseViewProtocol {
    
    func onBindAirMenu(menu: GroupMenuResponse)
}

protocol AirTicketPresenterProtocol: BasePresenterProtocol {
    
    func getAirMenu(toolBarType: ToolBarType)
}
