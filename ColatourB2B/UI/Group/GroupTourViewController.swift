//
//  GroupToruViewController.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/13.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit

class GroupTourViewController: BaseViewController {
    
    @IBOutlet weak var topButtonView: UIView!
    @IBOutlet weak var topGroupButton: UIButton!
    @IBOutlet weak var topTCButton: UIButton!
    @IBOutlet weak var topKSButton: UIButton!
    @IBOutlet weak var pageButtonBottomLineLeading: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    private var presenter: GropeTourPresenterProtocol?
    private var groupTableViews: [GroupTableView] = []
    private var needUpdateBannerImage = false
    private var menuList : GroupMenuResponse?
    private var needRefreshNavRight: Bool = true
    
    let transiton = GroupSlideInTransition()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        presenter = GropeTourPresenter(delegate: self)
    }
    var groupADList : [IndexResponse.MultiModule] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @objc private func getEmployeeMark() {
        
        needRefreshNavRight = true
    }
    
    override func loadData() {
        super.loadData()
        
        needUpdateBannerImage = true
        getApiToken()
    }
    
    private func getApiToken(){
        self.presenter?.getApiToken()
    }
    
    private func getVersionRule(){
        self.presenter?.getVersionRule()
    }
    
    private func getBulletin(){
        presenter?.getBulletin()
    }
    
    private func setUpTableView() {
        stackView.subviews.forEach({$0.removeFromSuperview()})
        for _ in 0...2 {
            let view = GroupTableView()
            view.setViewWith(itemList: [], needUpdateBannerImage: needUpdateBannerImage)
            view.delegate = self
            view.apiFailErrorView.delegate = self
            view.noInternetErrorView.delegate = self
            
            stackView.addArrangedSubview(view)
            groupTableViews.append(view)
        }
    }
    
    private func getGroupMenu(){
        if isLogin == false { return }
        self.presenter?.getGroupMenu(toolBarType: .tour)
        self.presenter?.getTourIndex(tourType: .tour)
        self.presenter?.getTourIndex(tourType: .taichung)
        self.presenter?.getTourIndex(tourType: .kaohsiung)
    }
    
    override func onLoginSuccess(){
        self.loadData()
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
    
    @IBAction func screenEdge(_ sender: UIScreenEdgePanGestureRecognizer) {
        switch sender.edges {
        case .left:
            if self.presentedViewController?.restorationIdentifier == "GroupSliderViewController" {return}
            onTouchMenu()
        default:
            ()
        }
    }
    
    @objc func onTouchMenu() {
        let vc = getVC(st: "GroupTour", vc: "GroupSliderViewController") as! GroupSliderViewController
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        vc.transitioningDelegate = self
        
        vc.setVC(menuResponse: self.menuList)
        present(vc, animated: true)
    }
    
    @objc func onTouchContact (){
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
            enableButton(topGroupButton)
            disableButton(topTCButton)
            disableButton(topKSButton)
            
        case 1:
            enableButton(topTCButton)
            disableButton(topGroupButton)
            disableButton(topKSButton)
            
        case 2:
            enableButton(topKSButton)
            disableButton(topTCButton)
            disableButton(topGroupButton)
            
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
    
    private func onPopContactVC(messageSendType: String, navTitle: String){
        
        let messageSendViewController = getVC(st: "MessageSend", vc: "MessageSend") as! MessageSendViewController
        messageSendViewController.setVC(messageSendType: messageSendType, navTitle: navTitle)
        messageSendViewController.delegate = self
        
        let nav = UINavigationController(rootViewController: messageSendViewController)
        nav.modalPresentationStyle = .fullScreen
        self.navigationController?.present(nav, animated: true)
    }
    
    @objc private func onTouchSearch(){
        ()
    }
}
extension GroupTourViewController: GroupSliderViewControllerProtocol {
    func onTouchData(serverData: ServerData) {
        self.handleLinkType(linkType: serverData.linkType, linkValue: serverData.linkValue, linkText: serverData.linkName ?? "")
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
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension GroupTourViewController: GroupTableViewProtocol {
    func onTouchItem(item: IndexResponse.ModuleItem) {
        self.handleLinkType(linkType: item.linkType, linkValue: item.linkParams, linkText: nil)
    }
    
    func onPullToRefresh(){
        loadData()
    }
}
extension GroupTourViewController: GropeTourViewProtocol {
    func onBindTourIndex(moduleDataList: [IndexResponse.MultiModule], tourType: TourType) {
        switch tourType {
        case .tour:
            self.groupTableViews[0].setViewWith(itemList: moduleDataList, needUpdateBannerImage: needUpdateBannerImage)
            self.groupTableViews[0].closeErrorView()
            self.groupTableViews[0].endRefreshContolRefreshing()
        case .taichung:
            self.groupTableViews[1].setViewWith(itemList: moduleDataList, needUpdateBannerImage: needUpdateBannerImage)
            self.groupTableViews[1].closeErrorView()
            self.groupTableViews[1].endRefreshContolRefreshing()
        case .kaohsiung:
            self.groupTableViews[2].setViewWith(itemList: moduleDataList, needUpdateBannerImage: needUpdateBannerImage)
            self.groupTableViews[2].closeErrorView()
            self.groupTableViews[2].endRefreshContolRefreshing()
        default:
            ()
        }
    }
    
    func onGetTourIndexError(tourType: TourType, apiError: APIError) {
        switch tourType {
        case .tour:
            self.groupTableViews[0].handleApiError(apiError: apiError)
            self.groupTableViews[0].endRefreshContolRefreshing()
        case .taichung:
            self.groupTableViews[1].handleApiError(apiError: apiError)
            self.groupTableViews[1].endRefreshContolRefreshing()
        case .kaohsiung:
            self.groupTableViews[2].handleApiError(apiError: apiError)
            self.groupTableViews[2].endRefreshContolRefreshing()
        default:
            ()
        }
    }
    
    func onBindGroupMenu(menu: GroupMenuResponse) {
        self.menuList = menu
    }
    
    func onGetGroupMenuError() {
        self.menuList = nil
    }
    
    func onBindApiTokenComplete() {
        
        presenter?.getAccessToken()
    }
    
    func onBindAccessTokenSuccess() {
        getVersionRule()
    }
    
    func onBindVersionRule(versionRule: VersionRuleReponse.Update?) {
        if versionRule == nil {
            getBulletin()
            getGroupMenu()
            NotificationCenter.default.post(name: Notification.Name("getUnreadCount"), object: nil)
            return
        }
        
        if let updateNo = UserDefaultUtil.shared.updateNo, updateNo >= versionRule!.updateNo! {
            getBulletin()
            getGroupMenu()
            NotificationCenter.default.post(name: Notification.Name("getUnreadCount"), object: nil)
            return
        }
        
        let sb = UIStoryboard(name: "VersionRule", bundle:nil)
        let vca = sb.instantiateViewController(withIdentifier: "VersionRuleViewController") as! VersionRuleViewController
        vca.modalPresentationStyle = .overFullScreen
        vca.setVersionRule(versionRule: versionRule!)
        vca.delegate = self
        self.present(vca, animated: true, completion: nil)
    }
    
    func onBindVersionRuleError() {
        getBulletin()
        getGroupMenu()
        NotificationCenter.default.post(name: Notification.Name("getUnreadCount"), object: nil)
    }
    
    func onBindBulletin(bulletin: BulletinResponse.Bulletin?) {
        if bulletin == nil {
            return
        }
        
        if let bulletinNo = UserDefaultUtil.shared.bulletinNo, bulletinNo >= bulletin!.bulletinNo! {
            return
        }
        
        let sb = UIStoryboard(name: "Bulletin", bundle:nil)
        let vca = sb.instantiateViewController(withIdentifier: "BulletinViewController") as! BulletinViewController
        vca.modalPresentationStyle = .overFullScreen
        vca.delegate = self
        vca.setVCWith(bulletin: bulletin!)
        self.present(vca, animated: true, completion: nil)
        UserDefaultUtil.shared.bulletinNo = bulletin!.bulletinNo ?? 0
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
        switchPageButton(toPage: lround(Double(percent)))
    }
}

extension GroupTourViewController: VersionRuleViewControllerProtocol {
    func onDismissVersionRuleViewController() {
        ()
    }
    
    func onDismissVersionRuleViewControllerCompletion(){
        getBulletin()
        getGroupMenu()
        NotificationCenter.default.post(name: Notification.Name("getUnreadCount"), object: nil)
    }
}

extension GroupTourViewController: BulletinViewControllerProtocol {
    func onTouchBulletinLink(linkType: LinkType, linkValue: String?, linkText: String?) {
        self.handleLinkType(linkType: linkType, linkValue: linkValue, linkText: linkText)
    }
    
    func onDismissBulletinViewController() {
        ()
    }
    
    func onDismissBulletinViewControllerCompletion() {
        ()
    }
}
