//
//  AirTicketSearchViewController.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2020/3/9.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

class AirTicketSearchViewController: BaseViewController {

    @IBOutlet weak var tableViewGroupAir: UITableView!
    private var presenter: AirTicketSearchPresenterProtocol?
    private var response: AirTicketSearchResponse?
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        presenter = AirTicketSearchPresenter(delegate: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setTabBarType(tabBarType: .hidden)
        presenter?.getAirTicketSearchInit()
    }
    
    override func loadData() {
        super.loadData()
        presenter?.getAirTicketSearchInit()
    }

}
extension AirTicketSearchViewController: AirTicketSearchViewProtocol {
    func onBindAirTicketSearchInit(groupTourSearchInit: AirTicketSearchResponse) {
        self.response = groupTourSearchInit
        tableViewGroupAir.reloadData()
    }
}

extension AirTicketSearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupAirCell") as! GroupAirCell
        cell.setCell()
        return cell
    }
}
