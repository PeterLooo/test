//
//  NoticeViewController.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/20.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit
extension NoticeViewController {
    func setVC(defaultNoti: NotiType) {
        self.defaultNotiType = defaultNoti
    }
}
class NoticeViewController: BaseViewController {
    
    @IBOutlet weak var topButtonView: UIView!
    @IBOutlet weak var topOrderButton: UIButton!
    @IBOutlet weak var topMessageButton: UIButton!
    @IBOutlet weak var topGroupNewsButton: UIButton!
    @IBOutlet weak var topAirNewsButton: UIButton!
    @IBOutlet weak var pageButtonBottomLineLeading: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var orderUnreadHint: UIView!
    @IBOutlet weak var messageUnreadHint: UIView!
    @IBOutlet weak var groupNewsUnreadHint: UIView!
    @IBOutlet weak var airNewsUnreadHint: UIView!
    
    var presenter: NoticePresenter?
    private var defaultNotiType: NotiType?
    private var importantList: [NotiItem] = [] {
        didSet{
            setTopPageSheetStatus(notiType: .important)
        }
    }
    
    private var noticeList: [NotiItem] = [] {
        didSet{
            setTopPageSheetStatus(notiType: .noti)
        }
    }
    
    private var groupNewsList: [NotiItem] = [] {
        didSet{
            setTopPageSheetStatus(notiType: .groupNews)
        }
    }
    
    private var airNewsList: [NotiItem] = [] {
        didSet{
            setTopPageSheetStatus(notiType: .airNews)
        }
    }
    
    private var tableViews:[NotificationTableView] = []
    private var pageSize = 30
    private var isImportantLastPage = false
    private var isNotiLastPage = false
    private var isGroupNewsLastPage = false
    private var isAirNewsLastPage = false
    private var needReloadData = true
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.presenter = NoticePresenter(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reLoadData), name: Notification.Name("noticeLoadDate"), object: nil)
        setIsNavShadowEnable(false)
        setNavTitle(title: "通知")
        switchPageButton(sliderLeading: 0)
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if needReloadData {
            loadData()
            needReloadData = false
        }
        
        setDefaultNotyTypeToScroll()
    }
    
    override func loadData() {
        super.loadData()
        isImportantLastPage = false
        isNotiLastPage = false
        isGroupNewsLastPage = false
        isAirNewsLastPage = false
        importantList = []
        noticeList = []
        groupNewsList = []
        airNewsList = []
        NotificationCenter.default.post(name: Notification.Name("getUnreadCount"), object: nil)
        presenter?.getImportantList(pageIndex: 1, handleType: .coverPlate)
        presenter?.getNoticeList(pageIndex: 1, handleType: .coverPlate)
        presenter?.getGroupNewsList(pageIndex: 1, handleType: .coverPlate)
        presenter?.getAirNewsList(pageIndex: 1, handleType: .coverPlate)
    }
    
    private func setTableView() {
        
        stackView.subviews.forEach({$0.removeFromSuperview()})
       
        for i in 0...3 {
            let view = NotificationTableView()
            
            switch i {
            case 0:
                view.setViewWith(itemList: [], notiType: .important)
            
            case 1:
                view.setViewWith(itemList: [], notiType: .noti)
            
            case 2:
                view.setViewWith(itemList: [], notiType: .groupNews)
            
            case 3:
                view.setViewWith(itemList: [], notiType: .airNews)
            
            default:
                break
            }
            view.delegate = self
            view.apiFailErrorView.delegate = self
            view.noInternetErrorView.delegate = self
            stackView.addArrangedSubview(view)
            tableViews.append(view)
        }
        stackView.layoutIfNeeded()
        scrollView.layoutIfNeeded()
    }
    
    @objc private func reLoadData() {
        needReloadData = true
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
        
        case 3:
            contentOffset = screenWidth * 3
       
        default:
            contentOffset = 0
        }
        scrollView.setContentOffset(CGPoint.init(x: contentOffset, y: 0), animated: true)
    }
    
    private func switchPageButton(sliderLeading: CGFloat){
        
        switch sliderLeading {
        case (screenWidth / 4 * 0):
            enableButton(topOrderButton)
            disableButton(topMessageButton)
            disableButton(topGroupNewsButton)
            disableButton(topAirNewsButton)
        
        case (screenWidth / 4 * 1):
            disableButton(topOrderButton)
            enableButton(topMessageButton)
            disableButton(topGroupNewsButton)
            disableButton(topAirNewsButton)
            
        case (screenWidth / 4 * 2):
            disableButton(topOrderButton)
            disableButton(topMessageButton)
            enableButton(topGroupNewsButton)
            disableButton(topAirNewsButton)
            
        case (screenWidth / 4 * 3):
            disableButton(topOrderButton)
            disableButton(topMessageButton)
            disableButton(topGroupNewsButton)
            enableButton(topAirNewsButton)
            
        default:
            ()
        }
    }
    
    private func setDefaultNotyTypeToScroll() {
        if self.defaultNotiType != nil {

            let contentOffset = CGFloat(self.defaultNotiType?.rawValue ?? 0) * screenWidth
            scrollView.setContentOffset(CGPoint(x: contentOffset, y: 0), animated: false)
            self.defaultNotiType = nil
        }
    }
    
    private func enableButton(_ button: UIButton){
        let tittle = NSAttributedString(string: button.titleLabel?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor:UIColor.init(named: "通用綠")!])
        button.setAttributedTitle(tittle, for: .normal)
        button.titleLabel?.font = UIFont.init(name: "PingFang-TC-Semibold", size: 16.0)
    }
    
    private func disableButton(_ button: UIButton){
        let tittle = NSAttributedString(string: button.titleLabel?.text ?? "", attributes: [NSAttributedString.Key.foregroundColor:UIColor.init(named: "標題黑")!])
        button.setAttributedTitle(tittle, for: .normal)
        button.titleLabel?.font = UIFont.init(name: "PingFang-TC-Regular", size: 16.0)
    }
    
    private func scrollTopPageButtonBottomLine(percent: CGFloat){
        let maxOffset = UIScreen.main.bounds.width / 4.0
        let scrollOffset = maxOffset * percent
        self.pageButtonBottomLineLeading.constant = scrollOffset
        self.switchPageButton(sliderLeading: scrollOffset)
    }
    
    private func setTopPageSheetStatus(notiType: NotiType){
        
        switch notiType {
        case .important:
            self.orderUnreadHint.isHidden = true
            if let _ = importantList.filter({$0.unreadMark == true}).first {
                self.orderUnreadHint.isHidden = false
            }
        case .noti:
            self.messageUnreadHint.isHidden = true
            if let _ = noticeList.filter({$0.unreadMark == true}).first {
                self.messageUnreadHint.isHidden = false
            }
        case .groupNews:
            self.groupNewsUnreadHint.isHidden = true
            if let _ = groupNewsList.filter({$0.unreadMark == true}).first {
                self.groupNewsUnreadHint.isHidden = false
            }
        case .airNews:
            self.airNewsUnreadHint.isHidden = true
            if let _ = airNewsList.filter({$0.unreadMark == true}).first {
                self.airNewsUnreadHint.isHidden = false
            }
        }
    }
    
}

extension NoticeViewController: NoticeViewProtocol {
    func onGetNotiListError(notiType: NotiType, apiError: APIError) {
        switch notiType {
        case .important:
            self.tableViews[0].handleApiError(apiError: apiError)
            self.tableViews[0].endRefreshContolRefreshing()
        case .noti:
            self.tableViews[0].handleApiError(apiError: apiError)
            self.tableViews[0].endRefreshContolRefreshing()
        case .groupNews:
            self.tableViews[0].handleApiError(apiError: apiError)
            self.tableViews[0].endRefreshContolRefreshing()
        case .airNews:
            self.tableViews[0].handleApiError(apiError: apiError)
            self.tableViews[0].endRefreshContolRefreshing()
        
        }
    }
    
    func onBindSetNotiRead() {
        NotificationCenter.default.post(name: Notification.Name("getUnreadCount"), object: nil)
    }
    
    func onBindImportantComplete(importantList: [NotiItem]) {
        if self.importantList == [] {
            self.importantList = importantList
        }else{
            self.importantList += importantList
        }
        isImportantLastPage = importantList.count < pageSize
        tableViews[0].setViewWith(itemList: self.importantList, notiType: .important)
        tableViews[0].closeErrorView()
    }
    
    func onBindNoticeListComplete(noticeList: [NotiItem]) {
        if self.noticeList == [] {
            self.noticeList = noticeList
        }else{
            self.noticeList += noticeList
        }
        isNotiLastPage = noticeList.count < pageSize
        tableViews[1].setViewWith(itemList: self.noticeList, notiType: .noti)
        tableViews[1].closeErrorView()
    }
    
    func onBindGroupNewsListComplete(groupNewsList: [NotiItem]) {
        if self.groupNewsList == [] {
            self.groupNewsList = groupNewsList
        }else{
            self.groupNewsList += groupNewsList
        }
        isGroupNewsLastPage = groupNewsList.count < pageSize
        tableViews[2].setViewWith(itemList: self.groupNewsList, notiType: .groupNews)
        tableViews[2].closeErrorView()
    }
    
    func onBindAirNewsListComplete(airNewsList: [NotiItem]) {
        if self.airNewsList == [] {
            self.airNewsList = airNewsList
        }else{
            self.airNewsList += airNewsList
        }
        isAirNewsLastPage = airNewsList.count < pageSize
        tableViews[3].setViewWith(itemList: self.airNewsList, notiType: .airNews)
        tableViews[3].closeErrorView()
    }
}

extension NoticeViewController: NotificationTableViewProtocol {
    
    func pullRefresh(notiType: NotiType) {
        
        switch notiType {
        case .important:
            isImportantLastPage = false
            self.importantList = []
            self.presenter?.getImportantList(pageIndex: 1, handleType: .coverPlateAlpha)
            
        case .noti:
            isNotiLastPage = false
            self.noticeList = []
            self.presenter?.getNoticeList(pageIndex: 1, handleType: .coverPlateAlpha)
            
        case .groupNews:
            isGroupNewsLastPage = false
            self.groupNewsList = []
            self.presenter?.getGroupNewsList(pageIndex: 1, handleType: .coverPlateAlpha)
            
        case .airNews:
            isAirNewsLastPage = false
            self.airNewsList = []
            self.presenter?.getAirNewsList(pageIndex: 1, handleType: .coverPlateAlpha)
        }
    }
    
    func onStartLoading(notiType: NotiType) {
        
        switch notiType {
        case .important:
            if isImportantLastPage {return}
            if self.importantList.count % pageSize == 0 {
                self.presenter?.getImportantList(pageIndex: (self.importantList.count / 10) + 1, handleType: .ignore)
            }
        
        case .noti:
            if isNotiLastPage {return}
            if self.noticeList.count % pageSize == 0 {
                self.presenter?.getNoticeList(pageIndex: (self.noticeList.count / 10) + 1, handleType: .ignore)
            }
        
        case .groupNews:
            if isGroupNewsLastPage {return}
            if self.groupNewsList.count % pageSize == 0 {
                self.presenter?.getGroupNewsList(pageIndex: (self.groupNewsList.count / 10) + 1, handleType: .ignore)
            }
        
        case .airNews:
            if isAirNewsLastPage {return}
            if self.airNewsList.count % pageSize == 0 {
                self.presenter?.getAirNewsList(pageIndex: (self.airNewsList.count / 10) + 1, handleType: .ignore)
            }
        }
    }
    
    func onTouchNoti(item: NotiItem, notiType: NotiType) {
        
        if item.unreadMark == true {
            presenter?.setNoticeRead(noticeIdList: [item.notiId!])
            item.unreadMark = false
        }
        
        setTopPageSheetStatus(notiType: notiType)
        
        if item.apiNotiType == "Message" {
            let vc = self.getVC(st: "NoticeDetail", vc: "NoticeDetailViewController") as! NoticeDetailViewController
            vc.setVCwith(navTitle: "訊息明細",
                         notiTitle: item.notiTitle ?? "",
                         messageDate: item.notiDate,
                         sendUser: nil,
                         content: item.notiContent,
                         orderNo: nil,
                         groupNo: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            handleLinkType(linkType: item.linkType!, linkValue: item.linkValue, linkText: nil)
        }
    }
}

extension NoticeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != self.scrollView { return }
        
        let wholeWidth = scrollView.contentSize.width
        let nowOffsetX = scrollView.contentOffset.x
        
        let percent = nowOffsetX / (wholeWidth / 4.0)
        scrollTopPageButtonBottomLine(percent: percent)
    }
}
