//
//  NoticeViewController.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/20.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit

class NoticeViewController: BaseViewController {
    
    @IBOutlet weak var topButtonView: UIView!
    @IBOutlet weak var topOrderButton: UIButton!
    @IBOutlet weak var topMessageButton: UIButton!
    @IBOutlet weak var topNewsButton: UIButton!
    @IBOutlet weak var pageButtonBottomLineLeading: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var orderUnreadHint: UIView!
    @IBOutlet weak var messageUnreadHint: UIView!
    @IBOutlet weak var newsUnreadHint: UIView!
    
    var presenter: NoticePresenter?
    private var noticeList: [NotiItem] = []
    {
        didSet{
            self.messageUnreadHint.isHidden = true
            if let _ = noticeList.filter({$0.unreadMark == true}).first {
                self.messageUnreadHint.isHidden = false
            }
        }
    }
    private var newsList: [NotiItem] = [] {
        didSet{
            self.newsUnreadHint.isHidden = true
            if let _ = newsList.filter({$0.unreadMark == true}).first {
                self.newsUnreadHint.isHidden = false
            }
        }
    }
    private var tableViews:[NotificationTableView] = []
    private var pageSize = 5
    private var isNotiLastPage = false
    private var isNewsLastPage = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.presenter = NoticePresenter(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setIsNavShadowEnable(false)
        setNavTitle(title: "通知")
        switchPageButton(toPage: 0)
        setTableView()
        loadData()
    }
    
    override func loadData() {
        super.loadData()
        isNotiLastPage = false
        isNewsLastPage = false
        noticeList = []
        newsList = []
        presenter?.getNoticeList(pageIndex: 1, handleType: .coverPlate)
        presenter?.getNewsList(pageIndex: 1, handleType: .coverPlate)
    }
    
    private func setTableView() {
        stackView.subviews.forEach({$0.removeFromSuperview()})
        for i in 0...2 {
            let view = NotificationTableView()
            switch i {
            case 0:
                view.setViewWith(itemList: [], notiType: .order)
            case 1:
                view.setViewWith(itemList: [], notiType: .noti)
            case 2:
                view.setViewWith(itemList: [], notiType: .news)
            default:
                break
            }
            view.delegate = self
            stackView.addArrangedSubview(view)
            tableViews.append(view)
        }
    }
    
    @IBAction func onTouchTopTag(_ sender: UIButton) {
        var contentOffset = CGFloat.zero
        switch sender.tag {
        case 0:
            contentOffset = 0
        case 1:
            contentOffset = screenWidth * 1
        case 2:
            contentOffset = screenWidth * 2
        default:
            contentOffset = 0
        }
        scrollView.setContentOffset(CGPoint.init(x: contentOffset, y: 0), animated: true)
    }
    
    private func switchPageButton(toPage: Int){
        switch toPage {
        case 0:
            enableButton(topOrderButton)
            disableButton(topMessageButton)
            disableButton(topNewsButton)
            
        case 1:
            enableButton(topMessageButton)
            disableButton(topOrderButton)
            disableButton(topNewsButton)
            
        case 2:
            enableButton(topNewsButton)
            disableButton(topMessageButton)
            disableButton(topOrderButton)
            
        default:
            ()
        }
    }
    
    private func enableButton(_ button: UIButton){
        button.tintColor = UIColor.init(named: "通用綠")
        button.setTitleColor(UIColor.init(named: "通用綠"), for: .normal)
        button.titleLabel?.font = UIFont.init(name: "PingFang-TC-Semibold", size: 16.0)
        
    }
    
    private func disableButton(_ button: UIButton){
        button.tintColor = UIColor.init(named: "標題黑")
        button.setTitleColor(UIColor.init(named: "標題黑"), for: .normal)
        button.titleLabel?.font = UIFont.init(name: "PingFang-TC-Regular", size: 16.0)
        
    }
    
    private func scrollTopPageButtonBottomLine(percent: CGFloat){
        let maxOffset = UIScreen.main.bounds.width / 3.0
        let scrollOffset = maxOffset * percent
        self.pageButtonBottomLineLeading.constant = scrollOffset
    }
}

extension NoticeViewController: NoticeViewProtocol {
    func onBindNewsListComplete(newsList: [NotiItem]) {
        if self.newsList == [] {
            self.newsList = newsList
        }else{
            self.newsList += newsList
        }
        isNewsLastPage = newsList.count < pageSize
        tableViews[2].setViewWith(itemList: newsList, notiType: .news)
    }
    
    func onBindNoticeListComplete(noticeList: [NotiItem]) {
        
        if self.noticeList == [] {
            self.noticeList = noticeList
        }else{
            self.noticeList += noticeList
        }
        isNotiLastPage = noticeList.count < pageSize
        tableViews[1].setViewWith(itemList: self.noticeList, notiType: .noti)
    }
    
}
extension NoticeViewController: NotificationTableViewProtocol {
    func pullRefresh(notiType: NotiType) {
        switch notiType {
        case .noti:
            isNotiLastPage = false
            self.noticeList = []
            self.presenter?.getNoticeList(pageIndex: 1, handleType: .coverPlateAlpha)
            
        case .news:
            isNewsLastPage = false
            self.newsList = []
            self.presenter?.getNewsList(pageIndex: 1, handleType: .coverPlateAlpha)
            
        default:
            ()
        }
    }
    
    func onStartLoading(notiType: NotiType) {
        switch notiType {
        case .noti:
            if isNotiLastPage {return}
            if self.noticeList.count % pageSize == 0 {
                self.presenter?.getNoticeList(pageIndex: (self.noticeList.count / 5) + 1, handleType: .ignore)
            }
        case .news:
            if isNewsLastPage {return}
            if self.newsList.count % pageSize == 0 {
                self.presenter?.getNewsList(pageIndex: (self.newsList.count / 5) + 1, handleType: .ignore)
            }
            
        default:
            ()
        }
    }
    
    func onTouchNoti(item: NotiItem) {
        handleLinkType(linkType: item.linkType!, linkValue: item.linkValue, linkText: nil)
    }
}
extension NoticeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != self.scrollView { return }
        
        let wholeWidth = scrollView.contentSize.width
        let nowOffsetX = scrollView.contentOffset.x
        
        let percent = nowOffsetX / (wholeWidth / 3.0)
        scrollTopPageButtonBottomLine(percent: percent)
        switchPageButton(toPage: lround(Double(percent)))
        
    }
    
}
