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
    
    func getNsRanges()  -> NSMutableAttributedString {
        
        let attributedString = NSMutableAttributedString(string: cityInfo?.cityName ?? "")
        var nsRanges: [NSRange] = []
        var nsRange = NSRange()
        // 得到全部匹配關鍵字的Range<Index>
        let ranges = cityInfo?.cityName?.ranges(of: searchText ?? "")
        // 把Range<Index>轉型成NSRange
        ranges?.forEach({ (range) in
            nsRange = cityInfo?.cityName?.nsRange(from: range) ?? nsRange
            nsRanges.append(nsRange)
        })
        
        // 把所有關鍵字的NSRange變色
        nsRanges.forEach { (nsRange) in
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorHexUtil.hexColor(hex: "#19bf62"), range: nsRange)
        }
        return attributedString
    }
    
    func  onTouchToCity() {
        onTouchCity?(cityInfo, searchType)
    }
}

extension String {
    
    func ranges(of substring: String, options: CompareOptions = [], locale: Locale? = nil) -> [Range<Index>] {
        var ranges: [Range<Index>] = []
        while let range = range(of: substring, options: options, range: (ranges.last?.upperBound ?? self.startIndex)..<self.endIndex, locale: locale) {
            ranges.append(range)
        }
        return ranges
    }
    
    func nsRange(from range: Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: utf16)
        let to = range.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from!),length: utf16.distance(from: from!, to: to!))
    }
}
