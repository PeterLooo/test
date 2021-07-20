//
//  SearchResultCell.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/11.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

class SearchResultCell: UICollectionViewCell {
    
    @IBOutlet weak var resultName: UILabel!
    
    var viewModel: SearchResultCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let ges = UITapGestureRecognizer(target: self, action: #selector(self.onTouchCity))
        resultName.isUserInteractionEnabled = true
        resultName.addGestureRecognizer(ges)
    }
    
    func setCellWith(viewModel: SearchResultCellViewModel) {
        self.viewModel = viewModel
        
        resultName.attributedText = viewModel.getNsRanges()
    }
    
    @objc func onTouchCity() {
        
        viewModel?.onTouchToCity()
    }
}
