//
//  BrickCell.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/9.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

protocol BrickCellProtocol: NSObjectProtocol {
    
    func onTouchBrick(countryInfo: TKTInitResponse.TicketResponse.Country?, cityInfo: TKTInitResponse.TicketResponse.City?, searchType: SearchByType)
}

class BrickCell: UICollectionViewCell {
    
    @IBOutlet weak var brickName: UILabel!
    
    weak var delegate: BrickCellProtocol?
    
    private var countryInfo: TKTInitResponse.TicketResponse.Country?
    private var cityInfo: TKTInitResponse.TicketResponse.City?
    private var searchType: SearchByType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let ges = UITapGestureRecognizer(target: self, action: #selector(self.onTouchBrick))
        brickName.isUserInteractionEnabled = true
        brickName.addGestureRecognizer(ges)
        
        brickName.textColor = .black
        brickName.backgroundColor = .white
        brickName.setBorder(width: 1, radius: 5, color: UIColor(named: "分隔線"))
    }
    
    func setCellWith(countryInfo: TKTInitResponse.TicketResponse.Country?, cityInfo: TKTInitResponse.TicketResponse.City?, searchType: SearchByType) {
        
        self.searchType = searchType
        self.countryInfo = countryInfo
        self.cityInfo = cityInfo
        
        switch searchType {
        case .airTkt:
            brickName.text = countryInfo?.countryName
            
        case .lcc:
            brickName.text = cityInfo?.cityName
            
        default:
            ()
        }
    }
    
    @objc func onTouchBrick() {
        
        switch searchType {
        case .airTkt:
            delegate?.onTouchBrick(countryInfo: countryInfo!, cityInfo: nil, searchType: .airTkt)
            
        case .lcc:
            delegate?.onTouchBrick(countryInfo: nil, cityInfo: cityInfo!, searchType: .lcc)
            
        default:
            ()
        }
    }
}
