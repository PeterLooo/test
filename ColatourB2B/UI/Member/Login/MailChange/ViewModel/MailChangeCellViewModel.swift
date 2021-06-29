//
//  MailChangeCellViewModel.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/6/25.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation

class MailChangeCellViewModel {
    
    var topButtonAction: (()->())?
    var donwButtonAction: (()->())?
    
    var changeInfo: String!
    var email: String!
    var topButton: String!
    var donwButton: String!
    
    required init(chnageInfo: String,
                  email: String,
                  topButton: String,
                  donwButton: String) {
        
        self.changeInfo = chnageInfo
        self.email = email
        self.topButton = topButton
        self.donwButton = donwButton
    }
}
