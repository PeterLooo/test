//
//  ContactInfoViewController.swift
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
    
    enum Section: Int, CaseIterable {
        case Group = 0
        case Air
        case Ticket
        case Device
    }
    
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
        
        tableView.register(UINib(nibName: "ContactInfoCell", bundle: nil), forCellReuseIdentifier: "ContactInfoCell")
        tableView.register(UINib(nibName: "DeviceCell", bundle: nil), forCellReuseIdentifier: "DeviceCell")
    }
}

extension ContactInfoViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if contactInfo == nil { return 0 }
        
        let section = Section(rawValue: section)
        
        switch section {
        case .Group:
            return (contactInfo?.contactInfoList[section!.rawValue].contactInfoDataList.count)!
            
        case .Air:
            return (contactInfo?.contactInfoList[section!.rawValue].contactInfoDataList.count)!
            
        case .Ticket:
            return (contactInfo?.contactInfoList[section!.rawValue].contactInfoDataList.count)!
            
        case .Device:
            return 1
        
        case .none:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = Section(rawValue: indexPath.section)
        
        let deviceCell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell") as! DeviceCell
        let infoCell = tableView.dequeueReusableCell(withIdentifier: "ContactInfoCell") as! ContactInfoCell
        infoCell.delegate = self
        
        switch section {
        case .Group:
            infoCell.setCell(info: (contactInfo?.contactInfoList[indexPath.section].contactInfoDataList[indexPath.row])!)
            return infoCell
            
        case .Air:
            infoCell.setCell(info: (contactInfo?.contactInfoList[indexPath.section].contactInfoDataList[indexPath.row])!)
            return infoCell
            
        case .Ticket:
            infoCell.setCell(info: (contactInfo?.contactInfoList[indexPath.section].contactInfoDataList[indexPath.row])!)
            return infoCell
            
        case .Device:
            deviceCell.setCell()
            return deviceCell
            
        default:
            return UITableViewCell()
        }
    }
}

extension ContactInfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        view.tintColor = UIColor(named: "背景灰") 

        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor(named: "小標灰")
        header.textLabel?.font = UIFont.init(name: "PingFang-TC-Regular", size: 12.0)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == Section.allCases.count - 1 {
            
            return 16
        } else {
            
            return 26
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let section = Section(rawValue: section)
        
        switch section {
        case .Group:
            return contactInfo?.contactInfoList[section!.rawValue].contactInfoTitle
            
        case .Air:
            return contactInfo?.contactInfoList[section!.rawValue].contactInfoTitle
            
        case .Ticket:
            return contactInfo?.contactInfoList[section!.rawValue].contactInfoTitle
            
        case .Device:
            return nil
            
        default:
            return nil
        }
    }
}

extension ContactInfoViewController: ContactInfoViewProtocol {
    
    func onBindContactInfoList(contactInfoResponse: ContactInfoResponse) {
        
        contactInfo = contactInfoResponse
        tableView.reloadData()
    }
}

extension ContactInfoViewController: ContactInfoCellProtocol {
    
    func onTouchPhoneNum(url: URL) {
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
