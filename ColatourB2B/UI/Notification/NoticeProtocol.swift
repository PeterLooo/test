//
//  NoticeProtocol.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/9.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation

protocol NoticeViewProtocol: BaseViewProtocol {
    
    func onBindImportantComplete(importantList: [NotiItem])
    func onBindNoticeListComplete(noticeList: [NotiItem])
    func onBindGroupNewsListComplete(groupNewsList: [NotiItem])
    func onBindAirNewsListComplete(airNewsList: [NotiItem])
    func onGetNotiListError(notiType: NotiType, apiError: APIError)
    func onBindSetNotiRead()
}

protocol NoticePresenterProtocol: BasePresenterProtocol {
    
    func getImportantList(pageIndex:Int, handleType: APILoadingHandleType)
    func getNoticeList(pageIndex:Int, handleType: APILoadingHandleType)
    func getGroupNewsList(pageIndex:Int, handleType: APILoadingHandleType)
    func getAirNewsList(pageIndex:Int, handleType: APILoadingHandleType)
    func setNoticeRead(noticeIdList: [String])
}
