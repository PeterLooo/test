//
//  NotificationItemCell.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/2.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
protocol NotificationItemCellProtocol: NSObjectProtocol {
    func onTouchItem()
}
class NotificationItemCell: UITableViewCell {

    weak var delegate: NotificationItemCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let ges = UITapGestureRecognizer(target: self, action: #selector(onTouchItem))
        self.addGestureRecognizer(ges)
        self.isUserInteractionEnabled = true
    }
    
    @objc func onTouchItem(){
        self.delegate?.onTouchItem()
    }
}
