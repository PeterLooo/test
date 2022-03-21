//
//  HomeAd1Cell.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/20.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

class HomeAd1Cell: UITableViewCell {
    @IBOutlet weak var moduleTitle: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    func setCell(viewModel: HomeAd1CellViewModel){
        self.stackView.subviews.forEach{$0.removeFromSuperview()}
        self.moduleTitle.text = viewModel.moduleTitle
        scrollViewHeight.constant = (screenWidth / 2.20) / 0.9
        viewModel.subViewViewModels.forEach { (viewModel) in
            let view = HomeAd1View()
            view.setView(viewModel: viewModel)
            
            self.stackView.addArrangedSubview(view)
        }
    }
}
