//
//  GroupTourSearchKeywordAndTourCodeRequest.swift
//  ColatourB2B
//
//  Created by M6853 on 2020/1/21.
//  Copyright © 2020 Colatour. All rights reserved.
//

class GroupTourSearchKeywordAndTourCodeRequest: NSObject {
    var keywordOrTourCode: String?
    var selectedDepartureCity: DepartureCity?
    var keywordOrTourCodeSearchType: KeywordOrTourCodeSearchType?
    
    enum KeywordOrTourCodeSearchType {
        case keyword
        case tourCode
    }
}
