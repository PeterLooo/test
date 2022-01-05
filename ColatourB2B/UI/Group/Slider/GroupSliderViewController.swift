//
//  GroupSliderViewController.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/24.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit

extension GroupSliderViewController {
    func setVC(menuResponse: GroupMenuResponse?) {
        self.menuResponse = menuResponse
    }
}

class GroupSliderViewController: BaseViewController {

    var onTouchData: ((_ serverData: ServerData)->())?
    
    @IBOutlet weak var tableView: UITableView!
    
    private var menuResponse : GroupMenuResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

extension GroupSliderViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if menuResponse == nil { return 0 }
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
        cell.onTouchDate = { [weak self] data in
            self?.dismiss(animated: true, completion: nil)
            self?.onTouchData?(data)
        }
        return cell
    }
}
