//
//  MailChangeFailureCell.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/12/22.
//  Copyright © 2021 Colatour. All rights reserved.
//

import UIKit

class MailChangeFailureCell: UITableViewCell {

    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var remark: UILabel!
    @IBOutlet weak var contantService: UIButton!
    
    private var viewModel: MailChangeFailureViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contantService.setBorder(width: 1, radius: 4, color: UIColor.init(named: "通用綠"))
    }
    
    func setCell(viewModel: MailChangeFailureViewModel) {
        self.viewModel = viewModel
        email.text = viewModel.email
        remark.text = viewModel.failureInfo
    }
    
    @IBAction func onTouchReSend(_ sender: Any) {
        self.viewModel?.reSendEmail?()
    }
    @IBAction func onTouchContantService(_ sender: Any) {
        self.viewModel?.contactService?()
    }
}
