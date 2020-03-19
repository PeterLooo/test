//
//  DeviceCell.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/2/12.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

class DeviceCell: UITableViewCell {
    
    @IBOutlet weak var iosVersion: UILabel!
    @IBOutlet weak var appVersion: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setCell() {
        
        iosVersion.text = DeviceUtil.osVersion()
        appVersion.text = DeviceUtil.appVersion()
    }
}
