//
//  ContactInfoProtocol.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/2/7.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation

protocol ContactInfoViewProtocol: BaseViewProtocol {
    
    func onBindContactInfoList(contactInfoResponse: ContactInfoResponse)
}

protocol ContactInfoPresenterProtocol: BasePresenterProtocol {
    
    func getContactInfoList()
}
