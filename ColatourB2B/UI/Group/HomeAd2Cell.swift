//
//  HomeAd2Cell.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/21.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

class HomeAd2Cell: UITableViewCell {

    @IBOutlet weak var moduleText: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var top: NSLayoutConstraint!
        
    func setCell(viewModel: HomeAd2ViewCellViewModel){
        stackView.subviews.forEach { $0.removeFromSuperview() }
        
        moduleText.text = viewModel.moduleText
        top.constant = viewModel.topConstant!
        
        viewModel.subViewModels.forEach { (viewModel) in
            let view = HomeAd2View()
            view.setView(viewModel: viewModel)
            
            self.stackView.addArrangedSubview(view)
        }
    }
}
