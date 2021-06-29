//
//  MailChangeViewModel.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/6/25.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation

extension MailChangeViewModel {
    enum LoginEmailChangeType {
        case changeEmail
        case testEmail
        case editingEmail
        case sendKey
    }
}

class MailChangeViewModel: BaseViewModel {
    
    var nextTimeToEdit: (()->())?
    var updateTableView: (()->())?
    
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
                print(email) // api callin
            }
        }
    }
    
    var confirmKeyCellViewModel: ConfirmKeyCellViewModel? {
        didSet{
            
            confirmKeyCellViewModel?.sendKey = { [weak self] key in
                print(key) // api callin
            }
            
            confirmKeyCellViewModel?.receiveFail = { [weak self] in
                // 接收事敗待討論流程
            }
        }
    }
    
    required init(type: LoginEmailChangeType) {
        super.init()
        
        self.emailChangeType = type
        deterType()
        
    }
    
    func deterType(){
        
        switch emailChangeType {
        case .changeEmail:
            mailChangeCellViewModle = MailChangeCellViewModel(
                chnageInfo: "林宇儒 先生，您好：\n您註冊的電子郵件信箱無法正常接收「可樂B2B同業網」寄送給您的各項業務住來信函！\n\n當您因為任職旅行社更改，而無法使用會員帳號時，請填寫下列資料MAIL通知客服中心。",
                email: "abc@cola.com.tw",
                topButton: "修改我的電子郵件",
                donwButton: "登入B2B下次再修改")
        case .testEmail:
            mailChangeCellViewModle = MailChangeCellViewModel(
                chnageInfo: "林宇儒 先生，您好：\n您註冊的電子郵件信箱無法正常接收「可樂B2B同業網」寄送給您的各項業務住來信函！\n\n當您因為任職旅行社更改，而無法使用會員帳號時，請填寫下列資料MAIL通知客服中心。",
                email: "abc@cola.com.tw",
                topButton: "測試收信功能",
                donwButton: "更改為新的Email")
        case .editingEmail:
            editingEmailCellViewModel = EditingEmailCellViewModel(originalEmail: mailChangeCellViewModle?.email ?? "")
        case .sendKey:
            confirmKeyCellViewModel = ConfirmKeyCellViewModel(email: mailChangeCellViewModle?.email ?? "")
            
        default:
            ()
        }
        self.updateTableView?()
    }
    
    func onTouchBack(){
        self.emailChangeType = befortType != nil ? befortType:emailChangeType
    }
}
