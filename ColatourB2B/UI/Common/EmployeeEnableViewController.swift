//
//  NotOpenAssignmentViewController.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/12/24.
//  Copyright © 2021 Colatour. All rights reserved.
//
import UIKit

extension EmployeeEnableViewController {
    func setVC(title: String) {
        self.navTitle = title
    }
}

class EmployeeEnableViewController: BaseViewController {
    
    private var navTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavBarItem(left: .close, mid: .textTitle, right: .nothing)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavTitle(title: navTitle ?? "")
    }
    
    @IBAction func onTouchEnd(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
