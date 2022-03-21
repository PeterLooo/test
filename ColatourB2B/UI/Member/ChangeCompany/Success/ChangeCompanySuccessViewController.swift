//
//  ChangeCompanySuccessViewController.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/12/17.
//  Copyright © 2021 Colatour. All rights reserved.
//

import UIKit

class ChangeCompanySuccessViewController: BaseViewControllerMVVM {

    var onTouchDoneClosure: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavBarItem(left: .custom, mid: .textTitle, right: .nothing)
        self.setNavTitle(title: "改任職旅行社")
        setRightNavItem()
    }
    
    @IBAction func onTouchDone(_ sender: Any) {
        onTouchDoneClosure?()
        self.dismiss(animated: true)
    }
    
    private func setRightNavItem() {
        let cancelBarButtonItem = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(self.onTouchClose))
        cancelBarButtonItem.tintColor = UIColor.init(named: "通用綠")
        
        setCustomLeftBarButtonItem(barButtonItem: cancelBarButtonItem)
    }
    
    @objc private func onTouchClose() {
        onTouchDoneClosure?()
        self.dismiss(animated: true)
    }
}
