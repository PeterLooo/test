//
//  AirTicketViewController.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/20.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit

class AirTicketViewController: BaseViewControllerMVVM {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var airSearchView: UIView!
    
    enum Section : Int, CaseIterable {
        case BANNER = 0
        case HOMEAD1
        case HOMEAD2
        case HOMEAD3
    }
    
    private var cellsHeight: [IndexPath : CGFloat] = [:]
    
    var viewModel: AirTicketViewModel?
    
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
    private var needRefreshNavRight: Bool = true
    
    let transiton = GroupSlideInTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getEmployeeMark), name: Notification.Name("getEmployeeMark"), object: nil)
        
        bindViewModel()
        setIsNavShadowEnable(false)
        setNavBarItem(left: .custom, mid: .custom, right: .custom)
        setNavIcon()
        setTableView()
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
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.transitioningDelegate = self
        vc.onTouchData = { [weak self] data in
            self?.handleLinkType(linkType: data.linkType, linkValue: data.linkValue, linkText: data.linkName ?? "")
        }
        vc.setVC(menuResponse: viewModel?.menuList)
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
    
    @objc private func onTouchSearch(){
        let vc = getVC(st: "TKTSearch", vc: "AirTicketSearchViewController") as! AirTicketSearchViewController
        vc.setVC(viewModel: AirTicketSearchViewModel(searchType: .airTkt))
        self.navigationController?.pushViewController(vc, animated: true)
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
            return viewModel?.airIndexCellViewModels.count ?? 0
            
        case .HOMEAD1:
            return viewModel?.airPopCityCellViewModels.count ?? 0
            
        case .HOMEAD2:
            return viewModel?.homeAd1CellViewModels.count ?? 0
        case .HOMEAD3:
            return viewModel?.homeAd2ViewModels.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        let section = Section(rawValue: indexPath.section)!
        
        switch section {
        
        case .BANNER:
            cell = tableView.dequeueReusableCell(withIdentifier: "AirIndexCell") as! AirIndexCell
            
            (cell as! AirIndexCell).setCell(viewModel: viewModel!.airIndexCellViewModels[indexPath.row])
//            (cell as! AirIndexCell).delegate = self
            
        case .HOMEAD1:
            cell = tableView.dequeueReusableCell(withIdentifier: "AirPopCityCell") as! AirPopCityCell
            (cell as! AirPopCityCell).setCell(viewModel: viewModel!.airPopCityCellViewModels[indexPath.row])
//            (cell as! AirPopCityCell).delegate = self
            
        case .HOMEAD2:
            cell = tableView.dequeueReusableCell(withIdentifier: "HomeAd1Cell") as! HomeAd1Cell
            (cell as! HomeAd1Cell).setCell(viewModel: viewModel!.homeAd1CellViewModels[indexPath.row])
            
        case .HOMEAD3:
            cell = tableView.dequeueReusableCell(withIdentifier: "HomeAd2Cell") as! HomeAd2Cell
            (cell as! HomeAd2Cell).setCell(viewModel: viewModel!.homeAd2ViewModels[indexPath.row])
        }
        return cell
    }
}

extension AirTicketViewController {
    
    private func bindViewModel() {
        viewModel = AirTicketViewModel()
        self.bindToBaseViewModel(viewModel: self.viewModel!)
        
        viewModel?.onTouchHotelAdItem = { [weak self] item in
            self?.handleLinkType(linkType: item.linkType, linkValue: item.linkParams, linkText: nil)
        }
        viewModel?.reloadData = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel?.endRefreshing = { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
        }
    }
    
    private func setTableView() {
        tableView.register(UINib(nibName: "AirIndexCell", bundle: nil), forCellReuseIdentifier: "AirIndexCell")
        tableView.register(UINib(nibName: "AirPopCityCell", bundle: nil), forCellReuseIdentifier: "AirPopCityCell")
        tableView.register(UINib(nibName: "HomeAd1Cell", bundle: nil), forCellReuseIdentifier: "HomeAd1Cell")
        tableView.register(UINib(nibName: "HomeAd2Cell", bundle: nil), forCellReuseIdentifier: "HomeAd2Cell")
    }
    
    private func getAirMenu() {
        viewModel?.getAirMenu()
    }
    
    private func gatTktIndex() {
        viewModel?.getAirTicketIndex()
    }
    
    private func onPopContactVC(messageSendType: String, navTitle: String){
        
        let messageSendViewController = getVC(st: "MessageSend", vc: "MessageSend") as! MessageSendViewController
        messageSendViewController.setVC(messageSendType: messageSendType, navTitle: navTitle)
        messageSendViewController.delegate = self
        
        let nav = UINavigationController(rootViewController: messageSendViewController)
        nav.modalPresentationStyle = .fullScreen
        self.navigationController?.present(nav, animated: true)
    }
    
    private func setSearchBorder(){
        airSearchView.setBorder(width: 0.5, radius: 14, color: UIColor.init(red: 230, green: 230, blue: 230))
    }
    
    private func setNavIcon() {
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
}
