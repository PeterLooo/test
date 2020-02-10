//
//  ContactServicePresenter.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/2/7.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation

class  ContactServicePresenter: ContactServicePresenterProtocol {
    
    let contactServiceRepository = ContactServiceRepository()
    var contactServiceResponse: ContactServiceResponse?
    
    weak var delegate: ContactServiceViewProtocol?
    
    convenience init(delegate: ContactServiceViewProtocol) {
        self.init()
        self.delegate = delegate
    }
    
    func getContactServiceList() {
        
        contactServiceResponse = contactServiceRepository.getContactService()
        
        if let response = contactServiceResponse {
            
             delegate?.setContactServiceList(contactServiceResponse: response)
        }
    }
}
