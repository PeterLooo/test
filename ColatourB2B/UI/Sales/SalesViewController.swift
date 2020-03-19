//
//  SalesViewController.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/10.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

class SalesViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        presenter = SalesPresenter(delegate: self)
    }
    
    private var presenter: SalesPresenterProtocol?
    private var salesList: [SalesResponse.Sales] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavTitle(title: "會員專屬服務團隊")
        self.setTabBarType(tabBarType: .hidden)
        tableView.register(UINib.init(nibName: "SalseInfoCell", bundle: nil), forCellReuseIdentifier: "SalseInfoCell")
        loadData()
    }
    
    override func loadData() {
        super.loadData()
        presenter?.getSalesList()
    }
}
extension SalesViewController: SalesViewProtocol {
    func onBindSalesList(salesList: [SalesResponse.Sales]) {
        self.salesList = salesList
    }
}
extension SalesViewController: SalseInfoCellProtocol {
    
    func onTouchPhoneNum(url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func onTouchComment(sales: SalesResponse.Sales) {
        
        self.onPopContactVC(messageSendType: sales.salesType!, navTitle: "留言")
    }
    
    func onTouchLine(sales: SalesResponse.Sales) {
        guard let lineId = sales.lineID else {
            return
        }
        let lineURL = URL(string: "line://ti/p/~\(lineId)") // Line 群組或朋友 ID

        if UIApplication.shared.canOpenURL(lineURL!) {
            UIApplication.shared.open(lineURL!, options: [:], completionHandler: nil)
        } else {
            //Note: 目前沒安裝的，不需反應
        }
    }
    
    private func onPopContactVC(messageSendType: String, navTitle: String){
        
        let messageSendViewController = getVC(st: "MessageSend", vc: "MessageSend") as! MessageSendViewController
        messageSendViewController.setVC(messageSendType: messageSendType, navTitle: navTitle)
        messageSendViewController.delegate = self
        
        let nav = UINavigationController(rootViewController: messageSendViewController)
        nav.modalPresentationStyle = .fullScreen
        self.navigationController?.present(nav, animated: true)
    }
}

extension SalesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return salesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SalseInfoCell", for: indexPath) as! SalseInfoCell
        cell.setCell(sales: self.salesList[indexPath.row], isFirst: indexPath.row == 0, isLast: indexPath.row == salesList.count - 1)
        cell.delegate = self
        return cell
    }
}

extension SalesViewController: MessageSendToastDelegate {

    func setMessageSendToastText(text: String) {
        
        self.addToastViewBottomHeight(height: 50)
        self.toast(text: text)
    }
}
