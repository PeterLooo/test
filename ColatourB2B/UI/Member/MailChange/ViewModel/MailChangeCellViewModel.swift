//
//  MailChangeCellViewModel.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/6/25.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation

class MailChangeCellViewModel {
    
    var testEmailAction: (()->())?
    var nextTimeAction: (()->())?
    var editEmailAction: (()->())?
    
    var name: String!
    var email: String!
    var gender: String!
    
    required init(name: String,
                  email: String,
                  gender: String) {
        
        self.name = name
        self.email = email
        self.gender = gender
    }
}
