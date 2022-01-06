//
//  ConfirmKeySuccessCellViewModel.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/6/29.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation

class ConfirmKeySuccessCellViewModel {
    
    var email: String?
    var successInfo: String?
    
    required convenience init(email: String, successInfo: String) {
        self.init()
        self.email = email
        self.successInfo = successInfo
    }
}
