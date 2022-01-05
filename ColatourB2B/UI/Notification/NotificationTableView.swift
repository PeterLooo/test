//
//  NotificationTableView.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/2.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

class NotificationTableView: UIView {
    
    private var cellsHeight: [IndexPath : CGFloat] = [:]
    
    let apiFailErrorView = ApiFailErrorView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    let noInternetErrorView = NoInternetErrorView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    private let bottomLoadingView = BottomLoadingView()
    
    var viewModel: NoticeTableViewModel?
    
    enum Section: Int, CaseIterable{
        case notiItem = 0
        case empty
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUp()
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NotificationItemCell", bundle: nil), forCellReuseIdentifier: "NotificationItemCell")
        tableView.register(UINib(nibName: "EmptyDataCell", bundle: nil), forCellReuseIdentifier: "EmptyDataCell")
        tableView.backgroundColor = UIColor.init(named: "背景灰")
        return tableView
    }()
    
    fileprivate func setUp(){
        
        self.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            tableView.widthAnchor.constraint(equalToConstant: screenWidth),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
        ])
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.lightGray
        refreshControl.addTarget(self, action: #selector(self.pullToRefresh) ,for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        
        setUpErrorViews()
    }
    
    func setViewModel(viewModel: NoticeTableViewModel){
        self.viewModel = viewModel
        cellsHeight = [:]
        self.tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
        closeErrorView()
    }
    
    @objc private func pullToRefresh(){
        self.viewModel?.pullRefresh?(viewModel!.notiType)
    }
    
    private func startBottomLoadingView(){
        self.tableView.tableFooterView = bottomLoadingView
        
        let bottomLoadingViewHeight: CGFloat = 27
        let totalHeight = self.tableView.contentSize.height + bottomLoadingViewHeight
        var totalSize = self.tableView.contentSize
        totalSize.height = totalHeight + 25
        self.tableView.contentSize = totalSize
    }
    
    private func setUpErrorViews() {
        apiFailErrorView.setUpApiFailErrorView()
        self.addSubview(apiFailErrorView)

        noInternetErrorView.setUpNoInternetErrorView()
        self.addSubview(noInternetErrorView)
        
        bringSubviewToFront(apiFailErrorView)
        bringSubviewToFront(noInternetErrorView)

    }
    
    func handleApiError(apiError: APIError) {
        bringSubviewToFront(apiFailErrorView)
        bringSubviewToFront(noInternetErrorView)
        
        if apiError.type == .noInternetException {
            self.apiFailErrorView.isHidden = true
            self.noInternetErrorView.isHidden = false
        } else if apiError.type == .cancelAllRequestDoNothing {
            ()
        } else {
            self.apiFailErrorView.isHidden = false
            self.noInternetErrorView.isHidden = true
        }
    }
    
    private func closeErrorView(){
        self.apiFailErrorView.isHidden = true
        self.noInternetErrorView.isHidden = true
    }
    
    private func stopBottonLoadingView(){
        
        self.tableView.tableFooterView = nil
    }
    @objc func endRefreshContolRefreshing(){
        self.tableView.refreshControl?.endRefreshing()
    }
}

extension NotificationTableView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellsHeight[indexPath] = cell.frame.size.height
        if viewModel!.itemList.isEmpty == true  { return }
        
        let secondLastOrLast = max(viewModel!.itemList.count - 2 , 0 )
        let isSecondLastOrLast = (secondLastOrLast == indexPath.row)
        if isSecondLastOrLast { self.viewModel?.onStartLoading?( viewModel!.notiType) }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if Section(rawValue: indexPath.section) == .empty {
            return self.frame.height
        }
        
        guard let height = cellsHeight[indexPath] else { return UITableView.automaticDimension }
    
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if Section(rawValue: indexPath.section) == .empty {
            return self.frame.height
        }
        
        guard let height = cellsHeight[indexPath] else { return UITableView.automaticDimension }
        
        return height
    }
}

extension NotificationTableView : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .notiItem:
            return viewModel?.itemList.count ?? 0
        case .empty:
            return viewModel?.itemList.count == 0 ? 1 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch Section(rawValue: indexPath.section)! {
        case .notiItem:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationItemCell", for: indexPath) as! NotificationItemCell
            cell.setCell(viewModel: viewModel!.itemList[indexPath.row])
            
            return cell
        case .empty:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyDataCell", for: indexPath) as! EmptyDataCell
            let image = UIImage.init(named: "notification_none")!
            cell.setCellWith(image: image,
                             message: "目前沒有任何\(viewModel?.notiTypeText ?? "")通知！",
                             iconTopConstraint: 90)
            return cell
        }
    }
}
