//
//  PasswordRestPresenter.swift
//  ColatourB2B
//
//  Created by M7635 on 2020/1/16.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation
import RxSwift

class PasswordResetPresenter: PasswordResetPresenterProtocol {
    
    weak var delegate: PasswordResetViewProtocol?
    let accountRepository = AccountRepository.shared
    let dispose = DisposeBag()

    convenience init(delegate:PasswordResetViewProtocol) {
        self.init()
        self.delegate = delegate
    }
    
    func passwordReset(request: PasswordResetRequest) {
        
        self.delegate?.onStartLoadingHandle(handleType: .ignore)
        accountRepository.passwordReset(passwordResetRequest: request)
            .subscribe(
                
                onSuccess: { (passwordResetReponse) in
                    self.delegate?.passwordResetResult(response: passwordResetReponse)
                    self.delegate?.onCompletedLoadingHandle()
                    
            },  onError: { (error) in
                    self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .alert)
                    self.delegate?.onCompletedLoadingHandle()
                
            }).disposed(by:dispose)
    }
}
