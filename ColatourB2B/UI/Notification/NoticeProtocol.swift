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
    func onBindNewsListComplete(noticeList: [NotiItem])
}

protocol NoticePresenterProtocol: BasePresenterProtocol {
    func getNoticeList(pageIndex:Int)
    func getNewsList(pageIndex:Int)
}
