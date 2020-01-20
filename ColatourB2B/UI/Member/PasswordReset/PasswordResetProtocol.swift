//
//  PasswordResetProtocol.swift
//  ColatourB2B
//
//  Created by M7635 on 2020/1/16.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation

protocol PasswordResetViewProtocol: BaseViewProtocol {

    func passwordResetResult(response: PasswordResetResponse)
}

protocol PasswordResetPresenterProtocol: BasePresenterProtocol {

    func passwordReset(request: PasswordResetRequest)
}
