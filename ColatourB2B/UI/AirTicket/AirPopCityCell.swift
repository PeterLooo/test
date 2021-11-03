//
//  AirPopCityCell.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2020/3/13.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

class AirPopCityCell: UITableViewCell {
    
    @IBOutlet weak var moduleTitle: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    func setCell(viewModel: AirPopCityCellViewModel) {
        
        self.stackView.subviews.forEach{$0.removeFromSuperview()}
        
        self.moduleTitle.text = viewModel.moduleTitle
        scrollViewHeight.constant = screenWidth * (1 / 1.73) + 18
        
        viewModel.subViewViewModels.forEach { subViewViewModel in
            let view = AirPopCityView()
            view.setView(viewModel: subViewViewModel)
            stackView.addArrangedSubview(view)
        }
    }
}
