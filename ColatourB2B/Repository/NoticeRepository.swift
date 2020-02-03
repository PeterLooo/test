//
//  NoticeRepository.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/9.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NoticeRepository: NSObject {
    static let shared = NoticeRepository()
    
    func getNoticeList(pageIndex: Int) -> Single<NoticeResponse> {
        let api = APIManager.shared.getNoticeList(pageIndex: pageIndex)
        return AccountRepository.shared.getAccessToken()
            .flatMap{_ in api}
            .map{ NoticeResponse(JSON: $0)!}
    }
    
    func getNewsList(pageIndex: Int) -> Single<NewsResponse> {
        let api = APIManager.shared.getNewsList(pageIndex: pageIndex)
        return AccountRepository.shared.getAccessToken()
            .flatMap{_ in api}
            .map{ NewsResponse(JSON: $0)!}
    }
    
    func getImportantList(pageIndex: Int) -> Single<NoticeResponse> {
        let api = APIManager.shared.getImportantList(pageIndex: pageIndex)
        return AccountRepository.shared.getAccessToken()
            .flatMap{_ in api}
            .map{ NoticeResponse(JSON: $0)!}
    }
    
    func getNumberOfNoticeUnreadCount() -> Single<Int> {
        let api = APIManager.shared.getNoticeUnreadCount()
        return AccountRepository.shared.apiToken
            .flatMap{_ in api}
            .map{NoticeUnreadCountResponse(JSON: $0)!.unreadCount }
    }
    
    func setNotiRead(notiId:[String]) -> Single<Any> {
        let api = APIManager.shared.setNotiRead(notiId: notiId)
        return AccountRepository.shared.getAccessToken()
            .flatMap{_ in api}
            .map{BaseModel(JSON: $0)!}
    }
}
