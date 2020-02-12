//
//  ContactServiceViewController.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/2/7.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

class ContactInfoViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var presenter: ContactInfoPresenter?
    private var contactInfo: ContactInfoResponse?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        presenter = ContactInfoPresenter(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarItem(left: .defaultType, mid: .textTitle, right: .nothing)
        setNavTitle(title: "請電洽可樂B2B同業網客服中心")
        
        presenter?.getContactInfoList()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "ContactServiceCell", bundle: nil), forCellReuseIdentifier: "ContactServiceCell")
    }
}

extension ContactInfoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (contactInfo?.contactInfoList.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactServiceCell") as! ContactServiceCell
        cell.setCell(contactService: (contactInfo?.contactInfoList[indexPath.row])!)
        cell.delegate = self
        
        return cell
    }
}

extension ContactInfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactServiceCell") as! ContactServiceCell
        cell.setCell(contactService: (contactInfo?.contactInfoList[indexPath.row])!)
        
        if cell.subTitle.text == nil {
            
            return 44
        } else {
            
            return 60
        }
    }
}

extension ContactInfoViewController: ContactInfoViewProtocol {
    
    func onBindContactServiceList(contactServiceResponse: ContactInfoResponse) {
        
        contactInfo = contactServiceResponse
    }
}

extension ContactInfoViewController: ContactServiceCellProtocol {
    
    func onTouchPhoneNum(url: URL) {
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
