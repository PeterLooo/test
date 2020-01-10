//
//  NotificationTableView.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/2.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
protocol NotificationTableViewProtocol: NSObjectProtocol {
    func onTouchNoti(item: NoticeResponse.Item)
}
class NotificationTableView: UIView {
    
    private var cellsHeight: [IndexPath : CGFloat] = [:]
    
    weak var delegate : NotificationTableViewProtocol?
    private var itemList: [NoticeResponse.Item] = []
    
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
    
    func setViewWith(itemList: [NoticeResponse.Item]){
        self.itemList = itemList
        
        tableView.reloadData()
    }
}

extension NotificationTableView : NotificationItemCellProtocol {
    func onTouchItem(item: NoticeResponse.Item) {
        self.delegate?.onTouchNoti(item: item)
    }
    
}

extension NotificationTableView : UITableViewDelegate {
    
}

extension NotificationTableView : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationItemCell", for: indexPath) as! NotificationItemCell
        cell.setCell(item: itemList[indexPath.row])
        cell.delegate = self
        return cell
    }
}
