//
//  RegisterCompanyViewModel.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/12/7.
//  Copyright © 2021 Colatour. All rights reserved.
//
import RxSwift

extension RegisterCompanyViewModel {
    
    enum InputFieldType {
        case businessType
        case city
        case district
    }
}

class RegisterCompanyViewModel: BaseViewModel {
    
    var companyId: String?
    
    var endEditing: (()->())?
    var presentPickerView: ((Bool)->())?
    var setBusinessType: ((String)->())?
    var setCity: ((String, Bool)->())?
    var setDistrict: ((String)->())?
    var setApplicant: ((String)->())?
    var setPrincipal: ((String)->())?
    var setCompany: ((String)->())?
    var setCompanyArea: ((String)->())?
    var setCompanyPhoneError: ((String)->())?
    var setCompanyFaxError: ((String)->())?
    var updatePickerView: (([ShareOption], NSTextAlignment, String?)->())?
    var setToast: ((String) -> ())?
    var pushToVC: ((UIViewController) -> ())?
    
    private var registerCityResponse: RegisterCityResponse?
    private var businessType: String?
    private var city: String?
    private var cityCode: String?
    private var district: String?
    private var districtCode: String?
    
    private var touchInputField: InputFieldType? {
        didSet{
            reloadPickerViewAndDatePicker(inputFieldType: touchInputField)
            showKeyBoardWith(inputFieldType: touchInputField)
        }
    }
    
    private let registerRepository = RegisterRepository.shared
    private var disposeBag = DisposeBag()
    
    var businessTypeShareOptionList =
    [KeyValue(key: "綜合", value: "綜合"),
     KeyValue(key: "甲種", value: "甲種"),
     KeyValue(key: "乙種", value: "乙種")
    ]
    
    func setViewModel(id: String) {
        self.companyId = id
    }
    
    func setInputFieldType(inputFieldType: InputFieldType?) {
        self.touchInputField = inputFieldType
    }
    
    func getCity() {
        
        onStartLoadingHandle?(.coverPlate)
        
        registerRepository.getCity().subscribe(onSuccess: { [weak self] (model) in
            self?.onBindCity(model: model)
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.onApiErrorHandle?((error as! APIError), .coverPlate)
            self?.onCompletedLoadingHandle?()
        }).disposed(by: disposeBag)
    }
    
    func onKeyChanged(key: String) {
        switch touchInputField {
            
        case .businessType:
            self.businessType = key
            setBusinessType?(key)
            
        case .city:
            let keyValue = registerCityResponse!.cityList!.first{ $0.zoneCode == key }!
            let changeDic: Bool = (cityCode != keyValue.zoneCode)
            self.cityCode = keyValue.zoneCode
            self.city = keyValue.zoneName
            setCity?(keyValue.zoneName ?? "", changeDic)
            
        case .district:
            let keyValue = registerCityResponse!.cityList!.first{ $0.zoneName == city }!
            let value = keyValue.zoneList?.first{$0.zoneCode == key}
            self.district = value?.zoneName
            self.districtCode = value?.zoneCode
            setDistrict?(value?.zoneName ?? "")
            
        case nil:
            ()
        }
    }
    
    func onTouchDistrict() {
        
        if city != nil {
            setInputFieldType(inputFieldType: .district)
        } else {
            setToast?("請輸入區域")
        }
    }
    
    func onTouchNext(applicant: String?,
                     principal: String?,
                     company: String?,
                     companyArea: String?,
                     companyAreaCode: String?,
                     companyPhone: String?,
                     companyFaxAreaCode: String?,
                     companyFaxPhone: String?) {
        
        let request = RegisterCompanyRequest.init(senderName: applicant ?? "", companyIdno: companyId ?? "", bossName: principal ?? "", companyName: company ?? "", businessType: businessType ?? "", zoneCode: cityCode ?? "", zoneName: city ?? "", zipCode: districtCode ?? "", zipName: district ?? "", companyAddress: companyArea ?? "", companyPhoneZone: companyAreaCode ?? "", companyPhoneNo: companyPhone ?? "", companyFaxZone: companyFaxAreaCode ?? "" , companyFaxNo: companyFaxPhone ?? "")
        
        if applicant.isNilOrEmpty == true {
            setApplicant?("請填寫申請人")
            return
        }
        if principal.isNilOrEmpty == true {
            setPrincipal?("請填寫負責人")
            return
        }
        if company.isNilOrEmpty == true {
            setCompany?("請填寫公司名稱")
            return
        }
        if businessType.isNilOrEmpty == true {
            setToast?("請選擇營業種類")
            return
        }
        if city.isNilOrEmpty == true {
            setToast?("請選擇區域")
            return
        }
        if district.isNilOrEmpty == true {
            setToast?("請選擇鄉鎮市區")
            return
        }
        if companyArea.isNilOrEmpty == true {
            setCompanyArea?("請填寫公司地址")
            return
        }
        if companyAreaCode.isNilOrEmpty == true || companyPhone.isNilOrEmpty == true {
            setCompanyPhoneError?("請填寫公司電話")
            return
        }
        if companyFaxAreaCode.isNilOrEmpty == true || companyFaxPhone.isNilOrEmpty == true {
            setCompanyFaxError?("請填寫傳真電話")
            return
        }
        
        postRegister(request: request)
    }
}

extension RegisterCompanyViewModel {
    
    private func postRegister(request: RegisterCompanyRequest) {
        
        onStartLoadingHandle?(.coverPlate)
        
        registerRepository.memberRegister(registerRequest: request).subscribe(onSuccess: { [weak self] (model) in
            self?.onBindRegisterError(model: model)
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.onApiErrorHandle?((error as! APIError), .coverPlate)
            self?.onCompletedLoadingHandle?()
        }).disposed(by: disposeBag)
    }
    
    private func getEditorAgent() {
        
        onStartLoadingHandle?(.coverPlate)
        
        registerRepository.getIDTitle().subscribe(onSuccess: { [weak self] (model) in
            self?.onBindIDTitle(model: model)
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.onApiErrorHandle?((error as! APIError), .coverPlate)
            self?.onCompletedLoadingHandle?()
        }).disposed(by: disposeBag)
    }
    
    private func onBindCity(model: RegisterCityResponse) {
        self.registerCityResponse = model
    }
    
    private func reloadPickerViewAndDatePicker(inputFieldType: InputFieldType?) {
        var shareOptionList:[ShareOption] = []
        var selectedKey: String?
        let textAlign: NSTextAlignment = .center
        
        switch inputFieldType {
        case .businessType:
            shareOptionList = businessTypeShareOptionList.map({ ShareOption(optionKey: $0.key!, optionValue: $0.value!) })
            selectedKey = businessType
            
        case .city:
            shareOptionList = registerCityResponse?.cityList?.map({ ShareOption(optionKey: $0.zoneCode!, optionValue: $0.zoneName!) }) ?? []
            selectedKey = cityCode
            
        case .district:
            let keyValue = registerCityResponse!.cityList!.first{ $0.zoneName == city }!
            shareOptionList = keyValue.zoneList?.map({ShareOption(optionKey: $0.zoneCode!, optionValue: $0.zoneName!) }) ?? []
            selectedKey = districtCode
            
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
            
        case .businessType:
            showKeyboard(keyboardType: .pickerView)
        case .city:
            showKeyboard(keyboardType: .pickerView)
        case .district:
            showKeyboard(keyboardType: .pickerView)
        case nil:
            showKeyboard(keyboardType: .hide)
        }
    }
    
    private func onBindRegisterError(model: RegisterResponse) {
        
        var phoneError = ""
        var faxError = ""
        
        if model.errorMsgList == [] {
            getEditorAgent()
        }
        
        model.errorMsgList?.forEach{ name in
            switch name.columnName {
            case "Sender_Name":
                self.setApplicant?(name.errorMessage ?? "")
            case "Company_Idno":
                self.setToast?(name.errorMessage ?? "")
            case "Boss_Name":
                self.setPrincipal?(name.errorMessage ?? "")
            case "Company_Name":
                self.setCompany?(name.errorMessage ?? "")
            case "Business_Type":
                self.setToast?(name.errorMessage ?? "")
            case "Zone_Code","Zone_Name":
                self.setToast?(name.errorMessage ?? "")
            case "Zip_Code","Zip_Name":
                self.setToast?(name.errorMessage ?? "")
            case "Company_Address":
                self.setCompanyArea?(name.errorMessage ?? "")
            case "Company_Phone_Zone", "Company_Phone_No":
                if phoneError.isEmpty == false { phoneError.append("\n") }
                phoneError += "\(name.errorMessage ?? "")"
                phoneError.isEmpty == false ? setCompanyPhoneError?(phoneError) : ()
            case "Company_Fax_Zone", "Company_Fax_No":
                if faxError.isEmpty == false { faxError.append("\n") }
                faxError += "\(name.errorMessage ?? "")"
                faxError.isEmpty == false ? setCompanyFaxError?(faxError) : ()
            default:
                break
            }
        }
    }
    
    private func onBindIDTitle(model: RegisterIdTitleModel) {
        let storyboard = UIStoryboard(name: "Register", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RegisterIdCardViewController") as! RegisterIdCardViewController
        let viewModel = RegisterIdCardViewModel()
        viewModel.setViewModel(title: model.titleName ?? "", company: companyId ?? "")
        viewController.setVC(viewModel: viewModel)
        
        pushToVC?(viewController)
    }
}
