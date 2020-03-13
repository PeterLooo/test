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
        
        item.moduleItemList.forEach { (module) in
            let moduleInde = item.moduleItemList.firstIndex(of: module)!
            if moduleInde % 3 == 0 {
                let view = AirIndexView()
                view.setView(item: (module), moduleIndex: moduleInde)
                stackView.addArrangedSubview(view)
            }else{
                let lastView = stackView.subviews.last as! AirIndexView
                lastView.setView(item: (module), moduleIndex: moduleInde)
            }
        }
    }
    
}
