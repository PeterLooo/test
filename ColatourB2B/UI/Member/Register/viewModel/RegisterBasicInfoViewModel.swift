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
    
    var setErrorPassword: ((String)->())?
    var setErrorConfirmPassword: ((String)->())?
    var setErrorPasswordHint: ((String)->())?
    var setErrorChineseName: ((String)->())?
    var setErrorEmail: ((String)->())?
    var setErrorCellPhone: ((String)->())?
    var setErrorIntroName: ((String)->())?
    var setErrorIntroCompanyName: ((String)->())?
    var setErrorBirthday: ((String)->())?
    var setErrorPhone: ((String)->())?
    var setToast: ((String)->())?
    var pushToVC: ((UIViewController) -> ())?
    
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
    
    func setViewModel(id: String, company: String) {
        self.id = id
        self.company = company
    }
    
    func onNext(password: String, confirmPassword: String, passwordHint: String, chineseName: String, email: String, companyArea: String, companyPhone: String, companyPhoneExt: String, cellPhone: String, female: String, man: String, group: String, ticket: String,introCompanyName: String, introName: String, birthday: String) {
        
        if password.isEmpty {
            setErrorPassword?("請輸入密碼")
            return
        }
        if confirmPassword.isEmpty {
            setErrorConfirmPassword?("請輸入確認密碼")
            return
        }
        if passwordHint.isEmpty {
            setErrorPasswordHint?("請輸入密碼提示")
            return
        }
        if chineseName.isEmpty {
            setErrorChineseName?("請輸入中文姓名")
            return
        }
        if email.isEmpty {
            setErrorEmail?("請輸入電子郵件")
            return
        }
        if female.isEmpty && man.isEmpty {
            setToast?("請選擇性別")
            return
        }
        if birthday.isEmpty {
            setErrorBirthday?("請選擇出生日期")
            return
        }
        if companyArea.isEmpty || companyPhone.isEmpty || companyPhoneExt.isEmpty {
            setErrorPhone?("請輸入電話號碼")
            return
        }
        if cellPhone.isEmpty {
            setErrorCellPhone?("請輸入電話")
            return
        }
        if group.isEmpty && ticket.isEmpty {
            setToast?("請輸入主要往來業務")
            return
        }
        if password != confirmPassword {
            setErrorConfirmPassword?("密碼與確認密碼不相符")
            return
        }
        
        switch sourceType {
        case "業務拜訪","同業推薦":
            if introCompanyName.isEmpty {
                setErrorIntroCompanyName?("請輸入公司名稱")
                return
            }
            
            if introName.isEmpty {
                setErrorIntroName?("請輸入姓名")
                return
            }
        case "電子郵件":
            if emailKey.isNilOrEmpty {
                setToast?("請選擇電子郵件")
                return
            }
            
        case "ＤＭ文宣","同業媒體":
            break
            
        default:
            setToast?("請選擇消息來源")
            return
        }
        
        var gender: String?
        female != "" ? (gender = female) : (gender = man)
        
        var mainBiz: String?
        group != "" ? (mainBiz = group) : (mainBiz = ticket)
        
        var mediaIdno: String?
        var mediaName: String?
        
        if introCompanyName == "" && emailKey.isNilOrEmpty {
            mediaIdno = ""
            mediaName = ""
        } else {
            if introCompanyName.isEmpty == true {
                mediaIdno = emailKey
                mediaName = emailValue
            }else {
                mediaIdno = introCompanyName
                mediaName = introName
            }
        }
        
        let request = RegisterBasicInfoRequest.init(companyIdno: company ?? "", memberIdno: id ?? "", memberPassword: password , passwordIdentify: confirmPassword , passwordReminder: passwordHint , memberName: chineseName, memberGender: gender ?? "", memberBirthday: birthday, memberEmail: email, companyPhoneZone: companyArea, companyPhoneNo: companyPhone, companyPhoneExt: companyPhoneExt, mobilePhone: cellPhone, mainBiz: mainBiz ?? "", channelType: sourceType ?? "", mediaIdno: mediaIdno ?? "", mediaName: mediaName ?? "")
        
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
            
            switch sourceType {
            case "業務拜訪","同業推薦":
                setCompanyAndNameView?(key)
            case "電子郵件":
                setEmailView?(key)
            default:
                setSourceView?(key)
            }
            
        case .email:
            
            let keyValue = emailShareOptionList.first{ $0.key == key }!
            self.emailKey = key
            self.emailValue = keyValue.value
            selectEmailView?(keyValue.value ?? "")
            
        case nil:
            ()
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
                self.setToast?(name.errorMessage ?? "")
            case "Member_Idno":
                self.setToast?(name.errorMessage ?? "")
            case "Member_Password":
                self.setErrorPassword?(name.errorMessage ?? "")
            case "Password_Identify":
                self.setErrorConfirmPassword?(name.errorMessage ?? "")
            case "Password_Reminder":
                self.setErrorPasswordHint?(name.errorMessage ?? "")
            case "Member_Name":
                self.setErrorChineseName?(name.errorMessage ?? "")
            case "Member_Gender":
                self.setToast?(name.errorMessage ?? "")
            case "Member_Birthday":
                self.setToast?(name.errorMessage ?? "")
            case "Member_Email":
                self.setErrorEmail?(name.errorMessage ?? "")
            case "Company_Phone_Zone", "Company_Phone_No", "Company_Phone_Ext":
                if phoneError.isEmpty == false { phoneError.append("\n") }
                phoneError += "\(name.errorMessage ?? "")"
                phoneError.isEmpty == false ? setErrorPhone?(phoneError) : ()
            case "Mobile_Phone":
                self.setErrorCellPhone?(name.errorMessage ?? "")
            case "Main_Biz":
                self.setToast?(name.errorMessage ?? "")
            case "Channel_Type":
                self.setToast?(name.errorMessage ?? "")
            case "Media_Idno":
                if sourceType == "電子郵件" {
                    self.setToast?("請輸入電子郵件")
                }else {
                    self.setErrorIntroCompanyName?(name.errorMessage ?? "")
                }
            case "Media_Name":
                if sourceType == "電子郵件" {
                    self.setToast?(name.errorMessage ?? "")
                }else {
                    self.setErrorIntroCompanyName?(name.errorMessage ?? "")
                }
            default:
                break
            }
        }
    }
}
