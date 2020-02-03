//
//  NoticeProtocol.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/9.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation

protocol NoticeViewProtocol: BaseViewProtocol {
    
    func onBindNoticeListComplete(noticeList: [NotiItem])
    func onBindNewsListComplete(newsList: [NotiItem])
    func onBindSetNotiRead()
}

protocol NoticePresenterProtocol: BasePresenterProtocol {
    func getNoticeList(pageIndex:Int, handleType: APILoadingHandleType)
    func getNewsList(pageIndex:Int, handleType: APILoadingHandleType)
    func setNoticeRead(noticeIdList: [String])
}
