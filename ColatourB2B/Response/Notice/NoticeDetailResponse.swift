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
    
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        noticeDetail <- map["NoticeDetail"]
    }
    
    class NoticeDetail: BaseModel {
        var messageDate: String?
        var orderNo: String?
        var groupNo: String?
        var sendUser: String?
        var content: String?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            
            messageDate <- map["Message_Date"]
            orderNo <- map["Order_No"]
            groupNo <- map["Group_No"]
            sendUser <- map["Send_User"]
            content <- map["Content"]
        }
    }
}
