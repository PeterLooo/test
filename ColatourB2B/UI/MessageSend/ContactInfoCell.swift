//
//  ContactServiceCell.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/2/7.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

protocol ContactServiceCellProtocol: NSObjectProtocol {
    
    func onTouchPhoneNum(url:URL)
}

class ContactInfoCell: UITableViewCell {
    
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    
    weak var delegate: ContactServiceCellProtocol?
    private var contactService: ContactInfo?

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setCell(contactService: ContactInfo) {
        
        serviceName.text = contactService.contactInfoTitle
        subTitle.text = contactService.contactInfoDataList
        phoneNumber.text = contactService.phoneNumber
        
        let ges = UITapGestureRecognizer(target: self, action: #selector(onTouchPhoneNumber))
        phoneNumber.addGestureRecognizer(ges)
        phoneNumber.isUserInteractionEnabled = true
    }
    
    @objc func onTouchPhoneNumber() {
        
        if let phoneNum = phoneNumber.text {
            
            if let url = URL.init(string: "tel://\(phoneNum)") {
                
                self.delegate?.onTouchPhoneNum(url: url)
            }
        }
    }
}
