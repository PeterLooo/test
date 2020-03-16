//
//  AirTicketSearchProtocol.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2020/3/9.
//  Copyright © 2020 Colatour. All rights reserved.
//

protocol AirTicketSearchViewProtocol: BaseViewProtocol {
    
    func onBindAirTicketSearchInit(tktSearchInit: TKTInitResponse)
    func onBindSotoAirSearchInit(sotoSearchInit: TKTInitResponse)
    //func onBindLccAirSearchInit(lccSearchInit: TKTInitResponse)
}

protocol AirTicketSearchPresenterProtocol : BasePresenterProtocol {
    
    func getAirTicketSearchInit()
    func getSotoAirSearchInit()
    //func getLccAirSearchInit()
}

