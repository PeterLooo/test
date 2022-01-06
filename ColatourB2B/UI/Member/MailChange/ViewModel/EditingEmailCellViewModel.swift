//
//  EditingEmailCellViewModel.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/6/25.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation

class EditingEmailCellViewModel {
    
    var sendEmail: ((String?)->())?
    var emailAreEmpty: ((String?)->())?
    var originalEmail: String?
    var newEmail: String?
    
    required convenience init(originalEmail: String) {
        self.init()
        self.originalEmail = originalEmail
    }
    
    func testEmailAction() {
        if newEmail.isNilOrEmpty {
            self.emailAreEmpty?("請輸入Email")
            return
        }
        sendEmail?(newEmail)
    }
}
