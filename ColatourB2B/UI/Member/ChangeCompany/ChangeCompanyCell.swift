//
//  ChangeCompanyCell.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/7/2.
//  Copyright © 2021 Colatour. All rights reserved.
//

import UIKit

class ChangeCompanyCell: UITableViewCell {

    @IBOutlet weak var memberId: CustomTextField!
    @IBOutlet weak var memberName: CustomTextField!
    @IBOutlet weak var exCompany: CustomTextField!
    @IBOutlet weak var newCompanyId: CustomTextField!
    @IBOutlet weak var newCompany: CustomTextField!
    @IBOutlet weak var email: CustomTextField!
    @IBOutlet weak var phoneZone: UITextField!
    @IBOutlet weak var phoneNo: UITextField!
    @IBOutlet weak var phoneExtension: UITextField!
    @IBOutlet weak var mobile: CustomTextField!
    @IBOutlet weak var phoneError: UILabel!
    
    private var viewModel: ChangeCompanyModel? {
        didSet{
            memberId.text = viewModel?.memberId
            memberName.text = viewModel?.name
            exCompany.text = viewModel?.exCompanyName
            email.text = email.text.isNilOrEmpty == true ? viewModel?.email : email.text
            mobile.text = mobile.text.isNilOrEmpty == true ? viewModel?.mobile : mobile.text
            
            if viewModel?.errorInfo != nil {
                setErrorInfo()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        memberId.someController?.placeholderText = "會員帳號"
        memberName.someController?.placeholderText = "姓名"
        exCompany.someController?.placeholderText = "原任職旅行社"
        newCompanyId.someController?.placeholderText = "新旅行社統編"
        newCompany.someController?.placeholderText = "新旅行社公司名"
        email.someController?.placeholderText = "電子信箱"
        mobile.someController?.placeholderText = "行動電話"
        
        memberId.textColor = UIColor.init(named: "預設文字")
        memberName.textColor = UIColor.init(named: "預設文字")
        exCompany.textColor = UIColor.init(named: "預設文字")
        
        newCompanyId.addTarget(self, action: #selector(textFieldEdit), for: .editingChanged)
        newCompany.addTarget(self, action: #selector(textFieldEdit), for: .editingChanged)
        email.addTarget(self, action: #selector(textFieldEdit), for: .editingChanged)
        mobile.addTarget(self, action: #selector(textFieldEdit), for: .editingChanged)
        phoneZone.addTarget(self, action: #selector(textFieldEdit), for: .editingChanged)
        phoneNo.addTarget(self, action: #selector(textFieldEdit), for: .editingChanged)
        phoneExtension.addTarget(self, action: #selector(textFieldEdit), for: .editingChanged)
    }

    func setCell(viewModel: ChangeCompanyModel){
        self.viewModel = viewModel
    }
    
    @objc private func textFieldEdit(sender: UITextField) {
        if sender is CustomTextField {
            (sender as! CustomTextField).someController?.setErrorText(nil, errorAccessibilityValue: nil)
        }else{
            phoneError.text = ""
        }
        switch sender {
        case newCompanyId:
            viewModel?.newCompanyId = sender.text
        case newCompany:
            viewModel?.newCompanyName = sender.text
        case email:
            viewModel?.email = sender.text
        case mobile:
            viewModel?.mobile = sender.text
        case phoneZone:
            viewModel?.phoneZone = sender.text
        case phoneNo:
            viewModel?.phoneNo = sender.text
        case phoneExtension:
            viewModel?.phoneExtension = sender.text
        default:
            ()
        }
    }
    
    private func setErrorInfo() {
        newCompanyId.someController?.setErrorText(viewModel?.errorInfo?.newCompanyId, errorAccessibilityValue: nil)
        newCompany.someController?.setErrorText(viewModel?.errorInfo?.newCompanyName, errorAccessibilityValue: nil)
        email.someController?.setErrorText(viewModel?.errorInfo?.email, errorAccessibilityValue: nil)
        mobile.someController?.setErrorText(viewModel?.errorInfo?.mobile, errorAccessibilityValue: nil)
        if viewModel?.errorInfo?.phone.isNilOrEmpty == false {
            phoneError.text = viewModel?.errorInfo?.phone
        }
    }
}
