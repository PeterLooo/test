//
//  MailChangeFailureViewModel.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/12/23.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation

class MailChangeFailureViewModel {
    
    var reSendEmail: (()->())?
    var contactService: (()->())?
    
    var email: String?
    var failureInfo: String?
    
    required convenience init(email: String, info: String) {
        self.init()
        self.email = email
        self.failureInfo = info
    }
}
