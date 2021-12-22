//
//  TabBarViewController.swift
//  ColatourB2B
//
//  Created by M7268 on 2019/4/1.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    private var presenter: TabBarPresenterProtocol?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        presenter = TabBarPresenter.init(delegate: self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        var bottomInset : CGFloat = 0
        if #available(iOS 11, *) {
            bottomInset = view.safeAreaInsets.bottom
        }

        var tabFrame = tabBar.frame
        tabFrame.size.height = bottomInset + 49
        tabFrame.origin.y = self.view.frame.size.height - ( bottomInset + 49 )
        tabBar.frame = tabFrame
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch tabBarLinkType {
        case .tour:
            self.selectedIndex = (isAllowTour == true) ? 0 : 3
            
        case .ticket:
            self.selectedIndex = (isAllowTkt == true) ? 1 : 3
            
        case .notification:
            self.selectedIndex = 2
            
        case .unknown:
            self.selectedIndex = 3
        }
        
        self.viewControllers?[0].tabBarItem.isEnabled = isAllowTour ?? false
        self.viewControllers?[1].tabBarItem.isEnabled = isAllowTkt ?? false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getUnreadCount), name: Notification.Name("getUnreadCount"), object: nil)
        creatSubViewControllers()
        setUpTabbar()
    }
    
    func creatSubViewControllers(){
        let v1  = getVC(st: "GroupTour", vc: "GroupTourNavigationController")
        let item1 : UITabBarItem = UITabBarItem (title: "團體旅遊", image: UIImage(named: "tourgroup_Inactive"), selectedImage: UIImage(named: "tourgroup_active"))
        v1.tabBarItem = item1
        
        let v2 = getVC(st: "AirTicket", vc: "AirTicketNavigationController")
        let item2 : UITabBarItem = UITabBarItem (title: "機票", image: UIImage(named: "flight_inactive"), selectedImage: UIImage(named: "flight_active"))
        v2.tabBarItem = item2

        let v3 = getVC(st: "Notice", vc: "NoticeNavigationController")
        let item3 : UITabBarItem = UITabBarItem (title: "通知", image: UIImage(named: "notice_Inactive"), selectedImage: UIImage(named: "notice_active"))
        v3.tabBarItem = item3
        
        let v4 = getVC(st: "MemberIndex", vc: "MemberNavigationController")
        let item4 : UITabBarItem = UITabBarItem (title: "會員", image: UIImage(named: "member_Inactive"), selectedImage: UIImage(named: "member_active"))
        v4.tabBarItem = item4
        
        let v5 = getVC(st: "More", vc: "MoreNavigationController")
        let item5 : UITabBarItem = UITabBarItem (title: "更多", image: UIImage(named: "more_inactive"), selectedImage: UIImage(named: "more_active"))
        v5.tabBarItem = item5
        
        let tabArray = [v1, v2, v3, v4, v5]
        self.viewControllers = tabArray
        self.tabBar.tintColor = UIColor.lightGray
    }
    
    func selectIndex(tabBarController: UITabBarController, index:Int) {
        tabBarController.selectedIndex = index
        if let vc = tabBarController.viewControllers?[index] as? UINavigationController{
            vc.popToRootViewController(animated: false)
        }
    }
    
    func getVC(st: String, vc: String) -> UIViewController{
        let storyboard = UIStoryboard(name: st, bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: vc)
        
        return viewController
    }
    
    @objc func getUnreadCount(){
        if isLogin {
            self.presenter?.getNumberOfNoticeUnreadCount()
        } else {
            enableTabBarNotificationBadgeNumber(false)
        }
    }
    
    private func setUpTabbar() {
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
        self.tabBar.tintColor = UIColor(named: "TabBar綠")
    }
}

extension TabBarViewController: TabBarViewProtocol{
    func onBindNumberOfNoticeUnreadCount(numbers: Int) {
        enableTabBarNotificationBadgeNumber(numbers > 0)
    }
    
    private func enableTabBarNotificationBadgeNumber(_ isEnable: Bool){
        self.tabBar.items?[2].selectedImage = isEnable ? #imageLiteral(resourceName: "notice_active_badge") : #imageLiteral(resourceName: "notice_active")
        self.tabBar.items?[2].image = isEnable ? #imageLiteral(resourceName: "notice_Inactive_badge") : #imageLiteral(resourceName: "notice_Inactive")
    }
}
