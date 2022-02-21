//
//  RegisterViewController.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/11/25.
//  Copyright © 2021 Colatour. All rights reserved.
//

import UIKit

class RegisterNoticeViewController: BaseViewController {
    
    @IBOutlet weak var checkButton: BooleanButton!
    @IBOutlet weak var agreeCheckView: UIView!
    @IBOutlet weak var agreeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "申請會員帳號"
    }
    
    @IBAction func onTouchCheck(_ sender: Any) {
        setAgreeButton()
    }
    
    @IBAction func onTouchAgree(_ sender: Any) {
        
        if checkButton.isSelect == true {
            let vc = self.getVC(st: "Register", vc: "RegisterEditorViewController") as! RegisterEditorViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension RegisterNoticeViewController {
    
    private func setView() {
        self.agreeButton.isEnabled = false
        let checkBox = UITapGestureRecognizer.init(target: self, action: #selector(onTouchCheckBox))
        self.agreeCheckView.addGestureRecognizer(checkBox)
    }
    
    private func setAgreeButton() {
        if checkButton.isSelect == true {
            checkButton.tintColor = ColorHexUtil.hexColor(hex: "#19BF62")
            agreeButton.isEnabled = true
            agreeButton.backgroundColor = ColorHexUtil.hexColor(hex: "#19BF62")
        } else {
            checkButton.tintColor = colorLayerGray
            agreeButton.isEnabled = false
            agreeButton.backgroundColor =  ColorHexUtil.hexColor(hex: "#D6D6D6")
        }
    }
    
    @objc func onTouchCheckBox() {
        self.checkButton.isSelect = !self.checkButton.isSelect
        setAgreeButton()
    }
}

