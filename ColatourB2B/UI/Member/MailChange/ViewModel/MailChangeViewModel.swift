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
        case testEmail
        case editingEmail
        case sendKey
        case success
        case failure
    }
}

class MailChangeViewModel: BaseViewModel {
    
    var nextTimeToEdit: (()->())?
    var updateTableView: (()->())?
    var toastText: ((String)->())?
    
    let respository = MemberRepository.shared
    
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
    
    private var befortType: LoginEmailChangeType? {
        didSet{
            deterType()
        }
    }
    
    var mailChangeCellViewModle: MailChangeCellViewModel? {
        didSet{
            mailChangeCellViewModle?.topButtonAction = { [weak self] in
                switch self?.emailChangeType {
                case .changeEmail:
                    self?.befortType = .changeEmail
                    self?.emailChangeType = .editingEmail
                case .testEmail:
                    self?.befortType = .testEmail
                    self?.emailChangeType = .sendKey
                default:
                    print("topButtonAction: \(self!.emailChangeType!)")
                }
            }
            
            mailChangeCellViewModle?.donwButtonAction = { [weak self] in
                switch self?.emailChangeType {
                case .changeEmail:
                    self?.nextTimeToEdit?()
                case .testEmail:
                    self?.befortType = .testEmail
                    self?.emailChangeType = .editingEmail
                default:
                    ()
                }
            }
        }
    }
    
    var editingEmailCellViewModel: EditingEmailCellViewModel? {
        didSet{
            
            editingEmailCellViewModel?.sendEmail = { [weak self] email in
                self?.getCorrectEmailSend()
            }
        }
    }
    
    var confirmKeyCellViewModel: ConfirmKeyCellViewModel? {
        didSet{
            
            confirmKeyCellViewModel?.sendKey = { [weak self] key in
                if let comfirmCode = key {
                    self?.getCorrectEmailConfirm(confirmCode: comfirmCode)
                }
            }
            
            confirmKeyCellViewModel?.receiveFail = { [weak self] in
                self?.emailChangeType = .failure
                self?.deterType()
            }
        }
    }
    
    var failureViewModel: MailChangeFailureViewModel? {
        didSet{
            failureViewModel?.reSendEmail = { [weak self] in
                self?.getCorrectEmailSend()
                self?.emailChangeType = .sendKey
                self?.updateTableView?()
            }
            
            failureViewModel?.contactService = { [weak self] in
                self?.handleLinkType?(.getApiUrlThenOpenAppWebView, "/R01C_Service/R01C000_ServiceMain.aspx?ServiceType=團體", nil, nil)
            }
        }
    }
    
    var confirmSuccessViewModel: ConfirmKeySuccessCellViewModel?
    
    private let disposeBag = DisposeBag()
    
    required init(type: LoginEmailChangeType) {
        super.init()
        
        self.emailChangeType = type
    }
    
    func getCorrectEmailInti() {
        self.onStartLoadingHandle?(.coverPlateAlpha)
        respository.correctEmailInit().subscribe { [weak self] model in
            self?.correctEmailInfo = model
            self?.updateTableView?()
            self?.onCompletedLoadingHandle?()
        } onError: { [weak self] error in
            self?.onApiErrorHandle?(error as! APIError, .coverPlate)
            self?.onCompletedLoadingHandle?()
        }.disposed(by: disposeBag)
    }
    
    func getCorrectEmailSend() {
        self.onStartLoadingHandle?(.coverPlateAlpha)
        respository.correctEmailSend(email: (correctEmailInfo?.email)!).subscribe { [weak self] model in
            self?.bindingSendEamil(errorResult: model.sendEmailResult)
            self?.onCompletedLoadingHandle?()
        } onError: { [weak self] error in
            self?.onApiErrorHandle?(error as! APIError, .alert)
            self?.onCompletedLoadingHandle?()
        }.disposed(by: disposeBag)
    }
    
    func getCorrectEmailConfirm(confirmCode: String) {
        self.onStartLoadingHandle?(.coverPlateAlpha)
        respository.correntEmailComfirem(confirmCode: confirmCode).subscribe { [weak self] model in
            self?.bindingCouurectEmailConfirm(result: model.comfirmResult)
            self?.onCompletedLoadingHandle?()
        } onError: { [weak self] error in
            self?.onApiErrorHandle?(error as! APIError, .alert)
            self?.onCompletedLoadingHandle?()
        }.disposed(by: disposeBag)
    }
    
    func bindingCouurectEmailConfirm(result: Bool?) {
        
        if result == true {
            self.confirmSuccessViewModel = ConfirmKeySuccessCellViewModel(email: (self.correctEmailInfo?.email)!, successInfo: "\(correctEmailInfo?.name ?? "") \(correctEmailInfo?.gender ?? "")，您好：\n您註冊的電子郵件信箱已經可以正常接收「可樂B2B同業網」寄送給您的信件！\n\n我們往後的網路服務信函將會寄送到此信箱，謝謝您的配合！")
            self.emailChangeType = .success
        }
    }
    
    func bindingSendEamil(errorResult: String?) {
        if errorResult.isNilOrEmpty {
            
        }else{
            self.toastText?(errorResult!)
        }
    }
    
    private func deterType(){
        
        switch emailChangeType {
        case .changeEmail:
            mailChangeCellViewModle = MailChangeCellViewModel(
                chnageInfo: "\(correctEmailInfo?.name ?? "") \(correctEmailInfo?.gender ?? "")，您好：\n您註冊的電子郵件信箱無法正常接收「可樂B2B同業網」寄送給您的各項業務住來信函！\n\n當您因為任職旅行社更改，而無法使用會員帳號時，請填寫下列資料MAIL通知客服中心。",
                email: "abc@cola.com.tw",
                topButton: "修改我的電子郵件",
                donwButton: "登入B2B下次再修改")
        case .testEmail:
            mailChangeCellViewModle = MailChangeCellViewModel(
                chnageInfo: "\(correctEmailInfo?.name ?? "") \(correctEmailInfo?.gender ?? "")，您好：\n您註冊的電子郵件信箱無法正常接收「可樂B2B同業網」寄送給您的各項業務住來信函！\n\n當您因為任職旅行社更改，而無法使用會員帳號時，請填寫下列資料MAIL通知客服中心。",
                email: "\(correctEmailInfo?.email ?? "")",
                topButton: "測試收信功能",
                donwButton: "更改為新的Email")
        case .editingEmail:
            editingEmailCellViewModel = EditingEmailCellViewModel(originalEmail: mailChangeCellViewModle?.email ?? "")
        case .sendKey:
            confirmKeyCellViewModel = ConfirmKeyCellViewModel(email: correctEmailInfo?.email ?? "")
        case .failure:
            failureViewModel = MailChangeFailureViewModel(email: correctEmailInfo?.email ?? "",
                                                          info: "\(correctEmailInfo?.name ?? "") \(correctEmailInfo?.gender ?? "")，您好：\n您輸入的「收信確認碼」與我們寄出的資料不符合或您尚無法接收我們寄出的電子郵件！")
        default:
            ()
        }
        self.updateTableView?()
    }
    
    func onTouchBack(){
        self.emailChangeType = befortType != nil ? befortType:emailChangeType
    }
}
