//
//  BrickCell.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/9.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

protocol BrickCellProtocol: NSObjectProtocol {
    
    func onTouchBrick(countryInfo: AirTicketSearchResponse.CountryInfo)
    func onTouchBrick(airportInfo: AirTicketSearchResponse.AirInfo)
}

class BrickCell: UICollectionViewCell {
    
    @IBOutlet weak var brickName: UILabel!
    
    weak var delegate: BrickCellProtocol?
    
    private var countryInfo: AirTicketSearchResponse.CountryInfo?
    private var airportInfo: AirTicketSearchResponse.AirInfo?
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
    
    func setCellWith(airTicketInfo: AirTicketSearchResponse, searchType: SearchByType, row: Int) {
        
        self.searchType = searchType
        
        switch searchType {
        case .groupAir:
            let continent = airTicketInfo.groupAir?.continentList.filter { $0.isSelected == true }.first
            countryInfo = continent?.countryList[row]
            brickName.text = countryInfo?.country
            
        case .soto:
            ()
            
        case .lcc:
            let country = airTicketInfo.lCC?.countryList.filter { $0.isSelected == true }.first
            airportInfo = country?.airportList?[row]
            brickName.text = airportInfo?.text
        }
    }

    @objc func onTouchBrick() {
        
        switch searchType {
        case .groupAir:
            delegate?.onTouchBrick(countryInfo: countryInfo!)
            
        case .soto:
            ()
            
        case .lcc:
            delegate?.onTouchBrick(airportInfo: airportInfo!)
            
        default:
            ()
        }
    }
}
