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
    weak var delegate: HomeAd1CellProtocol?
    
    func setCell(item:IndexResponse.Module){
        self.stackView.subviews.forEach{$0.removeFromSuperview()}
        
        item.moduleItemList.forEach { (module) in
            let moduleInde = item.moduleItemList.firstIndex(of: module)!
            if moduleInde % 3 == 0 {
                let view = AirIndexView()
                view.setView(item: (module), moduleIndex: moduleInde % 3)
                view.delegate = self
                stackView.addArrangedSubview(view)
            }else{
                let lastView = stackView.subviews.last as! AirIndexView
                lastView.setView(item: (module), moduleIndex: moduleInde % 3)
            }
        }
    }
}

extension AirIndexCell: HomeAd1ViewProcotol {
    func onTouchHotelAdItem(adItem: IndexResponse.ModuleItem) {
        self.delegate?.onTouchItem(adItem: adItem)
    }
}
