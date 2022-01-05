//
//  NoticeTableViewModel.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/7/6.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation

class NoticeTableViewModel {
    
    var onTouchNoti: ((_ item: NotiItemViewModel, _ notiType: NotiType)->())?
    var onStartLoading: ((_ notiType: NotiType)->())?
    var pullRefresh: ((_ notiType: NotiType)->())?
    
    var itemList: [NotiItemViewModel] = [] {
        didSet{
            itemList.forEach { [weak self] item in
                item.onTouchItem = { [weak self] in
                    self?.onTouchNoti?(item, (self?.notiType)!)
                }
            }
        }
    }
    var notiType: NotiType!
    
    var notiTypeText: String?
    
    init(_ type: NotiType) {
        
        self.notiType = type
        switch notiType {
        case .important:
            notiTypeText = "訂單"
            
        case .noti:
            notiTypeText = "訊息"
            
        case .groupNews:
            notiTypeText = "團體快訊"
            
        case .airNews:
            notiTypeText = "機票快訊"
        
        case .none:
            ()
        }
    }
}

class NotiItemViewModel: NSObject {
    
    var onTouchItem: (()->())?
    
    var linkType : LinkType!
    var linkValue : String?
    var notiDate : String?
    var unreadMark : Bool?
    var notiTitle : String?
    var notiContent : String?
    var notiId: String?
    var apiNotiType: String?
    
    convenience init(notiTitle : String?,
                     notiContent : String?,
                     notiId: String?,
                     notiDate : String?,
                     unreadMark : Bool?,
                     linkType : LinkType!,
                     linkValue : String?,
                     apiNotiType: String?) {
        
        self.init()
        self.notiTitle = notiTitle
        self.notiContent = notiContent
        self.notiId = notiId
        self.notiDate = FormatUtil.convertStringToString(dateStringFrom: notiDate!, dateFormatTo: "MM/dd")
        if self.notiDate.isNilOrEmpty == true {self.notiDate = notiDate}
        self.unreadMark = unreadMark
        self.linkType = linkType
        self.linkValue = linkValue
        self.apiNotiType = apiNotiType
    }
}
