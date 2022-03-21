//
//  GroupTourSearchKeywordAndTourCodeRequest.swift
//  ColatourB2B
//
//  Created by M6853 on 2020/1/21.
//  Copyright © 2020 Colatour. All rights reserved.
//

class GroupTourSearchKeywordAndTourCodeRequest: NSObject {
    var keywordOrTourCode: String? {
        didSet{
            self.keywordOrTourCodeValueChange?()
        }
    }
    var selectedDepartureCity: GroupTourSearchInitResponse.DepartureCity?
    var keywordOrTourCodeSearchType: KeywordOrTourCodeSearchType!
    
    var keywordOrTourCodeValueChange: (()->())?
    
    enum KeywordOrTourCodeSearchType {
        case keyword
        case tourCode
    }
    
    func getDictionary() -> [String:Any] {
        var searchType: String!
        switch keywordOrTourCodeSearchType! {
        case .keyword:
            searchType = "關鍵字"
        case .tourCode:
            searchType = "團號"
        }
        
        let params = ["Search_Type": searchType!
            , "Keyword": keywordOrTourCode ?? ""
            , "Departure_City": selectedDepartureCity?.departureCode ?? ""] as [String : Any]
        
        return params
    }
}
