//
//  ContactInfoPresenter.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/2/7.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation
import RxSwift

class  ContactInfoPresenter: ContactInfoPresenterProtocol {
    
    let contactInfoRepository = ContactInfoRepository.shared
    let dispose = DisposeBag()
    
    weak var delegate: ContactInfoViewProtocol?
    
    convenience init(delegate: ContactInfoViewProtocol) {
        self.init()
        self.delegate = delegate
    }
    
    func getContactInfoList() {
        
        self.delegate?.onStartLoadingHandle(handleType: .coverPlate)
        contactInfoRepository.getContactInfo()
            .subscribe(
                
                onSuccess: { (contactInfoResponse) in
                    self.delegate?.onBindContactInfoList(contactInfoResponse: contactInfoResponse)
                    self.delegate?.onCompletedLoadingHandle()
                    
            }, onError: { (error) in
                self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .coverPlate)
                self.delegate?.onCompletedLoadingHandle()
                
            }).disposed(by: dispose)
    }
}
