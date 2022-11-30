//
//  LoginViewModel.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/6/23.
//  Copyright © 2021 Colatour. All rights reserved.
//

import RxSwift

class LoginViewModel: BaseViewModel {
    
    let dispose = DisposeBag()
    let accountRepository = AccountRepository.shared
    var presentModifyVC: ((String,String,String)->())?
    var toEmailErrorVC: ((LoginResponse)->())?
    var toCompanyChange: ((LoginResponse)->())?
    var setDefaultTabBar: (()->())?
    var dismissLoginView: (()->())?
    var onLoginSuccess: (()->())?
    var setTextFieldErrorInfo: ((String?,String?) -> ())?
    
    var memberIdno: String?
    var password: String?
    
    func login() {
        var request: LoginRequest?
        
        if self.memberIdno.isNilOrEmpty == true || self.password.isNilOrEmpty == true {
            if password.isNilOrEmpty {
                setTextFieldErrorInfo?(nil,"請輸入密碼")
            }

            if self.memberIdno.isNilOrEmpty {
                self.setTextFieldErrorInfo?("請輸入會員帳號",nil)
            }
            
            return
        }else{
            request = LoginRequest(idno: memberIdno!, password: password!)
        }
        
        self.onStartLoadingHandle?(.coverPlateAlpha)
        
        accountRepository.getRefreshToke(loginRequest: request!)
        .subscribe(onSuccess: { [weak self] (model) in
            self?.loginSuccess(loginResponse: model)
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            
            self?.onApiErrorHandle?(error as! APIError, .alert)
            self?.onCompletedLoadingHandle?()
            
        }).disposed(by:dispose)
    }
    
    func loginSuccess(loginResponse: LoginResponse) {
        
        if loginResponse.loginResult == false {
            if let resultMessage = loginResponse.loginMessage {
                setTextFieldErrorInfo?(nil, resultMessage)
            }
        } else if loginResponse.passwordReset == true {
            self.presentModifyVC?(loginResponse.accessToken!,
                                  loginResponse.refreshToken!,
                                  loginResponse.loginMessage!)
            
        } else if loginResponse.linkType == .emailError {
            self.toEmailErrorVC?(loginResponse)
        } else if loginResponse.linkType == .companyError {
            self.toCompanyChange?(loginResponse)
        } else {
            self.setDefaultTabBar?()
            pushDevice()
            NotificationCenter.default.post(name: Notification.Name("noticeLoadDate"), object: nil)
            NotificationCenter.default.post(name: Notification.Name("getUnreadCount"), object: nil)
            self.dismissLoginView?()
        }
    }
    
    func loginSuccessAction() {
        self.onLoginSuccess?()
    }
    
    func pushDevice() {
        let _ = accountRepository.pushDevice().subscribe()
    }
}
