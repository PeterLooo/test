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
        
        setIsNavShadowEnable(false)
        self.setNavBarItem(left: .defaultType, mid: .custom, right: .custom)
        
        grayBlurView.alpha = 0
        setSearchView()
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
        self.loadData()
    }
    
    private func setSearchView(){
        let view = GroupNavigationView()
            view.translatesAutoresizingMaskIntoConstraints = false
        
        view.delegate = self
        self.setCustomMidBarButtonItem(view: view)
    }
    
    private func setNavIcon(){
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
        
        alert.addAction(UIAlertAction(title: "改善建議" , style: .default, handler: { (_) in
            self.onPopContactVC()
        }))
        alert.addAction(UIAlertAction(title: "聯絡業務" , style: .default, handler: { (_) in
            self.contactSales()
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))

        self.present(alert, animated: true)
    }
    
    private func onPopContactVC(){
        ()
    }
    
    private func contactSales(){
        let vc = getVC(st: "Sales", vc: "SalesViewController") as! SalesViewController
        self.navigationController?.pushViewController(vc, animated: true)
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
        ()
    }
}
extension GroupTourViewController: GropeTourViewProtocol {
    func onBindGroupMenu(menu: GroupMenuResponse) {
        
        self.menuList = menu
        
    }
    
    func onBindApiTokenComplete() {
        
        getGroupMenu()
        //getVersionRule()
    }
    func onBindVersionRule(versionRule: VersionRuleReponse.Update?) {
        ()
    }
}
