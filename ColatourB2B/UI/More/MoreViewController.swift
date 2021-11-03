//
//  MoreViewController.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/20.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit

class MoreViewController: BaseViewControllerMVVM {
    
    var viewModel: MoreViewModel?
    
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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavTitle(title: "更多")
        
        bindViewMode()
        setUpLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    override func loadData() {
        super.loadData()
        
        viewModel?.getOtherToolBarList()
    }
}

extension MoreViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.serverCellViewModel.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberIndexServiceCell") as! MemberIndexServiceCell
        cell.setCell(viewModel: viewModel!.serverCellViewModel[indexPath.row])
        
        return cell
    }
}

extension MoreViewController {
    
    private func bindViewMode() {
        viewModel = MoreViewModel()
        bindToBaseViewModel(viewModel: viewModel!)
        viewModel?.reloadTableView = {[weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func setUpLayout(){
        self.view.addSubview(tableView)
        
        tableView.constraintToSafeArea()
    }
}
