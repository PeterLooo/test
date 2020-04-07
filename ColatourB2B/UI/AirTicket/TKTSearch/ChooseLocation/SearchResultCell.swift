//
//  SearchResultCell.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/11.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

protocol SearchResultCellProtocol: NSObjectProtocol {
    
    func onTouchCity(cityInfo: TKTInitResponse.TicketResponse.City, searchType: SearchByType)
}

class SearchResultCell: UICollectionViewCell {
    
    @IBOutlet weak var resultName: UILabel!
    
    weak var delegate: SearchResultCellProtocol?
    
    private var cityInfo: TKTInitResponse.TicketResponse.City?
    private var searchType: SearchByType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let ges = UITapGestureRecognizer(target: self, action: #selector(self.onTouchCity))
        resultName.isUserInteractionEnabled = true
        resultName.addGestureRecognizer(ges)
    }
    
    func setCellWith(cityInfo: TKTInitResponse.TicketResponse.City, searchText: String, searchType: SearchByType) {
        
        self.cityInfo = cityInfo
        self.searchType = searchType
        
        let attributedString = NSMutableAttributedString(string: cityInfo.cityName!)
        // 得到全部匹配關鍵字的Range<Index>
        let ranges = cityInfo.cityName!.ranges(of: searchText)
        var nsRanges: [NSRange] = []
        var nsRange = NSRange()
        
        // 把Range<Index>轉型成NSRange
        ranges.forEach({ (range) in
            nsRange = cityInfo.cityName!.nsRange(from: range)
            nsRanges.append(nsRange)
        })
        
        // 把所有關鍵字的NSRange變色
        nsRanges.forEach { (nsRange) in
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorHexUtil.hexColor(hex: "#19bf62"), range: nsRange)
        }
        
        resultName.attributedText = attributedString
    }
    
    @objc func onTouchCity() {
        
        delegate?.onTouchCity(cityInfo: cityInfo!, searchType: searchType!)
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
