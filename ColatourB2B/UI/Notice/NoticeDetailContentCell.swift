//
//  NoticeDetailContentCell.swift
//  ColatourB2B
//
//  Created by M6853 on 2020/1/9.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

class NoticeDetailContentCell: UITableViewCell {
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    
    func setCellWith(content: String?) {
        borderView.setBorder(width: 1, radius: 4, color: ColorHexUtil.hexColor(hex: "#e7e7e7"))
        contentLabel.text = content ?? ""
    }
}
