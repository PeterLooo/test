//
//  AirTicketSearchProtocol.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2020/3/9.
//  Copyright © 2020 Colatour. All rights reserved.
//

protocol AirTicketSearchViewProtocol: BaseViewProtocol {
    func onBindAirTicketSearchInit(groupTourSearchInit: AirTicketSearchResponse)
    
}
protocol AirTicketSearchPresenterProtocol : BasePresenterProtocol {
    
    func getAirTicketSearchInit()
}

