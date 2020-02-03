//
//  AirTicketViewController.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/20.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit

class AirTicketViewController: BaseViewController {
    
    @IBOutlet weak var grayBlurView: UIView!
    @IBOutlet weak var airSearchView: UIView!
    
    private var presenter: AirTicketPresenter?
    
    let transiton = GroupSlideInTransition()
    private var menuList : GroupMenuResponse? {
        didSet{
            setNavIcon()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        presenter = AirTicketPresenter(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setIsNavShadowEnable(false)
        self.grayBlurView.alpha = 0
        setSearchBorder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func loadData() {
        super.loadData()
        getAirMenu()
    }
    
    private func getAirMenu(){
        self.presenter?.getAirMenu(toolBarType: .tkt)
    }
    
    private func setSearchBorder(){
        airSearchView.setBorder(width: 0.5, radius: 14, color: UIColor.init(red: 230, green: 230, blue: 230))
    }
    
    private func setNavIcon(){
        self.setNavTitle(title: "機票")
        
        let contaceButtonView = UIButton(type: .system)
        
        let rightImage = #imageLiteral(resourceName: "home_contavt")
        contaceButtonView.setImage(rightImage, for: .normal)
        contaceButtonView.addTarget(self, action: #selector(self.onTouchContact), for: .touchUpInside)
        
        var contaceBarButtonItem = UIBarButtonItem(customView: contaceButtonView)
        contaceBarButtonItem = UIBarButtonItem(image: rightImage, style: .plain, target: self, action: #selector(self.onTouchContact))
        self.navigationItem.rightBarButtonItem = contaceBarButtonItem
        
        let menuButtonView = UIButton(type: .system)
        
        let leftImage = #imageLiteral(resourceName: "home_menu")
        menuButtonView.setImage(leftImage, for: .normal)
        menuButtonView.addTarget(self, action: #selector(self.onTouchMenu), for: .touchUpInside)
        
        var menuBarButtonItem = UIBarButtonItem(customView: menuButtonView)
        menuBarButtonItem = UIBarButtonItem(image: leftImage, style: .plain, target: self, action: #selector(self.onTouchMenu))
        
        self.navigationItem.leftBarButtonItem = menuBarButtonItem
        
    }
    
    @IBAction func screenEdge(_ sender: UIScreenEdgePanGestureRecognizer) {
        switch sender.edges {
        case .left:
            // 沒加 下面這行會一直 presentVC 會報錯
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
        vc.setVC(menuResponse: self.menuList!)
        present(vc, animated: true)
    }
    
    @objc func onTouchContact (){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "聯絡業務(團體)" , style: .default, handler: { (_) in
            self.onPopContactVC(messageSendType: .groupSale, navTitle: "留言")
        }))
        alert.addAction(UIAlertAction(title: "改善建議(團體)" , style: .default, handler: { (_) in
            self.onPopContactVC(messageSendType: .groupSuggest, navTitle: "改善建議")
        }))
        alert.addAction(UIAlertAction(title: "改善建議(票務)" , style: .default, handler: { (_) in
            self.onPopContactVC(messageSendType: .ticketFeedback, navTitle: "改善建議")
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    private func setSearchGes(){
        let ges = UITapGestureRecognizer(target: self, action: #selector(onTouchSearch))
        self.airSearchView.addGestureRecognizer(ges)
        self.airSearchView.isUserInteractionEnabled = true
    }
    
    private func onPopContactVC(messageSendType: MessageSendType, navTitle: String){
        
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

extension AirTicketViewController: GroupSliderViewControllerProtocol {
    func onTouchData(serverData: ServerData) {
        self.handleLinkType(linkType: serverData.linkType, linkValue: serverData.linkValue, linkText: serverData.linkName ?? "")
    }
}

extension AirTicketViewController: AirTicketViewProtocol {
    func onBindAirMenu(menu: GroupMenuResponse) {
        self.menuList = menu
    }
}

extension AirTicketViewController: UIViewControllerTransitioningDelegate {
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

extension AirTicketViewController: MessageSendToastDelegate {

    func setMessageSendToastText(text: String) {
        
        self.toast(text: text)
    }
}
