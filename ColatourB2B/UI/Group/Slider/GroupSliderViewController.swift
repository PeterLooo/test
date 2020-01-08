//
//  GroupSliderViewController.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/24.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit
protocol GroupSliderViewControllerProtocol: NSObjectProtocol {
    
    func onTouchData(serverData: ServerData)
}
extension GroupSliderViewController {
    func setVC(menuResponse: GroupMenuResponse) {
        self.menuResponse = menuResponse
    }
}
class GroupSliderViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gesView: UIView!
    
    weak var delegate : GroupSliderViewControllerProtocol?
    
    private var menuResponse : GroupMenuResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let ges = UITapGestureRecognizer(target: self, action: #selector(onTouchCardView))
        self.gesView.addGestureRecognizer(ges)
        self.gesView.isUserInteractionEnabled = true
        self.setTabBarType(tabBarType: .hidden)
        tableView.register(UINib(nibName: "GroupSliderItemCell", bundle: nil), forCellReuseIdentifier: "GroupSliderItemCell")
        
        tableView.reloadData()
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(onTouchCardView))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        self.view.isUserInteractionEnabled = true
    }
   
    @objc func onTouchCardView(){
        self.dismiss(animated: true, completion: nil)
    }

}
extension GroupSliderViewController: GroupSliderItemCellProtocol {
    
    func onTouchDate(serverData: ServerData) {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.onTouchData(serverData: serverData)
    }
}
extension GroupSliderViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return (menuResponse?.serverList.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (menuResponse?.serverList[section].count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupSliderItemCell") as! GroupSliderItemCell
        let isNeedLine = indexPath.section != 0 && indexPath.row == 0
        let isLast = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        
        cell.setCell(serverData: (self.menuResponse?.serverList[indexPath.section][indexPath.row])!,
                     isNeedLine: isNeedLine,
                     isFirst: indexPath.row == 0,
                     isLast: isLast)
        cell.delegate = self
        return cell
    }
}
