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
    
    weak var delegate: HomeAd1CellProtocol?
    
    func setCell(item:IndexResponse.Module, isLastSection: Bool, needLogoImage:Bool){
        self.stackView.subviews.forEach { $0.removeFromSuperview() }
        moduleText.text = item.moduleText
        
        item.moduleItemList.forEach { (module) in
            let view = HomeAd2View()
            view.setView(item: module, isLast: (isLastSection) ? item.moduleItemList.last == module : false, needLogoImage: needLogoImage)
            view.delegate = self
            self.stackView.addArrangedSubview(view)
        }
    }
    
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

extension HomeAd2Cell : HomeAd1ViewProcotol {
    func onTouchHotelAdItem(adItem: IndexResponse.ModuleItem) {
        self.delegate?.onTouchItem(adItem: adItem)
    }
}
