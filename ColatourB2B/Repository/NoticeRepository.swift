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
    
    func getNoticeList() -> Single<NoticeResponse> {
        let api = APIManager.shared.getNoticeList()
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
}
