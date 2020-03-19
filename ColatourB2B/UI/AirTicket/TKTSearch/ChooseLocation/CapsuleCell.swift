//
//  CapsuleCell.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/9.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

protocol CapsuleCellProtocol:NSObjectProtocol {
    
    func onTouchCapsule(areaInfo: TKTInitResponse.TicketResponse.Area)
    //func onTouchCapsule(countryInfo: AirTicketSearchResponse.CountryInfo)
}

class CapsuleCell: UICollectionViewCell {
    
    @IBOutlet weak var capsuleName: UILabel!
    
    weak var delegate: CapsuleCellProtocol?
    
    private var areaInfo: TKTInitResponse.TicketResponse.Area?
    //private var countryInfo: AirTicketSearchResponse.CountryInfo?
    private var searchType: SearchByType?
    private var selectedSign: Bool?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let ges = UITapGestureRecognizer(target: self, action: #selector(onTouchCapsule))
        capsuleName.isUserInteractionEnabled = true
        capsuleName.addGestureRecognizer(ges)
    }
    
    func setCellWith(airTicketInfo: TKTInitResponse.TicketResponse, searchType: SearchByType, row: Int) {
        
        self.searchType = searchType
        
        switch searchType {
        case .airTkt:
            areaInfo = airTicketInfo.areaList[row]
            capsuleName.text = areaInfo?.areaName
            selectedSign = areaInfo?.isSelected
            
        case .soto:
            ()
            
        case .lcc:
            ()
//            countryInfo = airTicketInfo.lCC?.countryList[row]
//            capsuleName.text = countryInfo?.country
//            selectedSign = countryInfo?.isSelected
        }
        
        switch selectedSign {
        case true:
            capsuleName.textColor = .white
            capsuleName.backgroundColor = UIColor(named: "通用綠")
            capsuleName.setBorder(width: 1, radius: 14, color: UIColor(named: "通用綠"))
            capsuleName.clipsToBounds = true
            
        case false:
            capsuleName.textColor = .black
            capsuleName.backgroundColor = .white
            capsuleName.setBorder(width: 1, radius: 14, color: UIColor(named: "分隔線"))
            
        default:
            ()
        }
    }
    
    @objc func onTouchCapsule() {

        switch searchType {
        case .airTkt:
            delegate?.onTouchCapsule(areaInfo: areaInfo!)
            
        case .lcc:
            () //delegate?.onTouchCapsule(countryInfo: countryInfo!)
            
        default:
            ()
        }
    }
}