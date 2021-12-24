//
//  NotOpenAssignmentViewController.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/12/24.
//  Copyright © 2021 Colatour. All rights reserved.
//

import UIKit

class EmployeeEnableViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavBarItem(left: .close, mid: .textTitle, right: .nothing)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavTitle(title: "改任職旅行社")
    }
    
    @IBAction func onTouchEnd(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
