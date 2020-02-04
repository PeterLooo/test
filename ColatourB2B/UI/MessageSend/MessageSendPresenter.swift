//
//  MessageSendPresenter.swift
//  ColatourB2B
//
//  Created by M7635 on 2020/1/22.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation
import RxSwift

class MessageSendPresenter: MessageSendPresenterProtocol {
    
    weak var delegate: MessageSendViewProtocol?
    
    let messageSendRepository = MessageSendRepository.shared
    let dispose = DisposeBag()
    
    convenience init(delegate: MessageSendViewProtocol) {
        self.init()
        self.delegate = delegate
    }
    
    func getSendUserList(messageSendType: String) {
        
        self.delegate?.onStartLoadingHandle(handleType: .ignore)
        messageSendRepository.getMessageSendUserList(messageSendType: messageSendType)
            .subscribe(
                
                onSuccess: { (messageSendUserListResponse) in
                    self.delegate?.setSendUserList(messageSendUserListResponse: messageSendUserListResponse)
                    self.delegate?.onCompletedLoadingHandle()
                    
            },  onError: { (error) in
                self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .coverPlate)
                self.delegate?.onCompletedLoadingHandle()
                
            }).disposed(by: dispose)
    }
    
    func messageSend(messageSendRequest: MessageSendRequest) {
        
         self.delegate?.onStartLoadingHandle(handleType: .ignore)
         messageSendRepository.messageSend(messageSendRequest: messageSendRequest)
        .subscribe(
            
            onSuccess: { (_) in
                self.delegate?.messageSendSuccess()
                self.delegate?.onCompletedLoadingHandle()
                
        }, onError: { (error) in
            self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .alert)
            self.delegate?.onCompletedLoadingHandle()
            
        }).disposed(by: dispose)
    }
}
