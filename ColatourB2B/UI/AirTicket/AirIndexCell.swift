//
//  AirIndexCell.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2020/3/13.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

class AirIndexCell: UITableViewCell {
    
    @IBOutlet weak var stackView: UIStackView!
    
    func setCell(viewModel: AirIndexCellViewModel) {
        
        self.stackView.subviews.forEach{$0.removeFromSuperview()}
        
        viewModel.subViewViewModels.forEach { subViewViewModel in
            let view = AirIndexView()
            view.setView(viewModel: subViewViewModel)
            stackView.addArrangedSubview(view)
        }
    }
}
