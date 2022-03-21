//
//  ChangeMemberInfoCell.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/12/8.
//  Copyright © 2021 Colatour. All rights reserved.
//

import UIKit

class ChangeMemberInfoCell: UITableViewCell {

    @IBOutlet weak var company: CustomTextField!
    @IBOutlet weak var memberId: CustomTextField!
    @IBOutlet weak var memberName: CustomTextField!
    @IBOutlet weak var birthday: CustomTextField!
    @IBOutlet weak var email: CustomTextField!
    @IBOutlet weak var mobilePhone: CustomTextField!
    @IBOutlet weak var phoneZone: UITextField!
    @IBOutlet weak var phoneNo: UITextField!
    @IBOutlet weak var phoneExtension: UITextField!
    @IBOutlet weak var checkImg: UIImageView!
    @IBOutlet weak var groupImg: UIImageView!
    @IBOutlet weak var ticketImg: UIImageView!
    @IBOutlet weak var phoneError: UILabel!
    
    private var viewModel: ChangeMemberInfo?
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
            datePicker.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
        datePicker.setToBasic()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        datePicker.addTarget(self, action: #selector(dataPickerValueChange(picker:)) , for: .valueChanged)
        return datePicker
    }()
    
    private lazy var toolBarOnDatePicker : UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let doneBottom = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(self.onTouchDatePickerDone))
        let lexibeSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([lexibeSpace, doneBottom], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setPlaceholder()
        birthday.inputView = datePicker
        birthday.inputAccessoryView = toolBarOnDatePicker
    }
    
    func setCell(viewModel: ChangeMemberInfo) {
        self.viewModel = viewModel
        self.company.text = viewModel.companyName
        self.memberId.text = viewModel.memberId
        self.memberName.text = viewModel.name
        self.birthday.text = viewModel.birthday
        self.email.text = viewModel.email
        self.phoneZone.text = viewModel.phoneZone
        self.phoneNo.text = viewModel.phoneNo
        self.phoneExtension.text = viewModel.phoneExtension
        self.mobilePhone.text = viewModel.mobile
        self.checkImg.image = viewModel.checkImage
        self.selectedTag(tag: viewModel.mainJob == "團體" ? 0:1)
        
        company.addTarget(self, action: #selector(textFieldEdit), for: .editingChanged)
        email.addTarget(self, action: #selector(textFieldEdit), for: .editingChanged)
        mobilePhone.addTarget(self, action: #selector(textFieldEdit), for: .editingChanged)
        phoneZone.addTarget(self, action: #selector(textFieldEdit), for: .editingChanged)
        phoneNo.addTarget(self, action: #selector(textFieldEdit), for: .editingChanged)
        phoneExtension.addTarget(self, action: #selector(textFieldEdit), for: .editingChanged)
        
        self.datePicker.date = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: viewModel.birthday ?? "") ?? Date()
        viewModel.changeImage = { [weak self] in
            self?.checkImg.image = viewModel.checkImage
        }
    }
    
    func setErrorInfo(errorList: [ErrorInfo]) {
        errorList.forEach({
            switch $0.columnName {
            case "Member_Email" :
                email.someController?.setErrorText($0.errorMessage, errorAccessibilityValue: "")
                email.becomeFirstResponder()
            case "Member_Birthday" :
                birthday.someController?.setErrorText($0.errorMessage, errorAccessibilityValue: "")
                birthday.becomeFirstResponder()
            case "Mobile_Phone" :
                mobilePhone.someController?.setErrorText($0.errorMessage, errorAccessibilityValue: "")
                mobilePhone.becomeFirstResponder()
            case "Company_Phone_No","Company_Phone_Zone", "Company_Phone_Ext" :
                phoneError.isHidden = false
                if phoneError.text.isNilOrEmpty == false { phoneError.text?.append("\n")}
                phoneError.text! += $0.errorMessage!
            default:
                ()
            }
        })
    }
    
    @IBAction func jobRadios(_ sender: UIButton) {
        selectedTag(tag: sender.tag)
    }
    
    @IBAction func onTouchNews(_ sender: Any) {
        self.viewModel?.unSubscribeNewsletter.toggle()
    }
    
    private func setPlaceholder() {
        self.company.someController?.placeholderText = "任職旅行社"
        self.memberId.someController?.placeholderText = "會員帳號"
        self.memberName.someController?.placeholderText = "＊會員姓名"
        self.birthday.someController?.placeholderText = "＊出生日期"
        self.email.someController?.placeholderText = "＊電子信箱"
        self.mobilePhone.someController?.placeholderText = "＊行動電話"
        self.birthday.clearButton.isHidden = true
        
        memberId.textColor = UIColor.init(named: "預設文字")
        memberName.textColor = UIColor.init(named: "預設文字")
        company.textColor = UIColor.init(named: "預設文字")
    }
    
    @objc private func onTouchDatePickerDone() {
        dataPickerValueChange(picker: datePicker)
        self.endEditing(true)
    }
    
    @objc private func dataPickerValueChange(picker: UIDatePicker) {
        birthday.text = FormatUtil.convertDateToString(dateFormatTo: "yyyy/MM/dd", date: picker.date)
        viewModel?.birthday = birthday.text
    }
    
    private func selectedTag(tag: Int) {
        switch tag {
        case 0 :
            groupImg.image = #imageLiteral(resourceName: "radio_on")
            ticketImg.image = #imageLiteral(resourceName: "radio_off")
            viewModel?.mainJob = "團體"
        case 1 :
            groupImg.image = #imageLiteral(resourceName: "radio_off")
            ticketImg.image = #imageLiteral(resourceName: "radio_on")
            viewModel?.mainJob = "票務"
        default :
            ()
        }
    }
    
    @objc private func textFieldEdit(sender: UITextField) {
        if sender is CustomTextField {
            (sender as! CustomTextField).someController?.setErrorText(nil, errorAccessibilityValue: nil)
        }else{
            phoneError.text = ""
            phoneError.isHidden = true
        }
        switch sender {
        case company:
            viewModel?.companyName = sender.text
        case email:
            viewModel?.email = sender.text
        case mobilePhone:
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
}
