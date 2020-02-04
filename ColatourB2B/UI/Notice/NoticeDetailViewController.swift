//
//  NoticeDetailViewController.swift
//  ColatourB2B
//
//  Created by M6853 on 2020/1/8.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

extension NoticeDetailViewController {
    func setVCwith(navTitle: String?,
                   notiTitle: String?,
                   messageDate: String?,
                   sendUser: String?,
                   content: String?,
                   orderNo: String?,
                   groupNo: String?) {
        self.navTitle = navTitle
        self.noticeDetail = NoticeDetailResponse.NoticeDetail(messageDate: messageDate,
                                                              sendUser: sendUser,
                                                              content: content,
                                                              notiTitle: notiTitle)
    }
}

class NoticeDetailViewController: BaseViewController {
    private var navTitle: String?

    private var noticeDetail: NoticeDetailResponse.NoticeDetail? {
        didSet {
            tableView.reloadData()
        }
    }
    
    enum Section: Int, CaseIterable {
        case content
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.allowsSelectionDuringEditing = false
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NoticeDetailInfoCell", bundle: nil), forCellReuseIdentifier: "NoticeDetailInfoCell")
        tableView.register(UINib(nibName: "NoticeDetailContentCell", bundle: nil), forCellReuseIdentifier: "NoticeDetailContentCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavTitle(title: navTitle ?? "")
        self.setNavType(navBarType: .notHidden)
        self.setTabBarType(tabBarType: .notHidden)
        
        layout()
    }
    
    private func layout(){
        self.view.addSubview(tableView)
        tableView.constraintToSafeArea()
    }
}

extension NoticeDetailViewController: NoticeDetailViewProtocol {
    func onBindNoticeDetail(noticeDetail: NoticeDetailResponse.NoticeDetail) {
        self.noticeDetail = noticeDetail
    }
}

extension NoticeDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if noticeDetail == nil { return 0 }
        switch Section(rawValue: section)! {
        
        case .content:
            return noticeDetail!.content.isNilOrEmpty ? 0 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
        
        case .content:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeDetailContentCell") as! NoticeDetailContentCell
            cell.setCellWith(noticeDetail: noticeDetail!)
            return cell
        }
    }
}


