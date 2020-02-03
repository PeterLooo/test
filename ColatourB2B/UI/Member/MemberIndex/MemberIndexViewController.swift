//
//  MemberIndexViewController.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/13.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit

class MemberIndexViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    enum Section : Int, CaseIterable {
        case TOP_VIEW_LIST = 0
        case SEVICE_LIST
        case VERSION
    }
    
    private var presenter: MemberIndexPresenterProtocol?
    private var memberIndex: MemberIndexResponse?
    private var cellsHeight: [IndexPath: CGFloat] = [:]
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        presenter = MemberIndexPresenter(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MemberTopCell", bundle: nil), forCellReuseIdentifier: "MemberTopCell")
        tableView.register(UINib(nibName: "MemberIndexServiceCell", bundle: nil), forCellReuseIdentifier: "MemberIndexServiceCell")
        tableView.register(UINib(nibName: "MemberIndexVersionCell", bundle: nil), forCellReuseIdentifier: "MemberIndexVersionCell")
        
        setNavBarItem(left: .defaultType, mid: .textTitle, right: .nothing)
        setNavType(navBarType: .hidden)
        setTabBarType(tabBarType: .notHidden)
        setBarAlpha(alpha: 0.0, animate: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
        
    }
    override func adjustViewAppearance() {
        super.adjustViewAppearance()
        adjustBarTopConstraint()
    }
    
    private func adjustBarTopConstraint(){
        
        let totalHeight = statusBarHeight
        let tableViewTopConstraint = NSLayoutConstraint(item: self.tableView!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: -totalHeight)
        
        self.view.addConstraint(tableViewTopConstraint)
    }
    
    override func loadData() {
        super.loadData()
        
        presenter?.getMemberIndex()
    }
    
}

extension MemberIndexViewController: MemberIndexViewProtocol {
    func onBindMemberIndex(result: MemberIndexResponse) {
        self.memberIndex = result
        tableView.reloadData()
    }
}

extension MemberIndexViewController: MemberTopCellProtocol {
    func onTouchLogout() {
        UserDefaultUtil.shared.accessToken = ""
        UserDefaultUtil.shared.refreshToken = ""
        NotificationCenter.default.post(name: Notification.Name("noticeLoadDate"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("getUnreadCount"), object: nil)
        loadData()
    }
}

extension MemberIndexViewController: MemberIndexServiceCellProtocol {
    func onTouchServer(server: ServerData) {
        self.handleLinkType(linkType: server.linkType, linkValue: server.linkValue, linkText: server.linkName ?? "")
    }
}
extension MemberIndexViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellsHeight[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var maxHeight: CGFloat = 0
        if Section(rawValue: indexPath.section)! == .VERSION {
            for (key, value) in cellsHeight {
                if key.section != Section.VERSION.rawValue {
                    maxHeight += value
                }
                
            }
            
            let versionCellHeight = screenHeight - maxHeight - (navigationController?.navigationBar.frame.height ?? 0) - (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
            return max(versionCellHeight,50)
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let height = cellsHeight[indexPath] else { return 100.0 }
        return height
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0.0 {
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) {
                let frameScale = cellsHeight[IndexPath(row: 0, section: 0)] ?? 0
                let yPosition = scrollView.contentOffset.y - self.tableView.frame.origin.y
                let deltaY = frameScale - yPosition
                let h = max(0, deltaY)
                cell.frame = CGRect(x: 0.0, y: yPosition , width: cell.frame.size.width, height: h)
                (cell as! MemberTopCell).updateLayer()
            }
        }
    }
}

extension MemberIndexViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = Section(rawValue: section)!
        switch section {
        case .TOP_VIEW_LIST:
            return 1
        case .SEVICE_LIST:
            if self.memberIndex == nil { return 0 }
            return memberIndex!.memberIndexList.count
        case .VERSION:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        let section = Section(rawValue: indexPath.section)!
        switch section {
        case .TOP_VIEW_LIST:
            cell = tableView.dequeueReusableCell(withIdentifier: "MemberTopCell") as! MemberTopCell
            (cell as! MemberTopCell).setCellWith(title: memberIndex?.memeberName)
            (cell as! MemberTopCell).delegate = self
            
        case .SEVICE_LIST:
            cell = tableView.dequeueReusableCell(withIdentifier: "MemberIndexServiceCell")
            (cell as! MemberIndexServiceCell).setCellWith(serverData: (memberIndex?.memberIndexList[indexPath.row])!)
            (cell as! MemberIndexServiceCell).delegate = self
        case .VERSION:
            cell = tableView.dequeueReusableCell(withIdentifier: "MemberIndexVersionCell")
            
        }
        return cell
    }
}
