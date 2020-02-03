//
//  MessageSendRepository.swift
//  ColatourB2B
//
//  Created by M7635 on 2020/1/22.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MessageSendRepository: NSObject {
    
    static let shared = MessageSendRepository()
    
    func getMessageSendUserList(messageSendType: MessageSendType) -> Single<MessageSendUserListResponse> {
        
        let api = APIManager.shared.getMessageSendUserList(messageSendType: messageSendType)
        
        return AccountRepository.shared.getAccessToken()
            .flatMap{ _ in api }
            .map{ MessageSendUserListResponse(JSON: $0)! }
    }
    
    func messageSend(messageSendRequest: MessageSendRequest) -> Single<MessageSendResponse> {
        
        let api = APIManager.shared.messageSend(messageSendRequest: messageSendRequest)
        
        return AccountRepository.shared.getAccessToken()
            .flatMap{ _ in api }
            .map{ MessageSendResponse(JSON: $0)! }
    }
}
