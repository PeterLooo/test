//
//  GroupSliderViewController.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/24.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit
protocol GroupSliderViewControllerProtocol: NSObjectProtocol {
    
    func onTouchData(serverData: GroupMenuResponse.ServerData)
}
extension GroupSliderViewController {
    func setVC(serverList:[GroupMenuResponse.ServerItem]) {
        self.serverList = serverList
    }
}
class GroupSliderViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gesView: UIView!
    
    weak var delegate : GroupSliderViewControllerProtocol?
    
    private var serverList : [GroupMenuResponse.ServerItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let ges = UITapGestureRecognizer(target: self, action: #selector(onTouchCardView))
        self.gesView.addGestureRecognizer(ges)
        self.gesView.isUserInteractionEnabled = true
        self.setTabBarType(tabBarType: .hidden)
        tableView.register(UINib(nibName: "GroupSliderItemCell", bundle: nil), forCellReuseIdentifier: "GroupSliderItemCell")
        
        tableView.reloadData()
    }
    
    @objc func onTouchCardView(){
        self.dismiss(animated: true, completion: nil)
    }

}
extension GroupSliderViewController: GroupSliderItemCellProtocol {
    
    func onTouchDate(serverData: GroupMenuResponse.ServerData) {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.onTouchData(serverData: serverData)
    }
}
extension GroupSliderViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.serverList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.serverList[section].itemDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupSliderItemCell") as! GroupSliderItemCell
        let isNeedLine = indexPath.section != 0 && indexPath.row == 0
        cell.setCell(serverData: self.serverList[indexPath.section].itemDataList[indexPath.row], isNeedLine: isNeedLine)
        cell.delegate = self
        return cell
    }
}
