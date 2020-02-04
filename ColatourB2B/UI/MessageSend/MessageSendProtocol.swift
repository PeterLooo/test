//
//  MessageSendProtocol.swift
//  ColatourB2B
//
//  Created by M7635 on 2020/1/22.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation

protocol MessageSendViewProtocol: BaseViewProtocol {

    func setSendUserList(messageSendUserListResponse: MessageSendUserListResponse)
    func messageSendSuccess()
}

protocol MessageSendPresenterProtocol: BasePresenterProtocol {

    func getSendUserList(messageSendType: String)
    func messageSend(messageSendRequest: MessageSendRequest)
}
