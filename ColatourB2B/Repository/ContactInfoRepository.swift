//
//  ContactInfoRepository.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/2/7.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ContactInfoRepository: NSObject {
    
    static let shared = ContactInfoRepository()
    
    func getContactInfo() -> Single<ContactInfoResponse> {
        
        let api = APIManager.shared.getContactInfo()
        
        return AccountRepository.shared.getAccessToken()
            .flatMap { _ in api }
            .map{ ContactInfoResponse(JSON: $0)! }
    }
}
