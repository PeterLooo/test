//
//  ContactInfoCell.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/2/7.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

protocol ContactInfoCellProtocol: NSObjectProtocol {
    
    func onTouchPhoneNum(url:URL)
}

class ContactInfoCell: UITableViewCell {
    
    @IBOutlet weak var infoName: UILabel!
    @IBOutlet weak var infoPhone: UILabel!
    
    weak var delegate: ContactInfoCellProtocol?
    private var contactInfo: ContactInfo?

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setCell(info: Info) {
        
        infoName.text = info.infoName
        infoPhone.text = info.infoPhone
        
        let ges = UITapGestureRecognizer(target: self, action: #selector(onTouchPhoneNumber))
        infoPhone.addGestureRecognizer(ges)
        infoPhone.isUserInteractionEnabled = true
    }
    
    @objc func onTouchPhoneNumber() {
        
        if let phoneNum = infoPhone.text {
            
            if let url = URL.init(string: "tel://\(phoneNum)") {
                
                self.delegate?.onTouchPhoneNum(url: url)
            }
        }
    }
}
