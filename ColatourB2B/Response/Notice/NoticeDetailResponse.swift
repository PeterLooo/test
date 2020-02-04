//
//  NoticeDetailViewController.swift
//  ColatourB2B
//
//  Created by M6853 on 2020/1/8.
//  Copyright © 2020 Colatour. All rights reserved.
//

import ObjectMapper

class NoticeDetailResponse: BaseModel {
    var noticeDetail: NoticeDetail?

    class NoticeDetail: BaseModel {
        var messageDate: String?
        var sendUser: String?
        var content: String?
        var orderNo: String?
        var groupNo: String?
        
        convenience init(messageDate: String?,
                        sendUser: String?,
                        content: String?,
                        orderNo: String?,
                        groupNo: String?)
        {
         
            
            self.init()
            self.messageDate = messageDate
            self.sendUser = sendUser
            self.content = content
            self.orderNo = orderNo
            self.groupNo = groupNo
        }
    }
}
