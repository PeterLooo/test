//
//  BrickCell.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/9.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

class BrickCell: UICollectionViewCell {
    
    @IBOutlet weak var brickName: UILabel!
    
    var viewModel: BrickCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let ges = UITapGestureRecognizer(target: self, action: #selector(self.onTouchBrick))
        brickName.isUserInteractionEnabled = true
        brickName.addGestureRecognizer(ges)
        
        brickName.textColor = .black
        brickName.backgroundColor = .white
        brickName.setBorder(width: 1, radius: 5, color: UIColor(named: "分隔線"))
    }
    
    func setCell(viewModel: BrickCellViewModel) {
        self.viewModel = viewModel
        
        switch viewModel.searchType {
        case .airTkt:
            brickName.text = viewModel.countryInfo?.countryName
            
        case .lcc:
            brickName.text = viewModel.cityInfo?.cityName
            
        default:
            ()
        }
    }
    
    @objc func onTouchBrick() {
        viewModel?.onTouchToBrick()
    }
}
