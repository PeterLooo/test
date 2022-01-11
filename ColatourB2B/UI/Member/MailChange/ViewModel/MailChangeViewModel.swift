//
//  MailChangeViewModel.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/6/25.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

extension MailChangeViewModel {
    enum LoginEmailChangeType {
        case changeEmail
        case editingEmail
        case sendKey
        case success
        case failure
    }
}

class MailChangeViewModel: BaseViewModel {
    
    var nextTimeToEdit: (()->())?
    var updateTableView: (()->())?
    var setDefaultTabBar: (()->())?
    var popToRootView: (()->())?
    var toastText: ((String)->())?
    
    let repository = MemberRepository.shared
    
    var correctEmailInfo: CorrectEmailInfo?{
        didSet{
            deterType()
        }
    }
    
    var emailChangeType: LoginEmailChangeType? {
        didSet{
            deterType()
        }
    }
    
    private var beforeType: LoginEmailChangeType?
    
    var mailChangeCellViewModel: MailChangeCellViewModel? {
        didSet{
            mailChangeCellViewModel?.testEmailAction = { [weak self] in
                
                switch self?.emailChangeType {
                case .changeEmail:
                    self?.beforeType = self?.emailChangeType
                    self?.getCorrectEmailSend(email: self?.correctEmailInfo?.email ?? "")
                default:
                    print("topButtonAction: \(self!.emailChangeType!)")
                }
            }
            mailChangeCellViewModel?.nextTimeAction = { [weak self] in
                
                self?.loginFirst(emailMark: true, nextTimeEdit: true)
            }
            mailChangeCellViewModel?.editEmailAction = { [weak self] in
                self?.beforeType = .changeEmail
                self?.emailChangeType = .editingEmail
            }
        }
    }
    
    var editingEmailCellViewModel: EditingEmailCellViewModel? {
        didSet{
            
            editingEmailCellViewModel?.sendEmail = { [weak self] email in
                self?.beforeType = self?.emailChangeType
                self?.newEmail = email
                self?.getCorrectEmailSend(email: email!)
            }
        }
    }
    
    var confirmKeyCellViewModel: ConfirmKeyCellViewModel? {
        didSet{
            
            confirmKeyCellViewModel?.sendKey = { [weak self] key in
                if let confirmCode = key {
                    self?.getCorrectEmailConfirm(confirmCode: confirmCode)
                }
            }
            
            confirmKeyCellViewModel?.receiveFail = { [weak self] in
                self?.emailChangeType = .failure
            }
        }
    }
    
    var failureViewModel: MailChangeFailureViewModel? {
        didSet{
            failureViewModel?.reSendEmail = { [weak self] in
                let email = (self?.newEmail.isNilOrEmpty)! ? (self?.correctEmailInfo?.email)! : (self?.newEmail)!
                self?.getCorrectEmailSend(email: email)
            }
            
            failureViewModel?.contactService = { [weak self] in
                self?.openWebUrl(webUrl: "/R01C_Service/R01C000_ServiceMain.aspx?ServiceType=團體", title: "", openBrowserOrAppWebView: .openBrowser)
            }
        }
    }
    
    var confirmSuccessViewModel: ConfirmKeySuccessCellViewModel?
    
    private var newEmail: String?
    private var loginResponse: LoginResponse?
    
    private let disposeBag = DisposeBag()
    
    required init(type: LoginEmailChangeType, loginResponse: LoginResponse? ) {
        super.init()
        
        self.emailChangeType = type
        self.loginResponse = loginResponse
    }
    
    func getCorrectEmailInit() {
        self.onStartLoadingHandle?(.coverPlateAlpha)
        repository.correctEmailInit(refreshToken: loginResponse?.refreshToken,
                                     accessToken: loginResponse?.accessToken).subscribe { [weak self] model in
            self?.correctEmailInfo = model
            self?.updateTableView?()
            self?.onCompletedLoadingHandle?()
        } onError: { [weak self] error in
            if (error as! APIError).type == .apiForbiddenException {
                self?.popToRootView?()
            }else{
                self?.onApiErrorHandle?(error as! APIError, .alert)
            }
            self?.onCompletedLoadingHandle?()
        }.disposed(by: disposeBag)
    }
    
    func getCorrectEmailSend(email: String) {
        self.onStartLoadingHandle?(.coverPlateAlpha)
        repository.correctEmailSend(email: email,
                                     refreshToken: loginResponse?.refreshToken,
                                     accessToken: loginResponse?.accessToken).subscribe { [weak self] model in
            self?.bindingSendEmail(errorResult: model.sendEmailResult)
            self?.onCompletedLoadingHandle?()
        } onError: { [weak self] error in
            if (error as! APIError).type == .apiForbiddenException {
                self?.popToRootView?()
            }else{
                self?.onApiErrorHandle?(error as! APIError, .alert)
            }
            self?.onCompletedLoadingHandle?()
        }.disposed(by: disposeBag)
    }
    
    func getCorrectEmailConfirm(confirmCode: String) {
        self.onStartLoadingHandle?(.coverPlateAlpha)
        repository.correctEmailConfirm(confirmCode: confirmCode,
                                         refreshToken: loginResponse?.refreshToken,
                                         accessToken: loginResponse?.accessToken).subscribe { [weak self] model in
            self?.bindingCorrectEmailConfirm(result: model.confirmResult)
            self?.onCompletedLoadingHandle?()
        } onError: { [weak self] error in
            if (error as! APIError).type == .apiForbiddenException {
                self?.popToRootView?()
            }else{
                self?.onApiErrorHandle?(error as! APIError, .alert)
            }
            self?.onCompletedLoadingHandle?()
        }.disposed(by: disposeBag)
    }
    
    private func openWebUrl(webUrl:String, title: String, openBrowserOrAppWebView: OpenBrowserOrAppWebView) {
        
        AccountRepository.shared.getAccessWeb(webUrl: webUrl, refreshToken: loginResponse?.refreshToken, accessToken: loginResponse?.accessToken).subscribe(onSuccess: { (url) in
            self.handleLinkType?(.openAppWebView, url, title, nil)
        }, onError: { (error) in
            ()
        }).disposed(by: disposeBag)
    }
    
    func loginFirst(emailMark: Bool, nextTimeEdit: Bool = false) {
        if loginResponse == nil { return }
        repository.loginFirst(emailMark: emailMark,
                               pageId: (loginResponse?.pageId)!,
                               refreshToken: loginResponse?.refreshToken,
                               accessToken: loginResponse?.accessToken).subscribe { [weak self] _ in
            UserDefaultUtil.shared.accessToken = self?.loginResponse?.accessToken
            UserDefaultUtil.shared.refreshToken = self?.loginResponse?.refreshToken
            if nextTimeEdit { self?.nextTimeToEdit?() }
            self?.setDefaultTabBar?()
        } onError: {[weak self] error in
            self?.onApiErrorHandle?(error as! APIError, .alert)
        }.disposed(by: disposeBag)
    }
    
    func bindingCorrectEmailConfirm(result: Bool?) {
        
        if result == true {
            
            loginFirst(emailMark: false)
            confirmSuccessViewModel = ConfirmKeySuccessCellViewModel(email: (self.correctEmailInfo?.email)!, successInfo: "\(correctEmailInfo?.name ?? "") \(correctEmailInfo?.gender ?? "")，您好：\n您註冊的電子郵件信箱已經可以正常接收「可樂B2B同業網」寄送給您的信件！\n\n我們往後的網路服務信函將會寄送到此信箱，謝謝您的配合！")
            emailChangeType = .success
        }else{
            emailChangeType = .failure
        }
    }
    
    func bindingSendEmail(errorResult: String?) {
        if errorResult.isNilOrEmpty {
            self.emailChangeType = .sendKey
        }else{
            self.toastText?(errorResult!)
        }
    }
    
    private func deterType(){
        
        switch emailChangeType {
        case .changeEmail:
            mailChangeCellViewModel = MailChangeCellViewModel(
                name: correctEmailInfo?.name ?? "",
                email: correctEmailInfo?.email ?? "",
                gender: correctEmailInfo?.gender ?? "")
        case .editingEmail:
            editingEmailCellViewModel = EditingEmailCellViewModel(originalEmail: mailChangeCellViewModel?.email ?? "")
        case .sendKey:
            confirmKeyCellViewModel = ConfirmKeyCellViewModel(email: newEmail.isNilOrEmpty ? (correctEmailInfo?.email ?? "") : newEmail!)
        case .failure:
            
            let email = newEmail.isNilOrEmpty ? (correctEmailInfo?.email ?? "") : newEmail!
            failureViewModel = MailChangeFailureViewModel(email: email,
                                                          info: "\(correctEmailInfo?.name ?? "") \(correctEmailInfo?.gender ?? "")，您好：\n您輸入的「收信確認碼」與我們寄出的資料不符合或您尚無法接收我們寄出的電子郵件！")
        default:
            ()
        }
        self.updateTableView?()
    }
    
    func onTouchBack(){
        self.emailChangeType = beforeType != nil ? beforeType:emailChangeType
        
        switch emailChangeType {
            
        case .editingEmail:
            beforeType = .changeEmail
        case .sendKey:
            beforeType = .editingEmail
        default:
            ()
        }
    }
}
