//
//  PasswordRestPresenter.swift
//  ColatourB2B
//
//  Created by M7635 on 2020/1/16.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation
import RxSwift

class PasswordModifyPresenter: PasswordModifyPresenterProtocol {
    
    weak var delegate: PasswordModifyViewProtocol?
    let accountRepository = AccountRepository.shared
    let memberRepository = MemberRepository.shared
    let dispose = DisposeBag()

    convenience init(delegate:PasswordModifyViewProtocol) {
        self.init()
        self.delegate = delegate
    }
    
    func passwordModify(request: PasswordModifyRequest) {
        
        self.delegate?.onStartLoadingHandle(handleType: .ignore)
        
        accountRepository.passwordModify(passwordModifyRequest: request)
            .subscribe(
                onSuccess: { (passwordModifyReponse) in
                    self.delegate?.passwordModifySuccess()
                    self.delegate?.onCompletedLoadingHandle()
            },  onError: { (error) in
                    self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .alert)
                    self.delegate?.onCompletedLoadingHandle()
            }).disposed(by: dispose)
    }
    
    func passwordModifyFromLogin(request: PasswordModifyRequest, accessToken: String) {
        
        self.delegate?.onStartLoadingHandle(handleType: .ignore)
        
        accountRepository.passwordModifyFromLogin(request: request, accessToken: accessToken)
            .subscribe(
                onSuccess: { (response) in
                self.delegate?.passwordModifySuccess()
                self.delegate?.onCompletedLoadingHandle()
            }, onError: { (error) in
                self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .alert)
                self.delegate?.onCompletedLoadingHandle()
            }).disposed(by: dispose)
    }
}
