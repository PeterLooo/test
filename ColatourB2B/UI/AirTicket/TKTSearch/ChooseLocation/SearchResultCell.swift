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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCellWith(text: String) {
        
        resultName.text = text
    }
}
