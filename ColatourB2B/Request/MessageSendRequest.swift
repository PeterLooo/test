//
//  MessageSendRequest.swift
//  ColatourB2B
//
//  Created by M7635 on 2020/1/30.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation

class MessageSendRequest: NSObject {
    
    var sendType: String?
    var sendKeyList: [String]?
    var messageTopic: String?
    var messageText: String?
}
