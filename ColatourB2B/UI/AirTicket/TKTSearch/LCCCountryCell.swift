//
//  LCCCountryCell.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/9.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

protocol LCCCountryCellProtocol:NSObjectProtocol {
    
    func onTouchConutry(countryInfo: AirTicketSearchResponse.CountryInfo)
}

class LCCCountryCell: UICollectionViewCell {
    
    @IBOutlet weak var countryName: UILabel!
    
    weak var delegate: LCCCountryCellProtocol?
    
    private var countryInfo: AirTicketSearchResponse.CountryInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let ges = UITapGestureRecognizer(target: self, action: #selector(self.onTouchCountry))
        countryName.isUserInteractionEnabled = true
        countryName.addGestureRecognizer(ges)
    }
    
    func setCellWith(countryInfo: AirTicketSearchResponse.CountryInfo) {
        
        self.countryInfo = countryInfo
        countryName.text = countryInfo.country
        
        switch countryInfo.isSelected {
        case true:
            countryName.textColor = .white
            countryName.backgroundColor = UIColor(named: "通用綠")
            countryName.setBorder(width: 1, radius: 14, color: UIColor(named: "通用綠"))
            countryName.clipsToBounds = true
            
        case false:
            countryName.textColor = .black
            countryName.backgroundColor = .white
            countryName.setBorder(width: 1, radius: 14, color: UIColor(named: "分隔線"))
        }
    }
    
    @objc func onTouchCountry() {
        
        self.delegate?.onTouchConutry(countryInfo: self.countryInfo!)
    }
}
