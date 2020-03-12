//
//  LCCAirportCell.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/9.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

protocol LCCAirportCellProtocol: NSObjectProtocol {
    
    func onTouchAirport(airportInfo: AirTicketSearchResponse.AirInfo)
}

class LCCAirportCell: UICollectionViewCell {
    
    @IBOutlet weak var airportName: UILabel!
    
    weak var delegate: LCCAirportCellProtocol?
    
    private var airportInfo: AirTicketSearchResponse.AirInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let ges = UITapGestureRecognizer(target: self, action: #selector(self.onTouchAirport))
        airportName.isUserInteractionEnabled = true
        airportName.addGestureRecognizer(ges)
    }
    
    func setCellWith(airportInfo: AirTicketSearchResponse.AirInfo) {
        
        self.airportInfo = airportInfo
        airportName.text = airportInfo.text
        airportName.textColor = .black
        airportName.backgroundColor = .white
        airportName.setBorder(width: 1, radius: 5, color: UIColor(named: "分隔線"))
    }

    @objc func onTouchAirport() {
        
        self.delegate?.onTouchAirport(airportInfo: self.airportInfo!)
    }
}
