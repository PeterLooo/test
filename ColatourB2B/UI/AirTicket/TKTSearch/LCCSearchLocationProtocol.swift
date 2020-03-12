//
//  LCCSearchLocationProtocol.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/12.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation

protocol LCCSearchLocationViewProtocol: BaseViewProtocol {
    
    func onBindLCCInfo(response: AirTicketSearchResponse)
    func onBindSearchResult()//result: )
}

protocol LCCSearchLocationPresenterProtocol: BasePresenterProtocol {
    
    func getSearchResult()
}
