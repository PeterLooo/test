//
//  NoticeDetailViewController.swift
//  ColatourB2B
//
//  Created by M6853 on 2020/1/8.
//  Copyright © 2020 Colatour. All rights reserved.
//

import RxSwift

class NoticeDetailRepository {
    static let shared = NoticeDetailRepository()
    
    func getNoticeDetail(noticeNo: String) -> Single<NoticeDetailResponse.NoticeDetail> {
        let api = APIManager.shared.getNoticeDetail(noticeNo: noticeNo)
        
        return AccountRepository.shared.getAccessToken()
            .flatMap{_ in api}
            .map{ NoticeDetailResponse(JSON: $0)!.noticeDetail!}
    }
}
