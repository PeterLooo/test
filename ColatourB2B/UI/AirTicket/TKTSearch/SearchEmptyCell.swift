//
//  SearchEmptyCell.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/11.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

class SearchEmptyCell: UICollectionViewCell {

    @IBOutlet weak var resultHint: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setEmptyHint() {
        
        resultHint.text = "很抱歉，沒有查到您要搜尋的"
    }
}
