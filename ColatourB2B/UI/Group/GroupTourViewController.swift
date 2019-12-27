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
    
    private var presenter: GropeTourPresenter?
    private var result : GroupMenuResponse?
    let transiton = GroupSlideInTransition()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        presenter = GropeTourPresenter(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavIcon()
        let api = AppHelper.shared.getJson(forResource: "Group")
        api.map{ GroupMenuResponse(JSON: $0)! }.subscribe(onSuccess: { (model) in
           
            self.result = model
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getApiToken()
    }
    
    override func loadData() {
        super.loadData()
        getVersionRule()
    }
    
    private func getApiToken(){
        self.presenter?.getApiToken()
    }
    
    private func getVersionRule(){
        self.presenter?.getVersionRule()
    }
    
    override func onLoginSuccess(){
        self.getVersionRule()
    }
    
    private func setNavIcon(){
        self.setNavTitle(title: "團體旅遊")
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(named: "通用綠")!]
        
        let contaceButtonView = UIButton(type: .system)
        
        let rightImage = #imageLiteral(resourceName: "home_contavt")
        contaceButtonView.setImage(rightImage, for: .normal)
        contaceButtonView.addTarget(self, action: #selector(self.onTouchContact), for: .touchUpInside)

        var contaceBarButtonItem = UIBarButtonItem(customView: contaceButtonView)
        contaceBarButtonItem = UIBarButtonItem(image: rightImage, style: .plain, target: self, action: #selector(self.onTouchContact))
        
        let menuButtonView = UIButton(type: .system)
        
        let leftImage = #imageLiteral(resourceName: "home_menu")
        menuButtonView.setImage(leftImage, for: .normal)
        menuButtonView.addTarget(self, action: #selector(self.onTouchMenu), for: .touchUpInside)

        var menuBarButtonItem = UIBarButtonItem(customView: menuButtonView)
        menuBarButtonItem = UIBarButtonItem(image: leftImage, style: .plain, target: self, action: #selector(self.onTouchMenu))
        
        self.navigationItem.leftBarButtonItem = menuBarButtonItem
        self.navigationItem.rightBarButtonItem = contaceBarButtonItem
    }
    
    @objc func onTouchMenu (){
        let vc = getVC(st: "GroupTour", vc: "GroupSliderViewController") as! GroupSliderViewController
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        vc.transitioningDelegate = self
        vc.setVC(serverList: self.result?.serverList ?? [])
        present(vc, animated: true)
    }
    
    @objc func onTouchContact (){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        self.result?.contactList.forEach({ (server) in
            alert.addAction(UIAlertAction(title: server.server , style: .default, handler: { (_) in
                self.handleLinkType(linkType: server.linkType, linkValue: server.linkValue, linkText: nil)
            }))
        })

        alert.addAction(UIAlertAction(title: "取消", style: .destructive))

        self.present(alert, animated: true)
    }
}
extension GroupTourViewController: GroupSliderViewControllerProtocol {
    func onTouchData(serverData: GroupMenuResponse.ServerData) {
        self.handleLinkType(linkType: serverData.linkType, linkValue: serverData.linkValue, linkText: nil)
    }
    
}
extension GroupTourViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        grayBlurView.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        
        return transiton
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        self.tabBarController?.tabBar.isHidden = false
        grayBlurView.isHidden = true
        
        self.setTabBarType(tabBarType: .notHidden)
        return transiton
    }
}

extension GroupTourViewController: GropeTourViewProtocol {
    func onBindApiTokenComplete() {
        getVersionRule()

    }
    
    func onBindVersionRule(versionRule: VersionRuleReponse.Update?) {
        print(versionRule)
    }
    
}
