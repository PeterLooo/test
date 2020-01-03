//
//  NotificationTableView.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/2.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
protocol NotificationTableViewProtocol: NSObjectProtocol {
    func onTouchNoti(tag: Int)
}
class NotificationTableView: UIView {
    
    private var cellsHeight: [IndexPath : CGFloat] = [:]
    
    weak var delegate : NotificationTableViewProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUp()
    }
    
    private lazy var tableViewTrace: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NotificationItemCell", bundle: nil), forCellReuseIdentifier: "NotificationItemCell")
        
        return tableView
    }()
    
    fileprivate func setUp(){
        
        self.addSubview(tableViewTrace)
        
        NSLayoutConstraint.activate([
            tableViewTrace.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            tableViewTrace.widthAnchor.constraint(equalToConstant: screenWidth),
            tableViewTrace.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            tableViewTrace.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            tableViewTrace.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
        ])
    }
    
    func setViewWith(productTraceList: [Any], tag:Int){
        self.tag = tag
        
        tableViewTrace.reloadData()
    }
}

extension NotificationTableView : NotificationItemCellProtocol {
    func onTouchItem() {
        self.delegate?.onTouchNoti(tag: self.tag)
    }
}

extension NotificationTableView : UITableViewDelegate {
    
}

extension NotificationTableView : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationItemCell", for: indexPath) as! NotificationItemCell
        cell.delegate = self
        return cell
    }
}
