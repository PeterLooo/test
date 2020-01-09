//
//  MoreViewController.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/20.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit

class MoreViewController: BaseViewController {
    private var presenter: MorePresenterProtocol?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.allowsSelectionDuringEditing = false
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MemberIndexServiceCell", bundle: nil), forCellReuseIdentifier: "MemberIndexServiceCell")
        return tableView
    }()
    
    private var toolBarList: [ServerData] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavTitle(title: "更多")
        
        presenter = MorePresenter(delegate: self)
        setUpLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    override func loadData() {
        super.loadData()
        
        presenter?.getOtherToolBarList()
    }
    
    private func setUpLayout(){
        self.view.addSubview(tableView)
        
        tableView.constraintToSafeArea()
    }
}

extension MoreViewController: MoreViewProtocol {
    func onBindOtherToolBarList(toolBarList: [ServerData]) {
        self.toolBarList = toolBarList
        tableView.reloadData()
    }
}

extension MoreViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toolBarList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberIndexServiceCell") as! MemberIndexServiceCell
        cell.setCellWith(serverData: toolBarList[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension MoreViewController: MemberIndexServiceCellProtocol {
    func onTouchServer(server: ServerData) {
        self.handleLinkType(linkType: server.linkType, linkValue: server.linkValue, linkText: server.linkName ?? "")
    }
}
