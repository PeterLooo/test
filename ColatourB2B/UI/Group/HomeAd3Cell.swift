//
//  HomeAd3Cell.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/2/7.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

class HomeAd3Cell: UITableViewCell {
    
    @IBOutlet weak var moduleText: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    weak var delegate: HomeAd1CellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(item:IndexResponse.Module){
        
        self.stackView.subviews.forEach{$0.removeFromSuperview()}
        moduleText.text = item.moduleText
        
        item.moduleItemList.forEach { (module) in
            let view = HomeAd3View()
            view.setView(item: module, isFirst: item.moduleItemList.first == module, isLast: item.moduleItemList.last == module)
            view.delegate = self
            self.stackView.addArrangedSubview(view)
        }
    }
}

extension HomeAd3Cell : HomeAd1ViewProcotol {
    func onTouchHotelAdItem(adItem: IndexResponse.ModuleItem) {
        self.delegate?.onTouchItem(adItem: adItem)
    }
}
