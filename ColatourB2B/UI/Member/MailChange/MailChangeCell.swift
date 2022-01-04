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
    @IBOutlet weak var midButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    
    private var viewModel: MailChangeCellViewModel?
    
    override func awakeFromNib() {
        downButton.setBorder(width: 1, radius: 4, color: UIColor.init(named: "通用綠"))
        midButton.setBorder(width: 1, radius: 4, color: UIColor.init(named: "通用綠"))
    }
    
    func setCell(viewModel: MailChangeCellViewModel) {
        self.viewModel = viewModel
        changeInfo.text = "\(viewModel.name ?? "") \(viewModel.gender ?? "")，您好："
        setAttribute(label: changeInfo, amount: viewModel.name)
        email.text = viewModel.email
        
    }
    
    @IBAction func onTouchTestEmail(_ sender: Any) {
        viewModel?.testEmailAction?()
    }
    @IBAction func onTouchEditEmail(_ sender: Any) {
        viewModel?.editEmailAction?()
    }
    @IBAction func onTouchNextTime(_ sender: Any) {
        viewModel?.nextTimeAction?()
    }
    
    private func setAttribute(label:UILabel, amount:String){
        
        let length = amount.count
        if length <= 0 {return}
        let attributedString = NSMutableAttributedString(string: label.text!, attributes: [
            .font: UIFont(name: "PingFangTC-Regular", size: 15)!,
            .foregroundColor: UIColor.init(named: "標題黑")!,
            .kern: -0.1
            ])
        
        attributedString.addAttributes([
            .font: UIFont(name: "PingFangTC-Medium", size: 15)!,
            .foregroundColor: UIColor.init(named: "標題黑")!,
            .kern: -0.1
            ], range: NSRange(location: 0, length: amount.count))
        label.attributedText = attributedString
    }
}
