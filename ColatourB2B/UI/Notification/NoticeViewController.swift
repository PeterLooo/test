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
    
    var presenter: NoticePresenter?
    private var noticeList: NoticeResponse?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.presenter = NoticePresenter(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setIsNavShadowEnable(false)
        setNavTitle(title: "通知")
        switchPageButton(toPage: 0)
        stackView.subviews.forEach({$0.removeFromSuperview()})
        
        loadData()
    }
    
    override func loadData() {
        super.loadData()
        presenter?.getNoticeList()
    }
    
    private func setTableView() {
        
        for i in 0...2 {
            let view = NotificationTableView()
            switch i {
            case 0:
                view.setViewWith(itemList: self.noticeList!.order)
            case 1:
                view.setViewWith(itemList: self.noticeList!.message)
            case 2:
                view.setViewWith(itemList: self.noticeList!.news)
            default:
                break
            }
            view.delegate = self
            stackView.addArrangedSubview(view)
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
    func onBindNoticeListComplete(noticeList: NoticeResponse) {
        self.noticeList = noticeList
        setTableView()
    }
    
}
extension NoticeViewController: NotificationTableViewProtocol {
    func onTouchNoti(item: NoticeResponse.Item) {
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
