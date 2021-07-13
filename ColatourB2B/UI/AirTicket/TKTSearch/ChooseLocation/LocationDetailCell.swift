//
//  LocationDetailCell.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/16.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

class LocationDetailCell: UICollectionViewCell {
    
    @IBOutlet weak var cityName: UILabel!
    
    var onTouchCity: ((_ cityInfo: TKTInitResponse.TicketResponse.City?) -> ())?
    var viewModel: LocationDetailCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
        let ges = UITapGestureRecognizer(target: self, action: #selector(self.onTouchToCity))
        cityName.isUserInteractionEnabled = true
        cityName.addGestureRecognizer(ges)
    }
    
    func setCell(viewModel: LocationDetailCellViewModel) {
        self.viewModel = viewModel
        
        cityName.textColor = .black
        cityName.backgroundColor = .white
        cityName.setBorder(width: 1, radius: 5, color: UIColor(named: "分隔線"))
        cityName.text = viewModel.cityInfo?.cityName
    }
    
    @objc func onTouchToCity() {
        
        onTouchCity?(viewModel?.cityInfo)
    }
}
