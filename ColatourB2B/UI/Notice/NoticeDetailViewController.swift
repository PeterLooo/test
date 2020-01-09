//
//  NoticeDetailViewController.swift
//  ColatourB2B
//
//  Created by M6853 on 2020/1/8.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

extension NoticeDetailViewController {
    func setVCwith(navTitle: String?, noticeNo: String) {
        self.navTitle = navTitle
        self.noticeNo = noticeNo
    }
}

class NoticeDetailViewController: BaseViewController {
    private var navTitle: String?
    private var noticeNo: String!
    private var presenter: NoticeDetailPresenterProtocol?
    private var noticeDetail: NoticeDetailResponse.NoticeDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = NoticeDetailPresenter(delegate: self)
        self.setNavTitle(title: navTitle ?? "")
        self.setNavType(navBarType: .notHidden)
        self.setTabBarType(tabBarType: .notHidden)
        
        loadData()
    }
    
    override func loadData() {
        super.loadData()
        
        getNoticeDetail()
    }
    
    private func getNoticeDetail() {
        self.presenter?.getNoticeDetail(noticeNo: noticeNo)
    }
    
}

extension NoticeDetailViewController: NoticeDetailViewProtocol {
    func onBindNoticeDetail(noticeDetail: NoticeDetailResponse.NoticeDetail) {
        self.noticeDetail = noticeDetail
    }
}
