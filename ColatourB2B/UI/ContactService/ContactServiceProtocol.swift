//
//  ContactServiceProtocol.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/2/7.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation

protocol ContactServiceViewProtocol: BaseViewProtocol {
    
    func onBindContactServiceList(contactServiceResponse: ContactServiceResponse)
}

protocol ContactServicePresenterProtocol: BasePresenterProtocol {
    
    func getContactServiceList()
}
