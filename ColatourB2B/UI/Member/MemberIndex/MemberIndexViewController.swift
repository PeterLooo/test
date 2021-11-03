//
//  MemberIndexViewController.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/13.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit

class MemberIndexViewController: BaseViewControllerMVVM {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: MemberIndexViewModel?
    private var cellsHeight: [IndexPath: CGFloat] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MemberTopCell", bundle: nil), forCellReuseIdentifier: "MemberTopCell")
        tableView.register(UINib(nibName: "MemberIndexServiceCell", bundle: nil), forCellReuseIdentifier: "MemberIndexServiceCell")
        tableView.register(UINib(nibName: "MemberIndexVersionCell", bundle: nil), forCellReuseIdentifier: "MemberIndexVersionCell")
        
        setNavBarItem(left: .defaultType, mid: .textTitle, right: .nothing)
        setNavType(navBarType: .hidden)
        setTabBarType(tabBarType: .notHidden)
        setBarAlpha(alpha: 0.0, animate: true)
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    override func adjustViewAppearance() {
        super.adjustViewAppearance()
        adjustBarTopConstraint()
    }
    
    override func loadData() {
        super.loadData()
        
        viewModel?.getMemberIndex()
    }
}

extension MemberIndexViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellsHeight[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var maxHeight: CGFloat = 0
        
        if indexPath.section == (viewModel?.sections.endIndex)! - 1{
            for (key, value) in cellsHeight {
                if key.section != (viewModel?.sections.endIndex)! - 1 {
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
        return viewModel?.sections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch viewModel?.sections[section] {
        case .headerCell(_):
            return 1
        case .serverCell(let serverViewModel):
            return serverViewModel.count
        case .versionCell:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch viewModel?.sections[indexPath.section] {
        case .headerCell(let headerViewModel):
            cell = tableView.dequeueReusableCell(withIdentifier: "MemberTopCell") as! MemberTopCell
            (cell as! MemberTopCell).setCellWith(viewModel: headerViewModel)
        case .serverCell(let serverViewModel):
            cell = tableView.dequeueReusableCell(withIdentifier: "MemberIndexServiceCell")
            (cell as! MemberIndexServiceCell).setCell(viewModel: (serverViewModel[indexPath.row]))
        case .versionCell:
            cell = tableView.dequeueReusableCell(withIdentifier: "MemberIndexVersionCell")
        default:
            return UITableViewCell()
        }
        return cell
    }
}

extension MemberIndexViewController {
    private func bindViewModel(){
        viewModel = MemberIndexViewModel()
        self.bindToBaseViewModel(viewModel: viewModel!)
        viewModel?.reloadTableView = {[weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func adjustBarTopConstraint(){
        
        let totalHeight = statusBarHeight
        let tableViewTopConstraint = NSLayoutConstraint(item: self.tableView!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: -totalHeight)
        
        self.view.addConstraint(tableViewTopConstraint)
    }
}
