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
        let theRange = NSString(string: cityInfo.cityName!).range(of: searchText)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorHexUtil.hexColor(hex: "#19bf62"), range: theRange)
        resultName.attributedText = attributedString
    }
    
    @objc func onTouchCity() {
        
        delegate?.onTouchCity(cityInfo: cityInfo!, searchType: searchType!)
    }
}
