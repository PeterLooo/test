//
//  ConfirmKeySuccessCell.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/6/29.
//  Copyright © 2021 Colatour. All rights reserved.
//

import UIKit

class ConfirmKeySuccessCell: UITableViewCell {

    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var successInfo: UILabel!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    
    func setCell(viewModel: ConfirmKeySuccessCellViewModel, viewHight: CGFloat){
        email.text = viewModel.email
        successInfo.text = viewModel.successInfo
        bottom.constant = viewHight - self.frame.height
    }
}
