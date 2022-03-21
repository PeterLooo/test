//
//  RegisterSuccessViewController.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/12/17.
//  Copyright © 2021 Colatour. All rights reserved.
//
import UIKit

class RegisterSuccessViewController: BaseViewControllerMVVM {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "註冊"
        let closeImage = #imageLiteral(resourceName: "close.png").withRenderingMode(.alwaysTemplate)
        closeImage.sd_tintedImage(with: colorGreen)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: closeImage, style: .plain, target: self, action: #selector(onTouchCloseNav))
    }
    
    @IBAction func onTouchSuccess(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func onTouchCloseNav() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
