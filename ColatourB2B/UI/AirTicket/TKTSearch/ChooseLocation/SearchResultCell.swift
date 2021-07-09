//
//  SearchResultCell.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/11.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

class SearchResultCell: UICollectionViewCell {
    
    @IBOutlet weak var resultName: UILabel!
    
    var viewModel: SearchResultCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let ges = UITapGestureRecognizer(target: self, action: #selector(self.onTouchCity))
        resultName.isUserInteractionEnabled = true
        resultName.addGestureRecognizer(ges)
    }
    
    func setCellWith(viewModel: SearchResultCellViewModel) {
        self.viewModel = viewModel
        
        let attributedString = NSMutableAttributedString(string: viewModel.cityInfo?.cityName ?? "")
        // 得到全部匹配關鍵字的Range<Index>
        let ranges = viewModel.cityInfo?.cityName?.ranges(of: viewModel.searchText ?? "")
        var nsRanges: [NSRange] = []
        var nsRange = NSRange()
        
        // 把Range<Index>轉型成NSRange
        ranges?.forEach({ (range) in
            nsRange = viewModel.cityInfo?.cityName?.nsRange(from: range) ?? nsRange
            nsRanges.append(nsRange)
        })
        
        // 把所有關鍵字的NSRange變色
        nsRanges.forEach { (nsRange) in
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorHexUtil.hexColor(hex: "#19bf62"), range: nsRange)
        }
        
        resultName.attributedText = attributedString
    }
    
    @objc func onTouchCity() {
        
        viewModel?.onTouchToCity()
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
