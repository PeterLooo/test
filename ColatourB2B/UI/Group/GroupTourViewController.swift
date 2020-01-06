//
//  GroupToruViewController.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/13.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit

class GroupTourViewController: BaseViewController {
    
    @IBOutlet weak var grayBlurView: UIView!
    @IBOutlet weak var groupSearchView: UIView!
    
    private var presenter: GropeTourPresenter?
    
    private var menuList : GroupMenuResponse? {
        didSet{
            setNavIcon()
        }
    }
    
    let transiton = GroupSlideInTransition()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        presenter = GropeTourPresenter(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchGes()
        setIsNavShadowEnable(false)
        self.grayBlurView.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getApiToken()
    }
    
    override func loadData() {
        super.loadData()
        getApiToken()
    }
    
    private func getApiToken(){
        self.presenter?.getApiToken()
    }
    
    private func getVersionRule(){
        self.presenter?.getVersionRule()
        
    }
    
    private func getGroupMenu(){
        self.presenter?.getGroupMenu(toolBarType: .tour)
    }
    
    override func onLoginSuccess(){
        self.getVersionRule()
    }
    
    private func setNavIcon(){
        self.setNavTitle(title: "團體旅遊")
        
        if self.menuList?.contactList.isEmpty == false {
            let contaceButtonView = UIButton(type: .system)
            
            let rightImage = #imageLiteral(resourceName: "home_contavt")
            contaceButtonView.setImage(rightImage, for: .normal)
            contaceButtonView.addTarget(self, action: #selector(self.onTouchContact), for: .touchUpInside)

            var contaceBarButtonItem = UIBarButtonItem(customView: contaceButtonView)
            contaceBarButtonItem = UIBarButtonItem(image: rightImage, style: .plain, target: self, action: #selector(self.onTouchContact))
            self.navigationItem.rightBarButtonItem = contaceBarButtonItem
        }
        
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
        vc.setVC(serverList: self.menuList?.serverList ?? [])
        present(vc, animated: true)
    }
    
    @objc func onTouchContact (){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        self.menuList?.contactList.forEach({ (server) in
            alert.addAction(UIAlertAction(title: server.linkName , style: .default, handler: { (_) in
                self.handleLinkType(linkType: server.linkType, linkValue: server.linkValue, linkText: nil)
            }))
        })

        alert.addAction(UIAlertAction(title: "取消", style: .destructive))

        self.present(alert, animated: true)
    }
    
    private func setSearchGes(){
        let ges = UITapGestureRecognizer(target: self, action: #selector(onTouchSearch))
        self.groupSearchView.addGestureRecognizer(ges)
        self.groupSearchView.isUserInteractionEnabled = true
    }
    
    @objc private func onTouchSearch(){
        ()
    }
}
extension GroupTourViewController: GroupSliderViewControllerProtocol {
    func onTouchData(serverData: ServerData) {
        self.handleLinkType(linkType: serverData.linkType, linkValue: serverData.linkValue, linkText: nil)
    }
    
}
extension GroupTourViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        UIView.animate(withDuration: 0.5) {
            self.grayBlurView.alpha = 1
        }
        self.tabBarController?.tabBar.isHidden = true
        
        return transiton
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        self.tabBarController?.tabBar.isHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.grayBlurView.alpha = 0
        })
        self.setTabBarType(tabBarType: .notHidden)
        return transiton
    }
}

extension GroupTourViewController: GropeTourViewProtocol {
    func onBindGroupMenu(menu: GroupMenuResponse) {
        self.menuList = menu
        
    }
    
    func onBindApiTokenComplete() {
        
        getGroupMenu()
        getVersionRule()
    }
    func onBindVersionRule(versionRule: VersionRuleReponse.Update?) {
        ()
    }
}
