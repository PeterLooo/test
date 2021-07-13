//
//  SearchResultCellViewModel.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/7/9.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation

class SearchResultCellViewModel {
    
    var onTouchCity: ((_ cityInfo: TKTInitResponse.TicketResponse.City?, _ searchType: SearchByType?) -> ())?
    
    var cityInfo: TKTInitResponse.TicketResponse.City?
    var searchType: SearchByType?
    var searchText: String?
    
    required init(cityInfo: TKTInitResponse.TicketResponse.City, searchText: String, searchType: SearchByType) {
        self.cityInfo = cityInfo
        self.searchType = searchType
        self.searchText = searchText
    }
    
    func  onTouchToCity() {
        onTouchCity?(cityInfo, searchType)
    }
}
