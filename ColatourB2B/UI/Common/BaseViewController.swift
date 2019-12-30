//
//  BaseViewController.swift
//  colatour
//
//  Created by M6853 on 2018/2/13.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit
import UserNotifications

extension BaseViewController {
    //非立即轉變
    func setTabBarType(tabBarType: TabBarType) {
        self.tabBarType = tabBarType
    }

    //非立即轉變
    func setNavType(navBarType: NavBarType) {
        self.navBarType = navBarType
    }

    //非立即轉變
    func setNavBarItem(left: NavLeftType, mid: NavMidType, right: NavRightType) {
        self.navLeftType = left
        self.navMidType = mid
        self.navRightType = right
    }

    func setBarAlpha(animate: Bool) {
        switch animate {
        case true:
            UIView.animate(withDuration: 0.2) {
                self.adjustNavTitle()
                self.adjustBarAlpha()
                self.adjustNavShadow()
            }
        case false:
            adjustNavTitle()
            adjustBarAlpha()
            adjustNavShadow()
        }
    }

    func setBarAlpha(alpha: CGFloat, animate: Bool) {
        self.navAlpha = alpha
        setBarAlpha(animate: animate)
    }

    func setNavTitle(title: String) {
        self.navTitle = title
        self.adjustNavTitle()
    }
    
    func setNavTitleColor(_ color: UIColor) {
        self.navTitleColor = color
    }

    //非立即轉變
    func setIsNavHideWhenSwipe(_ enable: Bool) {
        self.isNavHidesBarsOnSwipe = enable
    }

    //非立即轉變
    func setIsNavShadowEnable(_ enable: Bool) {
        self.isNavShadowEnable = enable
    }

    func setIsNeedToPopVCWhenLoginClose(_ enable: Bool) {
        self.isNeedToPopVCWhenLoginClose = enable
    }
    
    //非立即轉變、使用前要setNavType .custom
    func setCustomLeftBarButtonItem(barButtonItem : UIBarButtonItem?) {
        self.customLeftBarButtonItem = barButtonItem
    }

    //非立即轉變、使用前要setNavType .custom
    func setCustomMidBarButtonItem(view : UIView?) {
        self.customMidBarButtonItem = view
    }
    
    //非立即轉變、使用前要setNavType .custom
    func setCustomRightBarButtonItem(barButtonItem : UIBarButtonItem?) {
        self.customRightBarButtomItem = barButtonItem
    }
    
    func setBarTypeLayoutImmediately() {
        adjustViewAppearance()

        adjustBarIsHiddenOrNot()
        adjustNavBarItem()

        adjustNavTitle()
        adjustNavTitleColor()
        adjustBarAlpha()
        adjustNavShadow()
        adjustTabBarHeight()
        adjustNavHideWhenSwipe()
    }
    
}

extension BaseViewController {
    func toast(text: String) {
        self.toastView.toast(text: text)
    }

    func addToastViewBottomHeight(height: CGFloat) {
        self.toastView.addToastViewBottomHeight(height)
    }

    func resetToastViewBottomHeight() {
        self.toastView.resetToastViewBottomHeight()
    }
}

//MARK: Other
extension BaseViewController {
    func getVC(st: String, vc: String) -> UIViewController {
        let storyboard = UIStoryboard(name: st, bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: vc)

        return viewController
    }

    func safeReload(tableView: UITableView, section: Int) {
        if (tableView.numberOfRows(inSection: section) == 0) {
            //如果Section中row數量為零，不reload
            return
        }

        tableView.beginUpdates()
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .fade)
        tableView.endUpdates()
    }

    func safeReload(tableView: UITableView, section: Int, row: Int) {
        if (tableView.numberOfRows(inSection: section) == 0) {
            //如果Section中row數量為零，不reload
            return
        }

        if (tableView.numberOfRows(inSection: section) < row + 1) {
            //如果Section中row數量不到row，不reload
            return
        }

        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath.init(row: row, section: section)], with: .fade)
        tableView.endUpdates()
    }

    func safeReload(tableView: UITableView, numberOfSection: Int) {
        if (tableView.numberOfRows(inSection: numberOfSection) == 0) {
            //如果Section中row數量為零，不reload
            return
        }
        let range = NSMakeRange(0, numberOfSection)
        let sections = NSIndexSet(indexesIn: range)

        tableView.beginUpdates()
        tableView.reloadSections(sections as IndexSet, with: .fade)
        tableView.endUpdates()
    }

}

class BaseViewController: UIViewController {
    
    private var loadingAPICount = 0

    let loadingView = LoadingView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    let noInternetErrorView = NoInternetErrorView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    let apiFailErrorView = ApiFailErrorView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    let toastView = ToastView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

    private var tabBarType: TabBarType = .notHidden
    private var navBarType: NavBarType = .notHidden
    private var navLeftType: NavLeftType = .defaultType
    private var navMidType: NavMidType = .textTitle
    private var navRightType: NavRightType = .nothing

    private var isNavHideWhenSwipe = false
    private var isNavShadowEnable = true
    private var isNavHidesBarsOnSwipe = false
    private var isPageSheetPresenting = false
    private var statusBar : UIView? {
        
        if #available(iOS 13.0, *) {
            if let existStatusBar = UIApplication.shared.keyWindow?.subviews.filter({$0.restorationIdentifier == "statusBar"}).first {
                existStatusBar.layer.zPosition = 1
                return existStatusBar
            }else{
                let statusBar = UIView(frame: UIApplication.shared.statusBarFrame)
                statusBar.restorationIdentifier = "statusBar"
                UIApplication.shared.keyWindow?.addSubview(statusBar)
                return statusBar
            }
        } else {
            return UIApplication.shared.value(forKey: "statusBar") as? UIView
        }
    }

    private var navAlpha: CGFloat = 1.0

    private var navTitle: String = ""
    private var navTitleColor: UIColor = ColorHexUtil.hexColor(hex: "#333333")
    
    private var nilButton: UIBarButtonItem?
    
    private var customLeftBarButtonItem : UIBarButtonItem?
    private var customMidBarButtonItem : UIView?
    private var customRightBarButtomItem : UIBarButtonItem?

    private var isNeedToPopVCWhenLoginClose = false
    
    private var source: String?
    private var basePresenter: BasePresenter?
    var topAnchor: NSLayoutYAxisAnchor{
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.topAnchor
        } else {
            return view.topAnchor
        }
    }
    
    var leadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.leadingAnchor
        } else {
            return view.leadingAnchor
        }
    }
    
    var trailingAnchor: NSLayoutXAxisAnchor{
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.trailingAnchor
        } else {
            return view.trailingAnchor
        }
    }
    
    var bottomAnchor: NSLayoutYAxisAnchor{
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.bottomAnchor
        } else {
            return view.bottomAnchor
        }
    }

    enum TabBarType {
        case notHidden
        case hidden
    }

    enum NavBarType {
        case notHidden
        case hidden
    }

    enum NavLeftType {
        case icon
        case defaultType
        case close
        case custom
    }

    enum NavMidType {
        case textTitle
        case custom
    }

    enum NavRightType {
        case nothing
        case custom
        case nothingWithEmptySpace
    }

    override func viewDidLoad() {
        super.viewDidLoad()
         basePresenter = BasePresenter(delegate: self)
        setUpLoadingView()
        setUpErrorViews()
        setUpToastView()
        setUpNilButton()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setBarTypeLayoutImmediately()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.bringSubviewToFront(loadingView)
        view.bringSubviewToFront(apiFailErrorView)
        view.bringSubviewToFront(noInternetErrorView)
        view.bringSubviewToFront(toastView)
    }

    func adjustViewAppearance() {
        self.navigationController?.navigationBar.accessibilityIdentifier = "navigationBar"
    }

    func onApiErrorHandle(apiError: APIError, handleType: APIErrorHandleType) {
        //Note: 務必連動BaseViewController onApiErrorHandle ，除了需要客製化的錯誤
        switch apiError.type {
        case .apiUnauthorizedException:
            AccountRepository.shared.removeLocalApiToken()

        case .noInternetException:
            self.handleNoInternetError(handleType: handleType)

        case .apiForbiddenException:
            basePresenter?.getAccessToken()

        case .apiFailException:
            self.handleApiFailError(handleType: handleType, alertMsg: apiError.alertMsg)
        case .apiFailForUserException:
            self.handleApiFailError(handleType: handleType, alertMsg: apiError.alertMsg)
        case .requestTimeOut:
            self.handleApiFailError(handleType: handleType, alertMsg: apiError.alertMsg)
        case .otherException:
            self.handleApiFailError(handleType: handleType, alertMsg: apiError.alertMsg)
        case .presentLogin:
            self.logoutAndPopLoginVC()
        }
    }

    func onStartLoadingHandle(handleType: APILoadingHandleType) {
        self.loadingAPICount += 1
        self.handleLoading(handleType: handleType)
        self.apiFailErrorView.isHidden = true
    }

    func onCompletedLoadingHandle() {
        //TODO 由 presenter 或各自的view控管什麼時候要關
        self.loadingAPICount -= 1
        self.loadingView.isHidden = (self.loadingAPICount == 0) ? true : self.loadingView.isHidden
        self.view.isUserInteractionEnabled = (self.loadingAPICount == 0) ? true : self.view.isUserInteractionEnabled
    }

    private func handleLoading(handleType: APILoadingHandleType) {
        switch handleType {
        case .coverPlate:
            //editing
            self.loadingView.backgroundColor = UIColor.white
            self.loadingView.backgroundView.backgroundColor = UIColor.white
            self.loadingView.backgroundView.backgroundColor = UIColor.white.withAlphaComponent(1)
            self.loadingView.isUserInteractionEnabled = true
            self.view.isUserInteractionEnabled = false
            self.loadingView.isHidden = false
        case .notBlock:
            self.loadingView.backgroundColor = UIColor.clear
            self.loadingView.backgroundView.backgroundColor = UIColor.clear
            self.loadingView.isUserInteractionEnabled = false
            self.view.isUserInteractionEnabled = true
            self.loadingView.isHidden = true
        case .clearBackgroundAndCantTouchView:
            self.loadingView.backgroundColor = UIColor.clear
            self.loadingView.backgroundView.backgroundColor = UIColor.clear
            self.loadingView.isUserInteractionEnabled = false
            self.loadingView.isHidden = false
            //注意:loading時阻擋viewControlelr動作，但不包含navigationBar，完成loading時，再打開
            self.view.isUserInteractionEnabled = false
        case .custom:
            self.view.isUserInteractionEnabled = true
            self.loadingView.isHidden = true
        case .coverPlateAlpha:
            self.loadingView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            self.loadingView.backgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            self.loadingView.backgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            self.view.isUserInteractionEnabled = true
            self.loadingView.isUserInteractionEnabled = true
            self.loadingView.isHidden = false
        case .ignore:
            ()
        }
    }

    private func setUpLoadingView() {
        self.loadingView.setUpLoadingView()
        self.view.addSubview(loadingView)
    }

    private func setUpErrorViews() {
        apiFailErrorView.delegate = self
        apiFailErrorView.setUpApiFailErrorView()
        self.view.addSubview(apiFailErrorView)

        noInternetErrorView.delegate = self
        noInternetErrorView.setUpNoInternetErrorView()
        self.view.addSubview(noInternetErrorView)
    }

    private func setUpToastView() {
        self.view.addSubview(toastView)
    }

    @objc func loadData() {
        self.noInternetErrorView.isHidden = true
        self.apiFailErrorView.isHidden = true
    }

    //Note: 注意如果直接使用，要小心設計isNeedToPopVCwhenLoginClose事件
    func logoutAndPopLoginVC(isAllowPaxButtonEnable: Bool = false) {
        let vc = getVC(st: "Login", vc: "LoginViewController") as! LoginViewController
        vc.modalPresentationStyle = .overCurrentContext
        
        let nav = UINavigationController(rootViewController: vc)
        nav.restorationIdentifier = "LoginNavigationController"
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }

    func logoutAndPopLoginVC(linkType: LinkType) {
       
    }
}
extension BaseViewController: MemberLoginSuccessViewProtocol {
    func onLoginSuccess(linkType: LinkType, linkValue: String?) {
         handleLinkType(linkType: linkType, linkValue: linkValue, linkText: nil)
    }
    
    @objc func onLoginSuccess() {
        ()
    }
}
extension BaseViewController: MemberLoginOnTouchNavCloseProtocol {
    @objc func onTouchLoginNavClose() {
        //Note: 不要覆寫
        switch isNeedToPopVCWhenLoginClose {
        case true:
            self.navigationController?.popViewController(animated: true)
        case false:
            //Note: do nothing
            ()
        }
    }
}
extension BaseViewController: BaseViewProtocol {
    func onBindAccessToken(response: AccessTokenResponse) {
        ()
    }
}
//MARK: Nav Appearance
extension BaseViewController {
    private func adjustBarIsHiddenOrNot() {
        switch tabBarType {
        case .notHidden:
            self.tabBarController?.tabBar.isHidden = false
        case .hidden:
            self.tabBarController?.tabBar.isHidden = true
        }

        switch navBarType {
        case .notHidden:
            self.navigationController?.navigationBar.isHidden = false
        case .hidden:
            self.navigationController?.navigationBar.isHidden = true
        }
    }

    private func adjustNavBarItem() {
        if (navBarType == .hidden) {
            return
        }
        switch navLeftType {
        case .icon:
            let logoImage = #imageLiteral(resourceName: "colatour_logo").withRenderingMode(.alwaysOriginal)
            let imageV = UIImageView.init(image: logoImage)
            let barButton = UIBarButtonItem(customView: imageV)
            barButton.customView?.frame = CGRect(x: 0, y: 0, width: 36, height: 27)
            self.navigationItem.leftBarButtonItem = barButton

        case .defaultType:
            self.navigationItem.leftBarButtonItem = nil

            //主要是storyBoard Nav右邊的back要給一個空白
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem?.title = " "
            self.navigationController?.navigationBar.backItem?.title = " "
            self.navigationController?.navigationBar.topItem?.title = " "
        case .close:
            let closeImage = #imageLiteral(resourceName: "close.png").withRenderingMode(.alwaysOriginal)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: closeImage, style: .plain, target: self, action: #selector(onTouchNavClose))
            
        case .custom:
            self.navigationItem.leftBarButtonItem = customLeftBarButtonItem
        }

        switch navMidType {
        case .textTitle:
            self.navigationItem.titleView = nil
            self.adjustNavTitle()
            
        case .custom:
            self.navigationItem.titleView = customMidBarButtonItem
        }

        switch navRightType {

        case .nothing:
            self.navigationItem.rightBarButtonItem = nilButton
        case .nothingWithEmptySpace:
            self.navigationItem.rightBarButtonItem = nil
            
        case .custom:
            self.navigationItem.rightBarButtonItem = customRightBarButtomItem
        }

    }
    
    func setIsPageSheetPresenting(isPresentVC:Bool) {
        isPageSheetPresenting = isPresentVC
    }
    
    private func adjustBarAlpha() {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.white.withAlphaComponent(navAlpha)
        if isPageSheetPresenting == true && self.modalPresentationStyle == .pageSheet {
            self.navigationController?.navigationBar.tintColor = UIColor.init(named: "通用綠")
            statusBar?.backgroundColor = UIColor.clear
            self.navigationController?.navigationBar.barStyle = UIBarStyle.black
            return
        }
        switch navAlpha {
        case 1.0:
            self.navigationController?.navigationBar.tintColor = UIColor.init(named: "通用綠")
            statusBar?.backgroundColor = UIColor.white
            self.navigationController?.navigationBar.barStyle = UIBarStyle.default

        case 0.0:
            self.navigationController?.navigationBar.tintColor = UIColor.white
            statusBar?.backgroundColor = UIColor.clear
            self.navigationController?.navigationBar.barStyle = UIBarStyle.black

        default: ()
        }
    }

    private func adjustNavShadow() {
        if (self.isNavShadowEnable == false) {
            self.navigationController?.navigationBar.setShadow(offset: CGSize(width: 0, height: 0), opacity: 0.0, shadowRadius: 0)
            return
        }
        switch navAlpha {
        case 1.0:
            self.navigationController?.navigationBar.setShadow(offset: CGSize(width: 0, height: 1), opacity: 0.2, shadowRadius: 2)
        case 0.0:
            self.navigationController?.navigationBar.setShadow(offset: CGSize(width: 0, height: 0), opacity: 0.0, shadowRadius: 0)
        default: ()
        }
    }

    private func adjustNavTitle() {
        switch navAlpha {
        case 1.0:
            self.navigationItem.title = navTitle
        case 0.0:
            self.navigationItem.title = ""
        default: ()
        }
    }
    
    private func adjustNavTitleColor() {
        self.navigationController?.navigationBar.titleTextAttributes =
            [.foregroundColor: navTitleColor]
    }

    private func adjustNavHideWhenSwipe() {
        self.navigationController?.hidesBarsOnSwipe = isNavHideWhenSwipe
    }

    private func setUpNilButton() {
        let barButton = UIBarButtonItem(customView: UIView())
        barButton.customView?.frame = CGRect(x: 0, y: 0, width: 40, height: 56)
        self.nilButton = barButton
    }

    private func adjustTabBarHeight() {
        if #available(iOS 11.0, *) {
            if self.view.safeAreaInsets.bottom != 0 {
                self.tabBarController?.tabBar.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - self.view.safeAreaInsets.bottom, width: screenWidth, height: self.view.safeAreaInsets.bottom)
            }
        }
    }

    //Note: 通常不會需要override，只有在TouchClose需要特別事件的時候
    //Note: EX: B彈出C，點C的close，需要連同Ｂ一起close
    @objc func onTouchNavClose() {
        //Note: 需要時可覆寫
        self.dismiss(animated: true, completion: nil)
    }
}

extension BaseViewController {
    //Note: 除了onApiErrorHandle Function，其他地方盡量不要用到他
    func handleNoInternetError(handleType: APIErrorHandleType) {
        switch handleType {
        case .coverPlate:
            self.noInternetErrorView.isHidden = false
        case .alert:
            let alertSeverError: UIAlertController = UIAlertController(title: "目前沒有連線", message: "請檢查網路連線設定或稍後再試。", preferredStyle: .alert)
            let action = UIAlertAction(title: "確定", style: UIAlertAction.Style.default, handler: nil)
            alertSeverError.addAction(action)
            self.present(alertSeverError, animated: true)
        case .toast:
            self.toastView.toast(text: "請檢查網路連線設定或稍後再試。")
        case .custom:
            ()
        }
    }

    //Note: 除了onApiErrorHandle Function，其他地方盡量不要用到他
    func handleApiFailError(handleType: APIErrorHandleType, alertMsg: String?) {
        var msg = alertMsg ?? "系統異常，請稍後再試。"
        var title = "請修正錯誤"
        if (msg == "") {
            msg = "系統異常，請稍後再試。";
            title = "系統異常"
        }

        switch handleType {
        case .coverPlate:
            self.apiFailErrorView.isHidden = false
        case .alert:
            let alertSeverError: UIAlertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            let action = UIAlertAction(title: "確定", style: UIAlertAction.Style.default, handler: nil)
            alertSeverError.addAction(action)
            self.present(alertSeverError, animated: true)
        case .toast:
            self.toastView.toast(text: msg)
        case .custom:
            ()
        }
    }
}



extension BaseViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        handleLinkType(linkType: .unknown, linkValue: nil, linkText: nil)

        return false
    }
}

class CustomSearchBar: UISearchBar {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.layoutFittingExpandedSize.width, height: 56.0)
    }
}

extension BaseViewController {
    func handleLinkType(linkType: LinkType, linkValue: String?, linkText: String?, source: String? = nil) {
        handleLinkTypePush(linkType: linkType, linkValue: linkValue, linkText: linkText, paxToken: nil, source: source)
    }

    func handleLinkType(linkType: LinkType, linkValue: String?, linkText: String?, paxToken: String?, source: String? = nil) {
        handleLinkTypePush(linkType: linkType, linkValue: linkValue, linkText: linkText, paxToken: paxToken, source: source)
    }

    private func handleLinkTypePush(linkType: LinkType, linkValue: String?, linkText: String?, paxToken: String?, source: String?) {
        var vc: UIViewController?
        switch linkType {
        case .web:
            if let url = linkValue {
                if let browserUrl = URL(string: url) {
                    if browserUrl.scheme == "http"{
                        UIApplication.shared.open(browserUrl, options: [:], completionHandler: nil)
                    }else{
                        vc = getVC(st: "Common", vc: "WebViewController") as! WebViewController
                        (vc as! WebViewController).setVCwith(url: url, title: linkText ?? "")
                    }
                }
            }
        
        case .unknown:
            //Note: doNothing
            ()
        }

        if let v = vc {
            self.navigationController?.pushViewController(v, animated: true)
        }
    }
    
}
