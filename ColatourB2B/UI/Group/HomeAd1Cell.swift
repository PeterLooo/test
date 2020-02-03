//
//  HomeAd1Cell.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/20.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
protocol HomeAd1CellProtocol: NSObjectProtocol {
    func onTouchItem(adItem: IndexResponse.ModuleItem)
}
class HomeAd1Cell: UITableViewCell {
    @IBOutlet weak var moduleTitle: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!

    weak var delegate: HomeAd1CellProtocol?
    
    func setCell(item:IndexResponse.Module){
        self.stackView.subviews.forEach{$0.removeFromSuperview()}
        self.moduleTitle.text = item.moduleText
        scrollViewHeight.constant = (screenWidth / 2.20) / 0.9
        item.moduleItemList.forEach { (module) in
            let view = HomeAd1View()
            view.setView(item: module, isFirst: item.moduleItemList.first == module, isLast: item.moduleItemList.last == module)
            view.delegate = self
            self.stackView.addArrangedSubview(view)
        }
    }
}

extension HomeAd1Cell: HomeAd1ViewProcotol {
    func onTouchHotelAdItem(adItem: IndexResponse.ModuleItem) {
        self.delegate?.onTouchItem(adItem: adItem)
    }
}
