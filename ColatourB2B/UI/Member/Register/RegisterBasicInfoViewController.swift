//
//  RegisterBasicInfoViewController.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/11/30.
//  Copyright © 2021 Colatour. All rights reserved.
//
import UIKit

extension RegisterBasicInfoViewController {
    func setVC(viewModel: RegisterBasicInfoViewModel) {
        self.viewModel = viewModel
    }
}

class RegisterBasicInfoViewController: BaseViewControllerMVVM {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var tempView: UIView!
    @IBOutlet weak var introCompanyAndNameView: UIView!
    @IBOutlet weak var passwordExample: UILabel!
    @IBOutlet weak var confirmPasswordExample: UILabel!
    @IBOutlet weak var passwordHintExample: UILabel!
    @IBOutlet weak var emailExample: UILabel!
    @IBOutlet weak var companyPhoneError: UILabel!
    @IBOutlet weak var genderError: UILabel!
    @IBOutlet weak var female: BooleanButton!
    @IBOutlet weak var man: BooleanButton!
    @IBOutlet weak var group: BooleanButton!
    @IBOutlet weak var ticket: BooleanButton!
    @IBOutlet weak var holdAPost: CustomTextField!
    @IBOutlet weak var account: CustomTextField!
    @IBOutlet weak var password: CustomTextField!
    @IBOutlet weak var confirmPassword: CustomTextField!
    @IBOutlet weak var passwordHint: CustomTextField!
    @IBOutlet weak var chineseName: CustomTextField!
    @IBOutlet weak var birthday: CustomTextField!
    @IBOutlet weak var email: CustomTextField!
    @IBOutlet weak var companyArea: CustomTextField!
    @IBOutlet weak var companyPhone: CustomTextField!
    @IBOutlet weak var cellPhone: CustomTextField!
    @IBOutlet weak var source: CustomTextField!
    @IBOutlet weak var introCompanyName: CustomTextField!
    @IBOutlet weak var introName: CustomTextField!
    @IBOutlet weak var emailSource: CustomTextField!
    @IBOutlet weak var companyPhoneExt: CustomTextField!
    
    private var viewModel: RegisterBasicInfoViewModel?
    private var pickerViewTop: NSLayoutConstraint!
    private let datePicker : UIDatePicker = {
        let view = UIDatePicker()
        if #available(iOS 14.0, *) {
            view.preferredDatePickerStyle = .inline
            view.transform = CGAffineTransform(scaleX: 0.9 , y: 0.9)
        }
        view.setToBasic()
        view.datePickerMode = .date
        view.maximumDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        view.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        return view
    }()
    
    private lazy var pickerView : CustomPickerView = {
        let view = CustomPickerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setOptionList(optionList: [])
        view.valueChangeDelegate = self
        return view
    }()
    
    private lazy var toolBarOnPickerView : UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let doneBottom = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(self.onTouchPickerViewDone))
        let lexibeSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([lexibeSpace, doneBottom], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }()
    
    private lazy var toolBarOnDatePicker: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let doneBottom = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(self.onTouchDone))
        let lexibeSpace = UIBarButtonItem(barButtonSystemItem:.flexibleSpace,target: nil,action: nil)
        toolBar.setItems([lexibeSpace,doneBottom], animated: true)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        layoutPickerView()
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "密碼與基本資料"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func onTouchBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onNext(_ sender: Any) {
        viewModel?.onNext(password: password.text ?? "", confirmPassword: confirmPassword.text ?? "", passwordHint: passwordHint.text ?? "", chineseName: chineseName.text ?? "", email: email.text ?? "", companyArea: companyArea.text ?? "", companyPhone: companyPhone.text ?? "",companyPhoneExt: companyPhoneExt.text ?? "", cellPhone: cellPhone.text ?? "",female: female.isSelect ? "女" : "", man: man.isSelect ? "男" : "", group: group.isSelect ? "團體" : "", ticket: ticket.isSelect ? "票務" : "", introCompanyName: introCompanyName.text ?? "" , introName: introName.text ?? "",birthday: birthday.text ?? "")
    }
    
    @IBAction func onTouchSource(_ sender: Any) {
        viewModel?.setInputFieldType(inputFieldType: .source)
    }
    
    @IBAction func onTouchEmail(_ sender: Any) {
        viewModel?.setInputFieldType(inputFieldType: .email)
    }
    
    @IBAction func onTouchWatchPassword(_ sender: Any) {
        self.password.isSecureTextEntry = !self.password.isSecureTextEntry
    }
    
    @IBAction func onTouchWatchConfirmPassword(_ sender: Any) {
        self.confirmPassword.isSecureTextEntry = !self.confirmPassword.isSecureTextEntry
    }
    
    @IBAction func onTouchFemale(_ sender: Any) {
        self.female.isSelect = true
        self.man.isSelect = false
        self.genderError.text = ""
    }
    
    @IBAction func onTouchMan(_ sender: Any) {
        self.man.isSelect = true
        self.female.isSelect = false
        self.genderError.text = ""
    }
    
    @IBAction func onTouchGroup(_ sender: Any) {
        self.group.isSelect = true
        self.ticket.isSelect = false
    }
    @IBAction func onTouchTicket(_ sender: Any) {
        self.ticket.isSelect = true
        self.group.isSelect = false
    }
    
    @objc private func datePickerChanged(picker: UIDatePicker) {
        birthday.text = FormatUtil.convertDateToString(dateFormatTo: "yyyy/MM/dd", date: picker.date)
        self.birthday.someController?.setErrorText(nil, errorAccessibilityValue: nil)
    }
    
    @objc private func onTouchDone() {
        datePickerChanged(picker: datePicker)
        self.view.endEditing(true)
    }
}

extension RegisterBasicInfoViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        pickerView.pickerView(pickerView, didSelectRow: pickerView.selectedRow(inComponent: 0), inComponent: 0)
        self.view.endEditing(true)
    }
}

extension RegisterBasicInfoViewController: CustomPickerViewProtocol {
    func onKeyChanged(key: String) {
        viewModel?.onKeyChanged(key: key)
    }
}

extension RegisterBasicInfoViewController {
    
    private func bindViewModel() {
        bindToBaseViewModel(viewModel: viewModel!)
        
        self.holdAPost.text = viewModel?.company
        self.account.text = viewModel?.id
        
        viewModel?.endEditing = { [weak self] in
            self?.view.endEditing(true)
        }
        
        viewModel?.presentPickerView = {[weak self] isPickerViewShow in
            
            self?.view.layoutIfNeeded()
            
            let constant = isPickerViewShow ? -(self?.pickerView.frame.height)! - (self?.toolBarOnPickerView.frame.height)! : 0
            self?.pickerViewTop.constant = constant
            
            let scrollViewSize = (self?.scrollView.contentSize.height)! - (self?.scrollView.bounds.height)!
            let bottomOffset = CGPoint(x: 0, y: isPickerViewShow ? scrollViewSize + (self?.pickerView.frame.height)! : scrollViewSize)
            self?.scrollView.setContentOffset(bottomOffset, animated: true)
        }
        
        viewModel?.updatePickerView = { [weak self] list, textAlign, selectedKey in
            self?.pickerView.setOptionList(optionList: list)
            self?.pickerView.textAlign = textAlign
            
            if let key = selectedKey {
                _ = self?.pickerView.setDefaultKey(key: key)
            }
        }
        
        viewModel?.setCompanyAndNameView = { [weak self] key in
            self?.source.text = key
            self?.introCompanyAndNameView.isHidden = false
            self?.tempView.isHidden = false
            self?.emailView.isHidden = true
        }
        
        viewModel?.setEmailView = { [weak self] key in
            self?.source.text = key
            self?.introCompanyAndNameView.isHidden = true
            self?.tempView.isHidden = true
            self?.emailView.isHidden = false
        }
        
        viewModel?.setSourceView = { [weak self] key in
            self?.source.text = key
            self?.introCompanyAndNameView.isHidden = true
            self?.tempView.isHidden = false
            self?.emailView.isHidden = true
        }
        
        viewModel?.selectEmailView = { [weak self] key in
            self?.emailSource.text = key
        }
        
        viewModel?.pushToVC = { [weak self] vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        viewModel?.setError = { [weak self] textField, error in
            
            switch textField {
            case "Company_Idno":
                self?.toast(text: error)
            case "Member_Idno":
                self?.toast(text: error)
            case "Member_Password":
                self?.password.someController?.setErrorText(error, errorAccessibilityValue: nil)
                self?.passwordExample.isHidden = true
                self?.password.becomeFirstResponder()
            case "Password_Identify":
                self?.confirmPassword.someController?.setErrorText(error, errorAccessibilityValue: nil)
                self?.confirmPasswordExample.isHidden = true
                self?.confirmPassword.becomeFirstResponder()
            case "Password_Reminder":
                self?.passwordHint.someController?.setErrorText(error, errorAccessibilityValue: nil)
                self?.passwordHintExample.isHidden = true
                self?.passwordHint.becomeFirstResponder()
            case "Member_Name":
                self?.chineseName.someController?.setErrorText(error, errorAccessibilityValue: nil)
                self?.chineseName.becomeFirstResponder()
            case "Member_Gender":
                self?.genderError.text = "\(error)"
            case "Member_Birthday":
                self?.birthday.someController?.setErrorText(error, errorAccessibilityValue: nil)
                self?.birthday.becomeFirstResponder()
            case "Member_Email":
                self?.email.someController?.setErrorText(error, errorAccessibilityValue: nil)
                self?.emailExample.isHidden = true
                self?.email.becomeFirstResponder()
            case "Company_Phone_Zone", "Company_Phone_No", "Company_Phone_Ext":
                self?.companyArea.someController?.setErrorText("", errorAccessibilityValue: nil)
                self?.companyPhone.someController?.setErrorText("", errorAccessibilityValue: nil)
                self?.companyPhoneExt.someController?.setErrorText("", errorAccessibilityValue: nil)
                self?.companyPhoneError.isHidden = false
                self?.companyPhoneError.text = error
            case "Mobile_Phone":
                self?.cellPhone.someController?.setErrorText(error, errorAccessibilityValue: nil)
                self?.cellPhone.becomeFirstResponder()
            case "Main_Biz":
                self?.toast(text: error)
            case "Channel_Type":
                self?.toast(text: error)
            case "Media_Idno":
                self?.introCompanyName.someController?.setErrorText(error, errorAccessibilityValue: nil)
                self?.introCompanyName.becomeFirstResponder()
            case "Media_Name":
                self?.introName.someController?.setErrorText(error, errorAccessibilityValue: nil)
                self?.introName.becomeFirstResponder()
            case "Media_Email":
                self?.toast(text: error)
            default:
                break
            }
        }
    }
    
    private func setView() {
        self.holdAPost.someController?.placeholderText = "任職旅行社"
        self.account.someController?.placeholderText = "會員帳號"
        self.password.someController?.placeholderText = "＊密碼"
        self.confirmPassword.someController?.placeholderText = "＊密碼確認"
        self.passwordHint.someController?.placeholderText = "＊密碼提示"
        self.chineseName.someController?.placeholderText = "＊中文姓名"
        self.birthday.someController?.placeholderText = "＊出生日期"
        self.email.someController?.placeholderText = "＊電子郵件"
        self.companyArea.someController?.placeholderText = "區碼"
        self.companyPhone.someController?.placeholderText = "電話"
        self.cellPhone.someController?.placeholderText = "＊手機電話"
        self.source.someController?.placeholderText = "＊消息來源"
        self.introCompanyName.someController?.placeholderText = "公司名稱"
        self.introName.someController?.placeholderText = "姓名"
        self.emailSource.someController?.placeholderText = "請選擇"
        self.companyPhoneExt.someController?.placeholderText = "分機號碼"
        self.emailView.isHidden = true
        self.introCompanyAndNameView.isHidden = true
        self.companyPhoneError.isHidden = true
        
        self.password.delegate = self
        self.confirmPassword.delegate = self
        self.passwordHint.delegate = self
        self.chineseName.delegate = self
        self.email.delegate = self
        self.companyArea.delegate = self
        self.companyPhone.delegate = self
        self.companyPhoneExt.delegate = self
        self.cellPhone.delegate = self
        self.introCompanyName.delegate = self
        self.introName.delegate = self
        self.scrollView.delegate = self
        
        self.backButton.layer.borderColor = ColorHexUtil.hexColor(hex: "#19BF62").cgColor
        
        self.birthday.inputView = datePicker
        self.birthday.inputAccessoryView = toolBarOnDatePicker
        
        let ges = UITapGestureRecognizer.init(target: self, action: #selector(dimissKeyBoard))
        view.addGestureRecognizer(ges)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func dimissKeyBoard() {
        self.view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        
        UIView.animate(withDuration: 0.05, animations: {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.cgRectValue.height + 25, right: 0)
            }
        })
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        
        UIView.animate(withDuration: 0.05, animations: {
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        })
    }
    
    private func layoutPickerView() {
        view.addSubview(pickerView)
        view.addSubview(toolBarOnPickerView)
        
        pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pickerView.backgroundColor = UIColor.white
        
        toolBarOnPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolBarOnPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        pickerViewTop = toolBarOnPickerView.topAnchor.constraint(equalTo: view.bottomAnchor)
        pickerViewTop.isActive = true
        
        pickerView.topAnchor.constraint(equalTo: toolBarOnPickerView.bottomAnchor, constant: 0).isActive = true
    }
    
    @objc private func onTouchPickerViewDone() {
        pickerView.pickerView(pickerView, didSelectRow: pickerView.selectedRow(inComponent: 0), inComponent: 0)
        viewModel?.setScrollView()
        viewModel?.setInputFieldType(inputFieldType: nil)
    }
}

extension RegisterBasicInfoViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
            
        case password:
            self.password.someController?.setErrorText(nil, errorAccessibilityValue: nil)
            self.passwordExample.isHidden = false
            
        case confirmPassword:
            self.confirmPassword.someController?.setErrorText(nil, errorAccessibilityValue: nil)
            self.confirmPasswordExample.isHidden = false
            
        case passwordHint:
            self.passwordHint.someController?.setErrorText(nil, errorAccessibilityValue: nil)
            self.passwordHintExample.isHidden = false
            
        case chineseName:
            self.chineseName.someController?.setErrorText(nil, errorAccessibilityValue: nil)
            
        case email:
            self.email.someController?.setErrorText(nil, errorAccessibilityValue: nil)
            self.emailExample.isHidden = false
            
        case companyArea, companyPhone, companyPhoneExt:
            self.companyArea.someController?.setErrorText(nil, errorAccessibilityValue: nil)
            self.companyPhone.someController?.setErrorText(nil, errorAccessibilityValue: nil)
            self.companyPhoneExt.someController?.setErrorText(nil, errorAccessibilityValue: nil)
            self.companyPhoneError.text = ""
            self.companyPhoneError.isHidden = true
            
        case cellPhone:
            self.cellPhone.someController?.setErrorText(nil, errorAccessibilityValue: nil)
            
        case birthday:
            self.birthday.someController?.setErrorText(nil, errorAccessibilityValue: nil)
            
        case introCompanyName:
            self.introCompanyName.someController?.setErrorText(nil, errorAccessibilityValue: nil)
            
        case introName:
            self.introName.someController?.setErrorText(nil, errorAccessibilityValue: nil)
            
        default:
            break
        }
        return true
    }
}
