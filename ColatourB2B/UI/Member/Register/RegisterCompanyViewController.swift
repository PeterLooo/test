//
//  RegisterCompanyViewController.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/11/26.
//  Copyright © 2021 Colatour. All rights reserved.
//
import UIKit

extension RegisterCompanyViewController {
    
    func setVC(viewModel: RegisterCompanyViewModel) {
        self.viewModel = viewModel
    }
}

class RegisterCompanyViewController: BaseViewControllerMVVM {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var companyExample: UILabel!
    @IBOutlet weak var id: CustomTextField!
    @IBOutlet weak var businessType: CustomTextField!
    @IBOutlet weak var applicant: CustomTextField!
    @IBOutlet weak var principal: CustomTextField!
    @IBOutlet weak var company: CustomTextField!
    @IBOutlet weak var companyArea: CustomTextField!
    @IBOutlet weak var city: CustomTextField!
    @IBOutlet weak var district: CustomTextField!
    @IBOutlet weak var companyPhone: CustomTextField!
    @IBOutlet weak var companyAreaCode: CustomTextField!
    @IBOutlet weak var companyFaxAreaCode: CustomTextField!
    @IBOutlet weak var companyFaxPhone: CustomTextField!
    @IBOutlet weak var companyPhoneError: UILabel!
    @IBOutlet weak var companyFaxError: UILabel!
    
    private var viewModel: RegisterCompanyViewModel?
    private var pickerViewTop: NSLayoutConstraint!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        viewModel?.getCity()
        layoutPickerView()
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "填寫公司資料"
        self.id.text = viewModel?.companyId ?? ""
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func onTouchNext(_ sender: Any) {
        
        viewModel?.onTouchNext(applicant: applicant.text,
                               principal: principal.text,
                               company: company.text,
                               companyArea: companyArea.text,
                               companyAreaCode: companyAreaCode.text,
                               companyPhone: companyPhone.text,
                               companyFaxAreaCode: companyFaxAreaCode.text,
                               companyFaxPhone: companyFaxPhone.text)
        
    }
    
    @IBAction func onTouchBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTouchBusinessType(_ sender: Any) {
        self.view.endEditing(true)
        viewModel?.setInputFieldType(inputFieldType: .businessType)
    }
    
    @IBAction func onTouchCity(_ sender: Any) {
        self.view.endEditing(true)
        viewModel?.setInputFieldType(inputFieldType: .city)
    }
    
    @IBAction func onTouchDistrict(_ sender: Any) {
        self.view.endEditing(true)
        viewModel?.onTouchDistrict()
    }
    
    @objc private func onTouchPickerViewDone() {
        pickerView.pickerView(pickerView, didSelectRow: pickerView.selectedRow(inComponent: 0), inComponent: 0)
        viewModel?.setInputFieldType(inputFieldType: nil)
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
}

extension RegisterCompanyViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        pickerView.pickerView(pickerView, didSelectRow: pickerView.selectedRow(inComponent: 0), inComponent: 0)
        viewModel?.setInputFieldType(inputFieldType: nil)
        self.view.endEditing(true)
    }
}

extension RegisterCompanyViewController: CustomPickerViewProtocol {
    func onKeyChanged(key: String) {
        viewModel?.onKeyChanged(key: key)
    }
}

extension RegisterCompanyViewController {
    
    private func bindViewModel() {
        
        bindToBaseViewModel(viewModel: viewModel!)
        
        viewModel?.presentPickerView = {[weak self] isPickerViewShow in
            let constant = isPickerViewShow ? -(self?.pickerView.frame.height)! - (self?.toolBarOnPickerView.frame.height)! : 0
            self?.pickerViewTop.constant = constant
            
            UIView.animate(withDuration: 0.3) {
                self?.view.layoutIfNeeded()
            }
        }
        
        viewModel?.updatePickerView = { [weak self] list, textAlign, selectedKey in
            self?.pickerView.setOptionList(optionList: list)
            self?.pickerView.textAlign = textAlign
            
            if let key = selectedKey {
                _ = self?.pickerView.setDefaultKey(key: key)
            }
        }
        
        viewModel?.endEditing = { [weak self] in
            self?.view.endEditing(true)
        }
        
        viewModel?.setBusinessType = { [weak self] type in
            self?.businessType.text = type
        }
        
        viewModel?.setCity = { [weak self] city, change in
            self?.city.someController?.placeholderText = "區域"
            self?.city.text = city
            if change {
                self?.district.text = ""
                self?.district.someController?.placeholderText = "請選擇鄉鎮市區"
            }
        }
        
        viewModel?.setDistrict = { [weak self] district in
            self?.district.someController?.placeholderText = "鄉鎮市區"
            self?.district.text = district
        }
        
        viewModel?.setToast = { [weak self] toast in
            self?.toast(text: toast)
        }
        
        viewModel?.pushToVC = { [weak self] vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        viewModel?.setError = { [weak self] textField, error in
            switch textField {
            case "Sender_Name":
                self?.applicant.someController?.setErrorText(error, errorAccessibilityValue: nil)
                self?.applicant.becomeFirstResponder()
            case "Company_Idno":
                self?.toast(text: error)
            case "Boss_Name":
                self?.principal.someController?.setErrorText(error, errorAccessibilityValue: nil)
                self?.principal.becomeFirstResponder()
            case "Company_Name":
                self?.company.someController?.setErrorText(error, errorAccessibilityValue: nil)
                self?.companyExample.isHidden = true
                self?.company.becomeFirstResponder()
            case "Business_Type":
                self?.toast(text: error)
            case "Zone_Code","Zone_Name":
                self?.toast(text: error)
            case "Zip_Code","Zip_Name":
                self?.toast(text: error)
            case "Company_Address":
                self?.companyArea.someController?.setErrorText(error, errorAccessibilityValue: nil)
                self?.companyArea.becomeFirstResponder()
            case "Company_Phone_Zone", "Company_Phone_No":
                self?.companyAreaCode.someController?.setErrorText("", errorAccessibilityValue: nil)
                self?.companyPhone.someController?.setErrorText("", errorAccessibilityValue: nil)
                self?.companyPhoneError.isHidden = false
                self?.companyPhoneError.text = error
                self?.companyAreaCode.becomeFirstResponder()
            case "Company_Fax_Zone", "Company_Fax_No":
                self?.companyFaxAreaCode.someController?.setErrorText("", errorAccessibilityValue: nil)
                self?.companyFaxPhone.someController?.setErrorText("", errorAccessibilityValue: nil)
                self?.companyFaxError.isHidden = false
                self?.companyFaxError.text = error
                self?.companyFaxPhone.becomeFirstResponder()
            default:
                break
            }
        }
    }
    
    private func setView() {
        self.backButton.layer.borderColor = ColorHexUtil.hexColor(hex: "#19BF62").cgColor
        self.principal.someController?.placeholderText = "＊負責人"
        self.id.someController?.placeholderText = "統一編號"
        self.applicant.someController?.placeholderText = "＊申請人"
        self.company.someController?.placeholderText = "＊公司名稱"
        self.companyArea.someController?.placeholderText = "*公司地址"
        self.companyAreaCode.someController?.placeholderText = "區碼"
        self.companyPhone.someController?.placeholderText = "電話"
        self.companyFaxAreaCode.someController?.placeholderText = "區碼"
        self.companyFaxPhone.someController?.placeholderText = "電話"
        self.city.someController?.placeholderText = "請選擇區域"
        self.district.someController?.placeholderText = "請選擇鄉鎮市區"
        self.businessType.someController?.placeholderText = "*營業種類"
        self.companyFaxError.isHidden = true
        self.companyPhoneError.isHidden = true
        
        self.principal.delegate = self
        self.applicant.delegate = self
        self.company.delegate = self
        self.companyArea.delegate = self
        self.companyAreaCode.delegate = self
        self.companyFaxAreaCode.delegate = self
        self.companyPhone.delegate = self
        self.companyFaxPhone.delegate = self
        self.city.delegate = self
        self.district.delegate = self
        self.businessType.delegate = self
        self.scrollView.delegate = self
        
        let ges = UITapGestureRecognizer.init(target: self, action: #selector(dimissKeyBoard))
        view.addGestureRecognizer(ges)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func dimissKeyBoard() {
        pickerView.pickerView(pickerView, didSelectRow: pickerView.selectedRow(inComponent: 0), inComponent: 0)
        viewModel?.setInputFieldType(inputFieldType: nil)
        self.view.endEditing(true)
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
}

extension RegisterCompanyViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
            
        case principal:
            self.principal.someController?.setErrorText(nil, errorAccessibilityValue: nil)
            
        case applicant:
            self.applicant.someController?.setErrorText(nil, errorAccessibilityValue: nil)
            
        case company:
            self.company.someController?.setErrorText(nil, errorAccessibilityValue: nil)
            self.companyExample.isHidden = false
            
        case companyArea:
            self.companyArea.someController?.setErrorText(nil, errorAccessibilityValue: nil)
            
        case companyAreaCode, companyPhone:
            self.companyAreaCode.someController?.setErrorText(nil, errorAccessibilityValue: nil)
            self.companyPhone.someController?.setErrorText(nil, errorAccessibilityValue: nil)
            self.companyPhoneError.text = ""
            self.companyPhoneError.isHidden = true
            
        case companyFaxAreaCode, companyFaxPhone:
            self.companyFaxAreaCode.someController?.setErrorText(nil, errorAccessibilityValue: nil)
            self.companyFaxPhone.someController?.setErrorText(nil, errorAccessibilityValue: nil)
            self.companyFaxError.text = ""
            self.companyFaxError.isHidden = true
            
        default:
            break
        }
        return true
    }
}
