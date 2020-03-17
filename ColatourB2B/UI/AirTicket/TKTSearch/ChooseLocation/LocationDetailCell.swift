//
//  LocationDetailCell.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/16.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

protocol LocationDetailCellProtocol: NSObjectProtocol {
    
    func onTouchCity(cityInfo: TKTInitResponse.TicketResponse.City)
}

class LocationDetailCell: UICollectionViewCell {
    
    @IBOutlet weak var cityName: UILabel!
    
    weak var delegate: LocationDetailCellProtocol?
    
    private var cityInfo: TKTInitResponse.TicketResponse.City?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let ges = UITapGestureRecognizer(target: self, action: #selector(self.onTouchCity))
        cityName.isUserInteractionEnabled = true
        cityName.addGestureRecognizer(ges)
        
        cityName.textColor = .black
        cityName.backgroundColor = .white
        cityName.setBorder(width: 1, radius: 5, color: UIColor(named: "分隔線"))
    }
    
    func setCellWith(cityInfo: TKTInitResponse.TicketResponse.City) {
        
        self.cityInfo = cityInfo
        cityName.text = cityInfo.cityName
    }
    
    @objc func onTouchCity() {
        
        delegate?.onTouchCity(cityInfo: cityInfo!)
    }
}
