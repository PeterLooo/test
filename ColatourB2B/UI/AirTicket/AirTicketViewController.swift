//
//  AirTicketViewController.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/20.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit

class AirTicketViewController: BaseViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var airSearchView: UIView!
    
    enum Section : Int, CaseIterable {
        case BANNER = 0
        case HOMEAD1
        case HOMEAD2
    }
    private var cellsHeight: [IndexPath : CGFloat] = [:]
    
    weak var delegate : GroupTableViewProtocol?
    private var itemList: [IndexResponse.MultiModule] = [] {
        didSet {
            indexList = itemList.filter{$0.groupName == "首頁1"}.flatMap{$0.moduleList}
            homeAd1List = itemList.filter{$0.groupName == "HomeAd1"}.flatMap{$0.moduleList}
            homeAd2List = itemList.filter{$0.groupName == "HomeAd2"}.flatMap{$0.moduleList}
            tableView.reloadData()
        }
    }
    private var indexList: [IndexResponse.Module] = []
    private var homeAd1List: [IndexResponse.Module] = []
    private var homeAd2List: [IndexResponse.Module] = []
    private var needUpdateBannerImage = false
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
        tableView.register(UINib(nibName: "GroupIndexHeaderImageCell", bundle: nil), forCellReuseIdentifier: "GroupIndexHeaderImageCell")
        tableView.register(UINib(nibName: "HomeAd1Cell", bundle: nil), forCellReuseIdentifier: "HomeAd1Cell")
        tableView.register(UINib(nibName: "HomeAd2Cell", bundle: nil), forCellReuseIdentifier: "HomeAd2Cell")
        setSearchBorder()
        setSearchGes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        needUpdateBannerImage = true
        loadData()
    }
    
    override func loadData() {
        super.loadData()
        getAirMenu()
        gatTktIndex()
    }
    
    private func getAirMenu(){
        self.presenter?.getAirMenu(toolBarType: .tkt)
    }
    
    private func gatTktIndex(){
        self.presenter?.getAirTicketIndex()
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
    
    private func setSearchGes(){
        let ges = UITapGestureRecognizer(target: self, action: #selector(onTouchSearch))
        self.airSearchView.addGestureRecognizer(ges)
        self.airSearchView.isUserInteractionEnabled = true
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

        let list = menuList?.serverList
            .flatMap { $0 }
            .filter { $0.linkName == "查詢票價表" }
            .first
        
        if let searchAirTicket = list {
            
            self.handleLinkType(linkType: searchAirTicket.linkType, linkValue: searchAirTicket.linkValue, linkText: searchAirTicket.linkName)
        }
    }
}

extension AirTicketViewController: GroupSliderViewControllerProtocol {
    func onTouchData(serverData: ServerData) {
        self.handleLinkType(linkType: serverData.linkType, linkValue: serverData.linkValue, linkText: serverData.linkName ?? "")
    }
}
extension AirTicketViewController: GroupIndexHeaderImageCellProtocol {
    func onTouchItem(item: IndexResponse.ModuleItem) {
        self.handleLinkType(linkType: item.linkType, linkValue: item.linkParams, linkText: nil)
    }
}
extension AirTicketViewController : HomeAd1CellProtocol {
    func onTouchItem(adItem: IndexResponse.ModuleItem) {
        self.handleLinkType(linkType: adItem.linkType, linkValue: adItem.linkParams, linkText: nil)
    }
}
extension AirTicketViewController: AirTicketViewProtocol {
    func onBindAirTicketIndex(moduleDataList: [IndexResponse.MultiModule]) {
        self.itemList = moduleDataList
    }
    
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
extension AirTicketViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellsHeight[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = cellsHeight[indexPath] else { return UITableView.automaticDimension }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = cellsHeight[indexPath] else { return UITableView.automaticDimension }
        
        return height
    }
}

extension AirTicketViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = Section(rawValue: section)!
        switch section {
        case .BANNER:
            return self.indexList.isEmpty ? 0 : 1
            
        case .HOMEAD1:
            return self.homeAd1List.count
       
        case .HOMEAD2:
            return self.homeAd2List.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        let section = Section(rawValue: indexPath.section)!
        
        switch section {
        
        case .BANNER:
            cell = tableView.dequeueReusableCell(withIdentifier: "GroupIndexHeaderImageCell") as! GroupIndexHeaderImageCell
            (cell as! GroupIndexHeaderImageCell).setCell(itemList: indexList[indexPath.row].moduleItemList, needUpdateBannerImage: needUpdateBannerImage)
            (cell as! GroupIndexHeaderImageCell).delegate = self
            needUpdateBannerImage = false
        
        case .HOMEAD1:
            cell = tableView.dequeueReusableCell(withIdentifier: "HomeAd1Cell") as! HomeAd1Cell
            (cell as! HomeAd1Cell).setCell(item: self.homeAd1List[indexPath.row])
            (cell as! HomeAd1Cell).delegate = self
        
        case .HOMEAD2:
            cell = tableView.dequeueReusableCell(withIdentifier: "HomeAd2Cell") as! HomeAd2Cell
            (cell as! HomeAd2Cell).setCell(item: self.homeAd2List[indexPath.row], isLastSection: tableView.numberOfSections - 1 == section.rawValue)
            (cell as! HomeAd2Cell).delegate = self
        }
        return cell
    }
}
