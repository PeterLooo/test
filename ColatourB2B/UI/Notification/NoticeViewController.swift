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
class NoticeViewController: BaseViewControllerMVVM {
    
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
    
    private var viewModel: NoticeViewModel?
    
    private var defaultNotiType: NotiType?
    
    private var tableViews: [NotificationTableView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reLoadData), name: Notification.Name("noticeLoadDate"), object: nil)
        setIsNavShadowEnable(false)
        setNavTitle(title: "通知")
        switchPageButton(sliderLeading: 0)
        setTableView()
        viewModel = NoticeViewModel()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        
        setDefaultNotyTypeToScroll()
    }
    
    override func loadData() {
        super.loadData()
        viewModel?.getList()
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

extension NoticeViewController {
    
    private func bindViewModel() {
        self.bindToBaseViewModel(viewModel: self.viewModel!)
        viewModel?.onGetNotiListError = { [weak self] type, apiError in
            switch type {
            case .important:
                self?.tableViews[0].handleApiError(apiError: apiError)
                self?.tableViews[0].endRefreshContolRefreshing()
            case .noti:
                self?.tableViews[1].handleApiError(apiError: apiError)
                self?.tableViews[1].endRefreshContolRefreshing()
            case .groupNews:
                self?.tableViews[2].handleApiError(apiError: apiError)
                self?.tableViews[2].endRefreshContolRefreshing()
            case .airNews:
                self?.tableViews[3].handleApiError(apiError: apiError)
                self?.tableViews[3].endRefreshContolRefreshing()
            }
        }
        
        viewModel?.onBindTableViewModel = { [weak self] tableViewModel in
            
            switch tableViewModel.notiType {
            case .important:
                self?.tableViews[0].setViewModel(viewModel: tableViewModel)
            case .noti:
                self?.tableViews[1].setViewModel(viewModel: tableViewModel)
            case .groupNews:
                self?.tableViews[2].setViewModel(viewModel: tableViewModel)
            case .airNews:
                self?.tableViews[3].setViewModel(viewModel: tableViewModel)
            default:
                ()
            }
        }
        
        viewModel?.toNoticeDetail = { [weak self] item in
            
            let vc = self?.getVC(st: "NoticeDetail", vc: "NoticeDetailViewController") as! NoticeDetailViewController
            vc.setVCwith(navTitle: "訊息明細",
                         notiTitle: item.notiTitle ?? "",
                         messageDate: item.notiDate,
                         sendUser: nil,
                         content: item.notiContent,
                         orderNo: nil,
                         groupNo: nil)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        viewModel?.setTopPageSheetStatus = { [weak self] type, status in
            switch type {
            case .important:
                
                self?.orderUnreadHint.isHidden = status
            case .noti:
                
                self?.messageUnreadHint.isHidden = status
            case .groupNews:
                
                self?.groupNewsUnreadHint.isHidden = status
            case .airNews:
                
                self?.airNewsUnreadHint.isHidden = status
            }
        }
    }
    
    private func setTableView() {
        
        stackView.subviews.forEach({$0.removeFromSuperview()})
        
        for _ in 0...3 {
            let view = NotificationTableView()
            view.apiFailErrorView.onTouchServiceAction = {[weak self] in
                let vc = self?.getVC(st: "ContactInfo", vc: "ContactInfo") as! ContactInfoViewController
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            view.apiFailErrorView.loadData = {[weak self] in
                self?.viewModel?.needReloadData = true
                self?.loadData()
            }
            
            view.noInternetErrorView.loadData = {[weak self] in
                self?.viewModel?.needReloadData = true
                self?.loadData()
            }
            stackView.addArrangedSubview(view)
            tableViews.append(view)
        }
        stackView.layoutIfNeeded()
        scrollView.layoutIfNeeded()
    }
    
    @objc private func reLoadData() {
        viewModel?.needReloadData = true
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
}

