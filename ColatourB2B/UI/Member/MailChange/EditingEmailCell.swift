//
//  EditingEmailCell.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/6/25.
//  Copyright © 2021 Colatour. All rights reserved.
//

import UIKit

class EditingEmailCell: UITableViewCell {
    
    @IBOutlet weak var titleInfo: UILabel!
    @IBOutlet weak var originalEmail: CustomTextField!
    @IBOutlet weak var newEmail: CustomTextField!
    
    private var viewModel: EditingEmailCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        originalEmail.someController?.placeholderText = "原註冊電子郵件信箱"
        newEmail.someController?.placeholderText = "新的電子郵件信箱"
        
        titleInfo.text = "輸入新的電子信箱後，請按﹝測試收信功能﹞\n我們將立即寄出一封測試收信功能的信件到您的指定的電子郵件信箱。"
        newEmail.addTarget(self, action: #selector(editNewEmail), for: .editingChanged)
    }

    func setCell(viewModel: EditingEmailCellViewModel){
        self.viewModel = viewModel
        originalEmail.text = viewModel.originalEmail
        viewModel.emailAreEmpty = { [weak self] errorInfo in
            self?.newEmail.someController?.setErrorText(errorInfo, errorAccessibilityValue: nil)
        }
    }
    
    @objc func editNewEmail(){
        viewModel?.newEmail = newEmail.text
        newEmail.someController?.setErrorText(nil, errorAccessibilityValue: nil)
    }
    
    @IBAction func testEmailAction(_ sender: Any) {
        viewModel?.testEmailAction()
    }
}
