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
        
        creatSubViewControllers()
        
        self.tabBar.tintColor = UIColor.purple
    }
    
    func creatSubViewControllers(){
        let v1  = getVC(st: "GroupTour", vc: "GroupTourNavigationController")
        let item1 : UITabBarItem = UITabBarItem (title: "團體旅遊", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_focus"))
        v1.tabBarItem = item1
        
//        let v2 = getVC(st: "ScheduleIndex", vc: "ScheduleNavigationController")
//        let item2 : UITabBarItem = UITabBarItem (title: "機票", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_focus"))
//        v2.tabBarItem = item2
//
//        let v3 = getVC(st: "NoticeList", vc: "NoticeNavigationController")
//        let item3 : UITabBarItem = UITabBarItem (title: "通知", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_focus"))
//        v3.tabBarItem = item3
        
        let v4 = getVC(st: "MemberIndex", vc: "MemberNavigationController")
        let item4 : UITabBarItem = UITabBarItem (title: "會員", image: UIImage(named: "member"), selectedImage: UIImage(named: "member_focus"))
        v4.tabBarItem = item4
        
        let v5 = getVC(st: "MemberIndex", vc: "MemberNavigationController")
        let item5 : UITabBarItem = UITabBarItem (title: "更多", image: UIImage(named: "member"), selectedImage: UIImage(named: "member_focus"))
        v5.tabBarItem = item5
        let tabArray = [v1, v4]
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
    
}

extension TabBarViewController: TabBarViewProtocol{
    func onBindNumberOfNoticeUnreadCount(numbers: Int) {
        enableTabBarNotificationBadgeNumber(numbers > 0)
    }
    
    private func enableTabBarNotificationBadgeNumber(_ isEnable: Bool){
        self.tabBar.items?[2].selectedImage = isEnable ? #imageLiteral(resourceName: "notice_focus.png") : #imageLiteral(resourceName: "note_focus_origin.png")
        self.tabBar.items?[2].image = isEnable ? #imageLiteral(resourceName: "notice.png") : #imageLiteral(resourceName: "note_origin.png")
    }
}
