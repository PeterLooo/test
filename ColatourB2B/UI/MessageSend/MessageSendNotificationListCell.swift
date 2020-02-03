//
//  MessageSendNotificationListCell.swift
//  ColatourB2B
//
//  Created by M7635 on 2020/1/21.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

protocol MessageSendNotificationListCellDelegate: NSObjectProtocol {
    
    func reSetCell(userStatus: UserStatus)
}

class MessageSendNotificationListCell: UITableViewCell {
    
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var sendName: UILabel!
    
    weak var delegate: MessageSendNotificationListCellDelegate?
    
    private var userStatus: UserStatus?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let ges = UITapGestureRecognizer(target: self, action: #selector(checkButtonPressed(_:)))
        self.addGestureRecognizer(ges)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func checkButtonPressed(_ sender: UIButton) {
        
        userStatus?.defaultMark = !userStatus!.defaultMark!
        self.delegate?.reSetCell(userStatus: userStatus!)
    }
    
    func cellTitleHidden() {
        
        cellTitle.isHidden = true
    }
    
    func setCell(userStatus: UserStatus) {
        
        if userStatus.defaultMark == true {
            
            checkButton.setBackgroundImage(UIImage(named: "checkbox_checked"), for: .normal)
        } else {
            
            checkButton.setBackgroundImage(UIImage(named: "check_hover"), for: .normal)
        }
        
        sendName.text = userStatus.sendName
        checkButton.isUserInteractionEnabled = userStatus.enabledMark ?? false
        self.userStatus = userStatus
    }
}
