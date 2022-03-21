//
//  RegisterBasicInfoViewModel.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/12/15.
//  Copyright © 2021 Colatour. All rights reserved.
//
import RxSwift
import UIKit

extension RegisterBasicInfoViewModel {
    
    enum InputFieldType {
        case source
        case email
        case date
    }
}

class RegisterBasicInfoViewModel: BaseViewModel {
    
    var id: String?
    var company: String?
    var endEditing: (()->())?
    var setCompanyAndNameView: ((String)->())?
    var setEmailView: ((String)->())?
    var selectEmailView: ((String)->())?
    var setConfirmPassword: ((String)->())?
    var setSourceView: ((String)->())?
    var presentPickerView: ((Bool)->())?
    var updatePickerView: (([ShareOption], NSTextAlignment, String?)->())?
    
    var setError: ((String, String) -> ())?
    var pushToVC: ((UIViewController) -> ())?
    
    private var companyID: String?
    
    private let registerRepository = RegisterRepository.shared
    private var disposeBag = DisposeBag()
    
    private var touchInputField: InputFieldType? {
        didSet{
            reloadPickerViewAndDatePicker(inputFieldType: touchInputField)
            showKeyBoardWith(inputFieldType: touchInputField)
        }
    }
    
    private var sourceTypeShareOptionList =
    [KeyValue(key: "業務拜訪", value: "業務拜訪"),
     KeyValue(key: "同業推薦", value: "同業推薦"),
     KeyValue(key: "ＤＭ文宣", value: "ＤＭ文宣"),
     KeyValue(key: "同業媒體", value: "同業媒體"),
     KeyValue(key: "電子郵件", value: "電子郵件")
    ]
    
    private var emailShareOptionList =
    [KeyValue(key: "COLA", value: "可樂同業網"),
     KeyValue(key: "ABACUS", value: "ABACUS"),
     KeyValue(key: "COWELL", value: "科威"),
     KeyValue(key: "TOUR", value: "團體DM")
    ]
    
    private var sourceType: String?
    private var emailKey: String?
    private var emailValue: String?
    
    func setViewModel(id: String, companyID: String, companyName: String) {
        self.id = id
        self.company = "\(companyID) \(companyName)"
        self.companyID = companyID
    }
    
    func onNext(password: String, confirmPassword: String, passwordHint: String, chineseName: String, email: String, companyArea: String, companyPhone: String, companyPhoneExt: String, cellPhone: String, female: String, man: String, group: String, ticket: String,introCompanyName: String, introName: String, birthday: String) {
        
        var mediaIdno: String?
        var mediaName: String?
        
        if password.isEmpty {
            setError?("Member_Password", "請輸入密碼")
            return
        }
        if confirmPassword.isEmpty {
            setError?("Password_Identify", "請輸入確認密碼")
            return
        }
        if passwordHint.isEmpty {
            setError?("Password_Reminder", "請輸入密碼提示")
            return
        }
        if chineseName.isEmpty {
            setError?("Member_Name", "請輸入中文姓名")
            return
        }
        if female.isEmpty && man.isEmpty {
            setError?("Member_Gender", "請輸入性別")
            return
        }
        if birthday.isEmpty {
            setError?("Member_Birthday", "請選擇出生日期")
            return
        }
        if email.isEmpty {
            setError?("Member_Email", "請輸入電子郵件")
            return
        }
        if companyArea.isEmpty || companyPhone.isEmpty {
            setError?("Company_Phone_No", "請輸入電話號碼")
            return
        }
        if cellPhone.isEmpty {
            setError?("Mobile_Phone", "請輸入電話")
            return
        }
        if group.isEmpty && ticket.isEmpty {
            setError?("Main_Biz", "請輸入主要往來業務")
            return
        }
        if password != confirmPassword {
            setError?("Password_Identify", "密碼與確認密碼不相符")
            return
        }
        
        switch sourceType {
        case "業務拜訪","同業推薦":
            if introCompanyName.isEmpty {
                setError?("Media_Idno", "請輸入公司名稱")
                return
            }
            
            if introName.isEmpty {
                setError?("Media_Name", "請輸入姓名")
                return
            }
            
            mediaIdno = introCompanyName
            mediaName = introName
        case "電子郵件":
            if emailKey.isNilOrEmpty {
                setError?("Media_Email", "請選擇電子郵件")
                return
            }
            mediaIdno = emailKey
            mediaName = emailValue ?? ""
            
        case "ＤＭ文宣","同業媒體":
            mediaIdno = ""
            mediaName = ""
            break
            
        default:
            setError?("Channel_Type", "請選擇消息來源")
            return
        }
        
        let gender = female != "" ? female : man
        let mainBiz = group != "" ? group : ticket
        
        let request = RegisterBasicInfoRequest.init(companyIdno: companyID ?? "", memberIdno: id ?? "", memberPassword: password , passwordIdentify: confirmPassword , passwordReminder: passwordHint , memberName: chineseName, memberGender: gender , memberBirthday: birthday, memberEmail: email, companyPhoneZone: companyArea, companyPhoneNo: companyPhone, companyPhoneExt: companyPhoneExt, mobilePhone: cellPhone, mainBiz: mainBiz, channelType: sourceType ?? "", mediaIdno: mediaIdno ?? "", mediaName: mediaName ?? "")
        
        postBasicRegister(request: request)
    }
    
    func setInputFieldType(inputFieldType: InputFieldType?) {
        self.touchInputField = inputFieldType
    }
    
    func onKeyChanged(key: String) {
        switch touchInputField {
            
        case .date:
            ()
            
        case .source:
            
            self.sourceType = key
        case .email:
            
            let keyValue = emailShareOptionList.first{ $0.key == key }!
            self.emailKey = key
            self.emailValue = keyValue.value
            selectEmailView?(keyValue.value ?? "")
            
        case nil:
            ()
        }
    }
    
    func setScrollView() {
        switch sourceType {
        case "業務拜訪","同業推薦":
            setCompanyAndNameView?(sourceType!)
        case "電子郵件":
            setEmailView?(sourceType!)
        default:
            setSourceView?(sourceType!)
        }
    }
}

extension RegisterBasicInfoViewModel {
    
    private func postBasicRegister(request: RegisterBasicInfoRequest) {
        
        onStartLoadingHandle?(.coverPlate)
        
        registerRepository.memberRegister(registerRequest: request).subscribe(onSuccess: { [weak self] (model) in
            self?.onBindRegisterError(model: model)
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.onApiErrorHandle?((error as! APIError), .coverPlate)
            self?.onCompletedLoadingHandle?()
        }).disposed(by: disposeBag)
    }
    
    private func reloadPickerViewAndDatePicker(inputFieldType: InputFieldType?) {
        var shareOptionList:[ShareOption] = []
        var selectedKey: String?
        let textAlign: NSTextAlignment = .center
        
        switch inputFieldType {
            
        case .date:
            ()
            
        case .source:
            shareOptionList = sourceTypeShareOptionList.map({ ShareOption(optionKey: $0.key!, optionValue: $0.value!) })
            selectedKey = sourceType
            
        case .email:
            shareOptionList = emailShareOptionList.map({ ShareOption(optionKey: $0.key!, optionValue: $0.value!) })
            selectedKey = emailKey
            
        case nil:
            ()
        }
        
        self.updatePickerView?(shareOptionList,textAlign,selectedKey)
    }
    
    private func showKeyBoardWith(inputFieldType: InputFieldType?){
        func showKeyboard(keyboardType : KeyboardType) {
            var isNumberpadKeyboardShow: Bool = false {
                didSet {
                    switch isNumberpadKeyboardShow {
                    case true :
                        ()
                    case false:
                        self.endEditing?()
                    }
                }
            }
            
            var isPickerViewShow: Bool = false {
                didSet {
                    presentPickerView?(isPickerViewShow)
                }
            }
            
            switch keyboardType {
                
            case .pickerView:
                isNumberpadKeyboardShow = false
                isPickerViewShow = true
            case .datePicker:
                isNumberpadKeyboardShow = false
                isPickerViewShow = false
            case .hide:
                isNumberpadKeyboardShow = false
                isPickerViewShow = false
            }
        }
        
        switch inputFieldType {
        case .date:
            showKeyboard(keyboardType: .datePicker)
        case .source:
            showKeyboard(keyboardType: .pickerView)
        case .email:
            showKeyboard(keyboardType: .pickerView)
        case nil:
            showKeyboard(keyboardType: .hide)
        }
    }
    
    private func onBindRegisterError(model: RegisterResponse) {
        
        if model.errorMsgList == [] {
            let storyboard = UIStoryboard(name: "Register", bundle: Bundle.main)
            let viewController = storyboard.instantiateViewController(withIdentifier: "RegisterSuccessViewController") as! RegisterSuccessViewController
            pushToVC?(viewController)
        }
        
        var phoneError = ""
        
        model.errorMsgList?.forEach{ name in
            switch name.columnName {
            case "Company_Idno":
                self.setError?("Company_Idno", name.errorMessage ?? "")
            case "Member_Idno":
                self.setError?("Member_Idno", name.errorMessage ?? "")
            case "Member_Password":
                self.setError?("Member_Password", name.errorMessage ?? "")
            case "Password_Identify":
                self.setError?("Password_Identify", name.errorMessage ?? "")
            case "Password_Reminder":
                self.setError?("Password_Reminder", name.errorMessage ?? "")
            case "Member_Name":
                self.setError?("Member_Name", name.errorMessage ?? "")
            case "Member_Gender":
                self.setError?("Member_Gender", name.errorMessage ?? "")
            case "Member_Birthday":
                self.setError?("Member_Birthday", name.errorMessage ?? "")
            case "Member_Email":
                self.setError?("Member_Email", name.errorMessage ?? "")
            case "Company_Phone_Zone", "Company_Phone_No", "Company_Phone_Ext":
                if phoneError.isEmpty == false { phoneError.append("\n") }
                phoneError += "\(name.errorMessage ?? "")"
                phoneError.isEmpty == false ? self.setError?("Company_Phone_No", name.errorMessage ?? "") : ()
            case "Mobile_Phone":
                self.setError?("Mobile_Phone", name.errorMessage ?? "")
            case "Main_Biz":
                self.setError?("Main_Biz", name.errorMessage ?? "")
            case "Channel_Type":
                self.setError?("Channel_Type", name.errorMessage ?? "")
            case "Media_Idno":
                self.setError?((sourceType == "電子郵件" ? "Media_Email" : "Media_Idno"), name.errorMessage ?? "")
            case "Media_Name":
                self.setError?((sourceType == "電子郵件" ? "Media_Email" : "Media_Idno"), name.errorMessage ?? "")
            default:
                break
            }
        }
    }
}
