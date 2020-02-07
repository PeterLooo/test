//
//  EmptyDataCell.swift
//  colatour
//
//  Created by M6853 on 2019/8/27.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit
protocol EmptyDataCellPortocol: NSObjectProtocol {
    func onTouchRefresh()
}
class EmptyDataCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var iconTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var refreshButton: UIButton!
    
    weak var delegate: EmptyDataCellPortocol?
    
    func setCellWith(image: UIImage, message: String, iconTopConstraint: CGFloat, needRefreshButton: Bool = false)
    {
        self.icon.image = image
        self.message.text = message
        self.iconTopConstraint.constant = iconTopConstraint
        self.refreshButton.isHidden = !needRefreshButton
        
    }
    @IBAction func onTouchRefresh(_ sender: Any) {
        self.delegate?.onTouchRefresh()
    }
}
