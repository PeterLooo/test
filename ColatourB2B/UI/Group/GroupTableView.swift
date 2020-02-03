//
//  GroupTableView.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/20.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
protocol GroupTableViewProtocol: NSObjectProtocol {
    func onTouchItem(item: IndexResponse.ModuleItem)
}
class GroupTableView: UIView {
    
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
        }
    }
    private var indexList: [IndexResponse.Module] = []
    private var homeAd1List: [IndexResponse.Module] = []
    private var homeAd2List: [IndexResponse.Module] = []
    private var needUpdateBannerImage = false
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
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "GroupIndexHeaderImageCell", bundle: nil), forCellReuseIdentifier: "GroupIndexHeaderImageCell")
        tableView.register(UINib(nibName: "HomeAd1Cell", bundle: nil), forCellReuseIdentifier: "HomeAd1Cell")
        tableView.register(UINib(nibName: "HomeAd2Cell", bundle: nil), forCellReuseIdentifier: "HomeAd2Cell")
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
    }
    
    func setViewWith(itemList: [IndexResponse.MultiModule],needUpdateBannerImage:Bool){
        self.itemList = itemList
        self.needUpdateBannerImage = needUpdateBannerImage
        tableView.reloadData()
    }
}

extension GroupTableView : GroupIndexHeaderImageCellProtocol {
    func onTouchItem(item: IndexResponse.ModuleItem) {
        self.delegate?.onTouchItem(item: item)
    }

}
extension GroupTableView : HomeAd1CellProtocol {
    func onTouchItem(adItem: IndexResponse.ModuleItem) {
        self.delegate?.onTouchItem(item: adItem)
    }
}
extension GroupTableView : UITableViewDelegate {
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

extension GroupTableView : UITableViewDataSource {
    
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
            (cell as! HomeAd2Cell).setCell(item: self.homeAd2List[indexPath.row])
            (cell as! HomeAd2Cell).delegate = self
            
        }
        return cell
        
    }
}
