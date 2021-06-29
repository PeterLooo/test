//
//  MailChangeCell.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/6/25.
//  Copyright © 2021 Colatour. All rights reserved.
//

import UIKit

class MailChangeCell: UITableViewCell {

    @IBOutlet weak var changeInfo: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    
    private var viewModel: MailChangeCellViewModel?
    
    override func awakeFromNib() {
        downButton.setBorder(width: 1, radius: 4, color: UIColor.init(named: "通用綠"))
    }
    
    func setCell(viewModel: MailChangeCellViewModel) {
        self.viewModel = viewModel
        changeInfo.text = viewModel.changeInfo
        email.text = viewModel.email
        topButton.setTitle(viewModel.topButton, for: .normal)
        downButton.setTitle(viewModel.donwButton, for: .normal)
        
    }
    
    @IBAction func topAction(_ sender: Any) {
        viewModel?.topButtonAction?()
    }
    
    @IBAction func bottomAction(_ sender: Any) {
        viewModel?.donwButtonAction?()
    }
}
