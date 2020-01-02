//
//  LoginPresenter.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/23.
//  Copyright © 2019 Colatour. All rights reserved.
//

import RxSwift

class LoginPresenter: LoginPresenterProtocol {
    
    weak var delegate: LoginViewProtocol?
    let dispose = DisposeBag()
    let accountRepository = AccountRepository.shared
    
    convenience init(delegate:LoginViewProtocol) {
        self.init()
        self.delegate = delegate
    }
    
    func login(requset: LoginRequest) {
        self.delegate?.onStartLoadingHandle(handleType: .ignore)
        accountRepository.getRefreshToke(loginRequest: requset)
        .subscribe(onSuccess: { (model) in
            self.delegate?.loginSuccess(loginResponse: model)
            self.delegate?.onCompletedLoadingHandle()
        }, onError: { (error) in
            
            self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .alert)
            self.delegate?.onCompletedLoadingHandle()
            
        }).disposed(by:dispose)
    }
    
}
