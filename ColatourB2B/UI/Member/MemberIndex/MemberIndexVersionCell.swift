//
//  MemberIndexVersionCell.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/31.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit

class MemberIndexVersionCell: UITableViewCell {

    @IBOutlet weak var versionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.versionLabel.font = UIFont(name: "PingFangTC-Regular", size: 16.0)
        self.versionLabel.text = "版本\(DeviceUtil.appVersion() ?? "") \(DeviceUtil.appBuildVersion() ?? "")"
    }
    
}
