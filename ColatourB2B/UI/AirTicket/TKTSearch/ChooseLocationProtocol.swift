//
//  ChooseLocationProtocol.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/12.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation

protocol ChooseLocationViewProtocol: BaseViewProtocol {
    
    func onBindAirTicketInfo(response: AirTicketSearchResponse, searchType: SearchByType)
    func onBindSearchResult()//result: )
}

protocol ChooseLocationPresenterProtocol: BasePresenterProtocol {
    
    func getSearchResult()
}
