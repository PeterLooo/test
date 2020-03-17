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
    
    weak var delegate: HomeAd1CellProtocol?

    func setCell(item:IndexResponse.Module, numOfIndex: Int){
        self.stackView.subviews.forEach{$0.removeFromSuperview()}
        
        self.moduleTitle.text = item.moduleText
        
        scrollViewHeight.constant = screenWidth * (1 / 1.85) + 18
        item.moduleItemList.forEach { (module) in
            let moduleIndex = item.moduleItemList.firstIndex(of: module)
            if moduleIndex! % 2 == 0 {
                let view = AirPopCityView()
                view.setView(item: module, isFirst: item.moduleItemList.first == module, isLast: item.moduleItemList.last == module)
                view.delegate = self
                self.stackView.addArrangedSubview(view)
            }else{
                
                let lastView = self.stackView.subviews.last as! AirPopCityView
                lastView.setCellSec(item: module)
            }
        }
    }
}
extension AirPopCityCell : HomeAd1ViewProcotol {
    func onTouchHotelAdItem(adItem: IndexResponse.ModuleItem) {
        self.delegate?.onTouchItem(adItem: adItem)
    }
}
