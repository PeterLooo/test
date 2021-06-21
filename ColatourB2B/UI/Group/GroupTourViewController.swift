//
//  GroupToruViewController.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/13.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit

class GroupTourViewController: BaseViewControllerMVVM {
    
    @IBOutlet weak var topButtonView: UIView!
    @IBOutlet weak var pageButtonBottomLineLeading: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet var topBtn: [UIButton]!
    
    var viewModel: GroupTourViewModel?
    
    private var groupTableViews: [GroupTableView] = []
    private var menuList : GroupMenuResponse?
    private var needRefreshNavRight: Bool = true
    
    let transiton = GroupSlideInTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        NotificationCenter.default.addObserver(self, selector: #selector(self.getEmployeeMark), name: Notification.Name("getEmployeeMark"), object: nil)
        
        setIsNavShadowEnable(false)
        self.setNavBarItem(left: .custom, mid: .custom, right: .custom)
        setNavIcon()
        setUpTableView()
        setSearchView()
        
        // 為了不讓點推播重複去要 accessToken 先判斷 cancelLoadData
        if cancelLoadData == true {
            cancelLoadData = false
        }else{
            loadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if needRefreshNavRight {
            
            setContaceBarButtonItem()
            needRefreshNavRight = false
        }
        super.viewWillAppear(animated)
    }
    
    override func loadData() {
        super.loadData()
        
        viewModel?.getApiToken()
    }
    
    override func onLoginSuccess(){
        self.loadData()
    }
    
    @IBAction func screenEdge(_ sender: UIScreenEdgePanGestureRecognizer) {
        switch sender.edges {
        case .left:
            if self.presentedViewController?.restorationIdentifier == "GroupSliderViewController" {return}
            onTouchMenu()
        default:
            ()
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
    
    @objc private func getEmployeeMark() {
        
        needRefreshNavRight = true
    }
    
    @objc private func onTouchMenu() {
        let vc = getVC(st: "GroupTour", vc: "GroupSliderViewController") as! GroupSliderViewController
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.transitioningDelegate = self
        vc.onTouchData = { [weak self] data in
            self?.handleLinkType(linkType: data.linkType, linkValue: data.linkValue, linkText: data.linkName ?? "")
        }
        vc.setVC(menuResponse: self.menuList)
        present(vc, animated: true)
    }
    
    @objc private func onTouchContact (){
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "聯絡業務(團體)" , style: .default, handler: { (_) in
            self.onPopContactVC(messageSendType: "團體－連絡業務", navTitle: "留言")
        }))
        alert.addAction(UIAlertAction(title: "改善建議(團體)" , style: .default, handler: { (_) in
            self.onPopContactVC(messageSendType: "團體－改善建議", navTitle: "改善建議")
        }))
        alert.addAction(UIAlertAction(title: "改善建議(票務)" , style: .default, handler: { (_) in
            self.onPopContactVC(messageSendType: "票務－意見回饋", navTitle: "改善建議")
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))

        self.present(alert, animated: true)
    }
}

extension GroupTourViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        
        self.tabBarController?.tabBar.isHidden = true
        
        return transiton
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        self.tabBarController?.tabBar.isHidden = false
        
        return transiton
    }
}

extension GroupTourViewController: GroupNavigationViewProtocol{
    func onTouchSearchView() {
        let vc = getVC(st: "GroupTourSearch", vc: "GroupTourSearchViewController") as! GroupTourSearchViewController
        vc.setKeywordOrTourCodeDepartureCityShareOptionList(cityKey: viewModel?.focusOnType?.rawValue ?? "*")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension GroupTourViewController: MessageSendToastDelegate {

    func setMessageSendToastText(text: String) {
        
        self.toast(text: text)
    }
}
    
extension GroupTourViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != self.scrollView { return }
        
        let wholeWidth = scrollView.contentSize.width
        let nowOffsetX = scrollView.contentOffset.x
        
        let percent = nowOffsetX / (wholeWidth / 3.0)
        scrollTopPageButtonBottomLine(percent: percent)
    }
}

extension GroupTourViewController {
    
    private func bindViewModel() {
        viewModel = GroupTourViewModel()
        self.bindToBaseViewModel(viewModel: viewModel!)
        viewModel?.setTableViews = { [weak self] viewModel in
            
            switch viewModel.tourType {
            case .tour:
                self?.groupTableViews[0].bindViewModel(viewModel: viewModel)
                self?.groupTableViews[0].closeErrorView()
                self?.groupTableViews[0].endRefreshContolRefreshing()
            case .taichung:
                self?.groupTableViews[1].bindViewModel(viewModel: viewModel)
                self?.groupTableViews[1].closeErrorView()
                self?.groupTableViews[1].endRefreshContolRefreshing()
            case .kaohsiung:
                self?.groupTableViews[2].bindViewModel(viewModel: viewModel)
                self?.groupTableViews[2].closeErrorView()
                self?.groupTableViews[2].endRefreshContolRefreshing()
            default:
                ()
            }
            
            viewModel.onPullToRefresh = { [weak self] in
                self?.loadData()
            }
            
            viewModel.onTouchItem = {[weak self] item in
                self?.handleLinkType(linkType: item.linkType, linkValue: item.linkParams, linkText: nil)
            }
        }
        
        viewModel?.onBindGroupMenu = { [weak self] menu in
            self?.menuList = menu
        }
        
        viewModel?.onGetTourIndexError = { [weak self] tourType , apiError in
            switch tourType {
            case .tour:
                self?.groupTableViews[0].handleApiError(apiError: apiError)
                self?.groupTableViews[0].endRefreshContolRefreshing()
            case .taichung:
                self?.groupTableViews[1].handleApiError(apiError: apiError)
                self?.groupTableViews[1].endRefreshContolRefreshing()
            case .kaohsiung:
                self?.groupTableViews[2].handleApiError(apiError: apiError)
                self?.groupTableViews[2].endRefreshContolRefreshing()
            default:
                ()
            }
        }
        
        viewModel?.onGetGroupMenuError = { [weak self] in
            self?.menuList = nil
        }
        
        viewModel?.presentVersionVC = { [weak self] vc in
            self?.present(vc, animated: true, completion: nil)
        }
        
        viewModel?.presentBullentinVC = { [weak self] vc in
            self?.present(vc, animated: true, completion: nil)
        }
        
        viewModel?.focusOnView = { [weak self] type in
            self?.topBtn.forEach { (btn) in
                self?.enableButton(btn, isEnable: type.rawValue == btn.restorationIdentifier)
            }
        }
    }
    
    private func setUpTableView() {
        stackView.subviews.forEach({$0.removeFromSuperview()})
        for _ in 0...2 {
            let view = GroupTableView()
            
            view.apiFailErrorView.onTouchServiceAction = {[weak self] in
                let vc = self?.getVC(st: "ContactInfo", vc: "ContactInfo") as! ContactInfoViewController
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            view.apiFailErrorView.loadData = {[weak self] in
                self?.loadData()
            }
            
            view.noInternetErrorView.loadData = {[weak self] in
                self?.loadData()
            }
            
            stackView.addArrangedSubview(view)
            groupTableViews.append(view)
        }
    }
    
    private func setSearchView(){
        let view = GroupNavigationView()
            view.translatesAutoresizingMaskIntoConstraints = false
        
        view.delegate = self
        self.setCustomMidBarButtonItem(view: view)
    }

    private func setNavIcon(){
        
        let menuButtonView = UIButton(type: .system)
        
        let leftImage = #imageLiteral(resourceName: "home_menu")
        menuButtonView.setImage(leftImage, for: .normal)
        menuButtonView.addTarget(self, action: #selector(self.onTouchMenu), for: .touchUpInside)

        var menuBarButtonItem = UIBarButtonItem(customView: menuButtonView)
        menuBarButtonItem = UIBarButtonItem(image: leftImage, style: .plain, target: self, action: #selector(self.onTouchMenu))
        
        self.setCustomLeftBarButtonItem(barButtonItem: menuBarButtonItem)
    }

    private func setContaceBarButtonItem() {
        
        let contaceButtonView = UIButton(type: .system)
        
        let rightImage = #imageLiteral(resourceName: "home_contavt")
        contaceButtonView.setImage(rightImage, for: .normal)
        contaceButtonView.addTarget(self, action: #selector(self.onTouchContact), for: .touchUpInside)

        var contaceBarButtonItem = UIBarButtonItem(customView: contaceButtonView)
        contaceBarButtonItem = UIBarButtonItem(image: rightImage, style: .plain, target: self, action: #selector(self.onTouchContact))
        
        self.setCustomRightBarButtonItem(barButtonItem: (isEmployee == true) ? nil : contaceBarButtonItem)
    }

    private func enableButton(_ button: UIButton?, isEnable: Bool){
        guard let btn = button else {return}
        switch isEnable {
        case true:
            btn.tintColor = UIColor.init(named: "通用綠")
            btn.setTitleColor(UIColor.init(named: "通用綠"), for: .normal)
            btn.titleLabel?.font = UIFont.init(name: "PingFang-TC-Semibold", size: 16.0)
            
        case false:
            btn.tintColor = UIColor.init(named: "標題黑")
            btn.setTitleColor(UIColor.init(named: "標題黑"), for: .normal)
            btn.titleLabel?.font = UIFont.init(name: "PingFang-TC-Regular", size: 16.0)
        }
    }
    
    private func scrollTopPageButtonBottomLine(percent: CGFloat){
        let maxOffset = UIScreen.main.bounds.width / 3.0
        let scrollOffset = maxOffset * percent
        self.pageButtonBottomLineLeading.constant = scrollOffset
        self.viewModel?.switchPageButton(sliderLeading: scrollOffset)
    }
    
    private func onPopContactVC(messageSendType: String, navTitle: String){
        
        let messageSendViewController = getVC(st: "MessageSend", vc: "MessageSend") as! MessageSendViewController
        messageSendViewController.setVC(messageSendType: messageSendType, navTitle: navTitle)
        messageSendViewController.delegate = self
        
        let nav = UINavigationController(rootViewController: messageSendViewController)
        nav.modalPresentationStyle = .fullScreen
        self.navigationController?.present(nav, animated: true)
    }
}
