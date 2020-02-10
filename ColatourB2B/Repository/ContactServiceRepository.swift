//
//  ContactServiceRepository.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/2/7.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation

class ContactServiceRepository: NSObject {
    
    func getContactService() -> ContactServiceResponse {
        
        let contactServiceResponse = ContactServiceResponse()
        contactServiceResponse.contactServiceList = [ContactService(serviceName: "團體客服", subTitle: nil, phoneNumber: "02-25156085"),
                                                          ContactService(serviceName: "票務客服", subTitle: nil, phoneNumber: "02-25610098"),
                                                          ContactService(serviceName: "國內票券客服", subTitle: nil, phoneNumber: "02-25316966"),
                                                          ContactService(serviceName: "國外票券客服", subTitle: "(台北市同業)", phoneNumber: "02-25026601"),
                                                           ContactService(serviceName: "國外票券客服", subTitle: "(新北、外縣市同業)", phoneNumber: "02-25319111")]
        
        return contactServiceResponse
    }
}
