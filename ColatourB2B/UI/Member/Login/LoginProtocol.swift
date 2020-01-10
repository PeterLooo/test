//
//  LoginProtocol.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/23.
//  Copyright © 2019 Colatour. All rights reserved.
//

import Foundation

protocol LoginViewProtocol:BaseViewProtocol {
    func loginSuccess(loginResponse:LoginResponse)
}

protocol LoginPresenterProtocol:BasePresenterProtocol {
    func login(requset:LoginRequest)
    func pushDevice()
}
