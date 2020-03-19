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
        case HOMEAD3
    }
    private var cellsHeight: [IndexPath : CGFloat] = [:]
    
    weak var delegate : GroupTableViewProtocol?
    private var itemList: [IndexResponse.MultiModule] = [] {
        didSet {
            indexList = itemList.filter{$0.groupName == "首頁1"}.flatMap{$0.moduleList}
            airPopCityList = itemList.filter{$0.groupName == "HomeAd1"}.flatMap{$0.moduleList}
            homeAd2List = itemList.filter{$0.groupName == "HomeAd2"}.flatMap{$0.moduleList}
            homeAd3List = itemList.filter{$0.groupName == "HomeAd3"}.flatMap{$0.moduleList}
            tableView.reloadData()
        }
    }
    private var indexList: [IndexResponse.Module] = []
    private var airPopCityList: [IndexResponse.Module] = []
    
    private var homeAd2List: [IndexResponse.Module] = []
    private var homeAd3List: [IndexResponse.Module] = []
    private var needUpdateBannerImage = false
    private var presenter: AirTicketPresenter?
    private var needRefreshNavRight: Bool = true
    
    let transiton = GroupSlideInTransition()
    private var menuList : GroupMenuResponse?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        presenter = AirTicketPresenter(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getEmployeeMark), name: Notification.Name("getEmployeeMark"), object: nil)
        
        setIsNavShadowEnable(false)
        setNavBarItem(left: .custom, mid: .custom, right: .custom)
        setNavIcon()
        tableView.register(UINib(nibName: "AirIndexCell", bundle: nil), forCellReuseIdentifier: "AirIndexCell")
        tableView.register(UINib(nibName: "AirPopCityCell", bundle: nil), forCellReuseIdentifier: "AirPopCityCell")
        tableView.register(UINib(nibName: "HomeAd1Cell", bundle: nil), forCellReuseIdentifier: "HomeAd1Cell")
        tableView.register(UINib(nibName: "HomeAd2Cell", bundle: nil), forCellReuseIdentifier: "HomeAd2Cell")
        setSearchBorder()
        setSearchGes()
        addRefreshControlToTableView()
        
        loadData()
    }

    override func loadData() {
        super.loadData()
        
        needUpdateBannerImage = true
        getAirMenu()
        gatTktIndex()
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
    
    private func addRefreshControlToTableView(){
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.gray
        refreshControl.addTarget(self, action: #selector(self.pullToRefresh) ,for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    @objc private func pullToRefresh() {
        loadData()
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
        let vc = getVC(st: "TKTSearch", vc: "AirTicketSearchViewController") as! AirTicketSearchViewController
        vc.setVC(searchType: .airTkt)
        self.navigationController?.pushViewController(vc, animated: true)
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
        self.tableView.refreshControl?.endRefreshing()
    }
    
    func onBindAirTicketIndexError(){
        self.itemList = []
        self.tableView.refreshControl?.endRefreshing()
    }
    
    func onBindAirMenu(menu: GroupMenuResponse) {
        self.menuList = menu
    }
    
    func onGetAirMenuError() {
        self.menuList = nil
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
            return self.airPopCityList.count
       
        case .HOMEAD2:
            return self.homeAd2List.count
        case .HOMEAD3:
            return self.homeAd3List.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        let section = Section(rawValue: indexPath.section)!
        
        switch section {
        
        case .BANNER:
            cell = tableView.dequeueReusableCell(withIdentifier: "AirIndexCell") as! AirIndexCell
            
            (cell as! AirIndexCell).setCell(item: indexList[indexPath.row])
            (cell as! AirIndexCell).delegate = self
        
        case .HOMEAD1:
            cell = tableView.dequeueReusableCell(withIdentifier: "AirPopCityCell") as! AirPopCityCell
            (cell as! AirPopCityCell).setCell(item: self.airPopCityList[indexPath.row], numOfIndex: 0)
            (cell as! AirPopCityCell).delegate = self
        
        case .HOMEAD2:
            cell = tableView.dequeueReusableCell(withIdentifier: "HomeAd1Cell") as! HomeAd1Cell
            (cell as! HomeAd1Cell).setCell(item: self.homeAd2List[indexPath.row])
            (cell as! HomeAd1Cell).delegate = self

        case .HOMEAD3:
            cell = tableView.dequeueReusableCell(withIdentifier: "HomeAd2Cell") as! HomeAd2Cell
            (cell as! HomeAd2Cell).setCell(item: self.homeAd3List[indexPath.row], isLastSection: tableView.numberOfSections - 1 == section.rawValue, needLogoImage: true)
            (cell as! HomeAd2Cell).delegate = self
        }
        return cell
    }
}
