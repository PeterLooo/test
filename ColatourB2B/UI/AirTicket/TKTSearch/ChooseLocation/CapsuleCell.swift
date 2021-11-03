//
//  CapsuleCell.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/9.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

class CapsuleCell: UICollectionViewCell {
    
    @IBOutlet weak var capsuleName: UILabel!
    
    var viewModel: CapsuleCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let ges = UITapGestureRecognizer(target: self, action: #selector(onTouchCapsule))
        capsuleName.isUserInteractionEnabled = true
        capsuleName.addGestureRecognizer(ges)
    }
    
    func setCell(viewModel: CapsuleCellViewModel) {
        self.viewModel = viewModel
        
        switch viewModel.searchType {
        case .airTkt:
            capsuleName.text = viewModel.areaInfo?.areaName
            
        case .soto:
            ()
            
        case .lcc:
            capsuleName.text = viewModel.countryInfo?.countryName
            
        default :
            ()
        }
        
        switch viewModel.selectedSign {
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
        
        viewModel?.onTouchToCapsule()
    }
}
