//
//  PasswordModifyRequest.swift
//  ColatourB2B
//
//  Created by M7635 on 2020/1/16.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation

class PasswordModifyRequest: NSObject {
    
    var originalPassword: String?
    var newPassword: String?
    var checkNewPassword: String?
    var passwordHint: String?
    var refreshToken: String?
}
