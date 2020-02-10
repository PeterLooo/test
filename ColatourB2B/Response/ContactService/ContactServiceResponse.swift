//
//  ContactServiceResponse.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/2/7.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation

class ContactServiceResponse: BaseModel {
    
    var contactServiceList: [ContactService] = []
}

class ContactService: BaseModel {
    
    var serviceName: String?
    var subTitle: String?
    var phoneNumber: String?
    
    convenience init(serviceName: String?, subTitle: String?, phoneNumber: String?) {
        self.init()
        self.serviceName = serviceName
        self.subTitle = subTitle
        self.phoneNumber = phoneNumber
    }
}
