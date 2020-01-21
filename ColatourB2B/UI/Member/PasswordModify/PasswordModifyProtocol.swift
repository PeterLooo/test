//
//  PasswordModifyProtocol.swift
//  ColatourB2B
//
//  Created by M7635 on 2020/1/16.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation

protocol PasswordModifyViewProtocol: BaseViewProtocol {

    func passwordModifySuccess()
    func passwordModifyFail(response: PasswordModifyResponse)
}

protocol PasswordModifyPresenterProtocol: BasePresenterProtocol {

    func passwordModify(request: PasswordModifyRequest)
}
