//
//  NoticeDetailViewController.swift
//  ColatourB2B
//
//  Created by M6853 on 2020/1/8.
//  Copyright © 2020 Colatour. All rights reserved.
//

protocol NoticeDetailViewProtocol: BaseViewProtocol {
    func onBindNoticeDetail(noticeDetail: NoticeDetailResponse.NoticeDetail)
}

protocol NoticeDetailPresenterProtocol: BasePresenterProtocol {
    func getNoticeDetail(noticeNo: String)
}
