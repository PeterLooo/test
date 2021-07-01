//
//  GroupTourSearchViewModel.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/6/21.
//  Copyright © 2021 Colatour. All rights reserved.
//

import UIKit
import RxSwift

extension GroupTourSearchViewModel {
    enum GroupTourSearchTabType {
        case groupTour
        case keywordOrTourCode
    }
    
    enum InputFieldType {
        case startTourDate
        case tourDays
        case regionCode
        case departureCity
        case airlineCode
        case tourType
        case keywordOrTourCode
        case keywordOrTourCodeDepartureCity
    }
    
    enum KeyboardType {
        case typekeyboard
        case pickerView
        case datePicker
        case hide
    }
    
    enum SearchByType {
        case groupTour
        case keyword
        case tourCode
    }
}

class GroupTourSearchViewModel: BaseViewModel {
    
    var endEditing: (()->())?
    var setDatePickerDate: ((Date)->())?
    var presentDatePicker: ((Bool)->())?
    var presentPickerView: ((Bool)->())?
    var reloadTableView: (()->())?
    var updatePickerView: (([ShareOption], NSTextAlignment, String?)->())?
    
    private var touchInputField: InputFieldType? {
        didSet{
            reloadPickerViewAndDatePicker(inputFieldType: touchInputField)
            showKeyBoardWith(inputFieldType: touchInputField)
        }
    }
    var cityKey: String?
    
    var groupTourSearchInit: GroupTourSearchInitResponse.GroupTourSearchInit?
    var groupTourSearchRequest = GroupTourSearchRequest()
    var groupTourSearchKeywordAndTourCodeRequest = GroupTourSearchKeywordAndTourCodeRequest()
    var keywordOrTourCodeDepartureCityShareOptionList =
        [KeyValue(key: "*", value: "不限出發地"),
         KeyValue(key: "台北", value: "台北出發"),
         KeyValue(key: "台中", value: "台中出發"),
         KeyValue(key: "高雄", value: "高雄出發")]
    
    fileprivate var dispose = DisposeBag()
    private let responsitory = GroupReponsitory.shared
    
    override init() {
        super.init()
        groupTourSearchRequest.isPriceLimitValueChange = { [weak self] in
            self?.reloadTableView?()
        }
        groupTourSearchKeywordAndTourCodeRequest.keywordOrTourCodeValueChange = { [weak self] in
            self?.touchInputField = .keywordOrTourCode
        }
    }
    
// MARK: Api
    
    func getGroupTourSearchInit() {
        self.onStartLoadingHandle?(.coverPlate)
        responsitory
            .getGroupTourSearchInit(departureCode: groupTourSearchRequest.selectedDepartureCity?.departureName)
            .subscribe(onSuccess:{ [weak self] (model) in
                self?.onBindGroupTourSearchInit(groupTourSearchInit: model)
                self?.onCompletedLoadingHandle?()
            }, onError: {[weak self] (error) in
                self?.onApiErrorHandle?(error as! APIError, .coverPlate)
                self?.onCompletedLoadingHandle?()
                
            }).disposed(by:dispose)
    }
    
    func getGroupTourSearchUrl(groupTourSearchRequest: GroupTourSearchRequest) {
        self.onStartLoadingHandle?(.coverPlate)
        responsitory
            .getGroupTourSearchUrl(groupTourSearchRequest: groupTourSearchRequest)
            .subscribe(onSuccess:{ [weak self] (model) in
                self?.onBindGroupTourSearchUrl(groupTourSearchUrl: model)
                self?.onCompletedLoadingHandle?()
            }, onError: {[weak self] (error) in
                self?.onApiErrorHandle?(error as! APIError, .alert)
                self?.onCompletedLoadingHandle?()
                
            }).disposed(by:dispose)
    }
    
    func getGroupTourSearchUrl(groupTourSearchKeywordAndTourCodeRequest: GroupTourSearchKeywordAndTourCodeRequest) {
        self.onStartLoadingHandle?(.coverPlate)
        responsitory
            .getGroupTourSearchUrl(groupTourSearchKeywordAndTourCodeRequest: groupTourSearchKeywordAndTourCodeRequest)
            .subscribe(onSuccess:{ [weak self] (model) in
                self?.onBindGroupTourSearchUrl(groupTourSearchUrl: model)
                self?.onCompletedLoadingHandle?()
            }, onError: { [weak self] (error) in
                self?.onApiErrorHandle?(error as! APIError, .alert)
                self?.onCompletedLoadingHandle?()
                
            }).disposed(by:dispose)
    }
    
    func onBindGroupTourSearchInit(groupTourSearchInit: GroupTourSearchInitResponse.GroupTourSearchInit) {
        self.groupTourSearchInit = groupTourSearchInit
        
        if cityKey?.isEmpty == false{
            let departureCode = groupTourSearchInit.departureCityList.first{ $0.departureCode == cityKey }!
            groupTourSearchRequest.selectedDepartureCity = departureCode
            
            let keyValue = keywordOrTourCodeDepartureCityShareOptionList.first{ $0.key == cityKey }!
            groupTourSearchKeywordAndTourCodeRequest.selectedDepartureCity = keyValue
            getGroupTourSearchInit()
            cityKey = ""
        }
        
        if groupTourSearchRequest.selectedDepartureCity == nil {
            groupTourSearchRequest.selectedDepartureCity = groupTourSearchInit.departureCityList.first
            getGroupTourSearchInit()
        }
        
        groupTourSearchRequest.selectedRegionCode = groupTourSearchInit.regionList.first
        
        groupTourSearchRequest.selectedAirlineCode = groupTourSearchInit.airlineCodeList.first
        
        groupTourSearchRequest.selectedTourType = groupTourSearchInit.tourTypeList.first
        
        if  groupTourSearchRequest.startTourDate == nil {
            groupTourSearchRequest.startTourDate = groupTourSearchInit.defaultDepartureDate
        }
        
        if groupTourSearchKeywordAndTourCodeRequest.selectedDepartureCity == nil {
            groupTourSearchKeywordAndTourCodeRequest.selectedDepartureCity = keywordOrTourCodeDepartureCityShareOptionList.first
        }
        
        self.reloadTableView?()
    }
    
    func onBindGroupTourSearchUrl(groupTourSearchUrl: GroupTourSearchUrlResponse.GroupTourSearchUrl) {
        self.handleLinkType?(groupTourSearchUrl.linkType!, groupTourSearchUrl.linkValue, nil, nil)
    }
    
    func getTourSearchUrl(searchByType: SearchByType, cell: GroupTourSearchInputCell){
        switch searchByType {
        case .groupTour:
            groupTourSearchRequest.maxPrice = cell.priceRangeSlider?.getMaxPrice()
            groupTourSearchRequest.minPrice = cell.priceRangeSlider?.getMinPrice()
            getGroupTourSearchUrl(groupTourSearchRequest: groupTourSearchRequest)
            
        case .keyword,
             .tourCode:
            getGroupTourSearchUrl(groupTourSearchKeywordAndTourCodeRequest: groupTourSearchKeywordAndTourCodeRequest)
        }
    }
    
//MARK: UI
    
    func setInputFieldType(inputFieldType: InputFieldType?){
        self.touchInputField = inputFieldType
    }
    
    private func reloadPickerViewAndDatePicker(inputFieldType: InputFieldType?){
        var shareOptionList:[ShareOption] = []
        var selectedKey: String?
        var textAlign: NSTextAlignment = .center
        switch inputFieldType {
        case .startTourDate:
            if let date = groupTourSearchRequest.startTourDate {
                let startTourDate = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: date) ?? Date()
                self.setDatePickerDate?(startTourDate)
            }
        case .tourDays:
            ()
        case .regionCode:
            shareOptionList = groupTourSearchInit?.regionList.map({ ShareOption(optionKey: $0.regionCode!, optionValue: $0.regionName!) }) ?? []
            selectedKey = groupTourSearchRequest.selectedRegionCode?.regionCode
            textAlign = .left
            
        case .departureCity:
            shareOptionList = groupTourSearchInit?.departureCityList.map({ ShareOption(optionKey: $0.departureCode!, optionValue: $0.departureName!) }) ?? []
            selectedKey = groupTourSearchRequest.selectedDepartureCity?.departureCode
            
        case .airlineCode:
            shareOptionList = groupTourSearchInit?.airlineCodeList.map({ ShareOption(optionKey: $0.airlineCode!, optionValue: $0.airlineName!) }) ?? []
            selectedKey = groupTourSearchRequest.selectedAirlineCode?.airlineCode
            
        case .tourType:
            shareOptionList = groupTourSearchInit?.tourTypeList.map({ ShareOption(optionKey: $0.tourTypeCode!, optionValue: $0.tourTypeName!) }) ?? []
            selectedKey = groupTourSearchRequest.selectedTourType?.tourTypeCode
            
        case .keywordOrTourCode:
            ()
        case .keywordOrTourCodeDepartureCity:
            shareOptionList = keywordOrTourCodeDepartureCityShareOptionList.map({ ShareOption(optionKey: $0.key!, optionValue: $0.value!) })
            selectedKey = groupTourSearchKeywordAndTourCodeRequest
                .selectedDepartureCity?
                .key
            
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
            
            var isDatePickerViewShow: Bool = false {
                didSet {
                    presentDatePicker?(isDatePickerViewShow)
                }
            }
            
            var isPickerViewShow: Bool = false {
                didSet {
                    presentPickerView?(isPickerViewShow)
                }
            }
            
            switch keyboardType {
            case .typekeyboard:
                isNumberpadKeyboardShow = true
                isPickerViewShow = false
                isDatePickerViewShow = false
            case .pickerView:
                isNumberpadKeyboardShow = false
                isPickerViewShow = true
                isDatePickerViewShow = false
            case .datePicker:
                isNumberpadKeyboardShow = false
                isPickerViewShow = false
                isDatePickerViewShow = true
            case .hide:
                isNumberpadKeyboardShow = false
                isPickerViewShow = false
                isDatePickerViewShow = false
            }
        }
        
        switch inputFieldType {
        case .startTourDate:
            showKeyboard(keyboardType: .datePicker)
        case .tourDays:
            showKeyboard(keyboardType: .typekeyboard)
        case .regionCode:
            showKeyboard(keyboardType: .pickerView)
        case .departureCity:
            showKeyboard(keyboardType: .pickerView)
        case .airlineCode:
            showKeyboard(keyboardType: .pickerView)
        case .tourType:
            showKeyboard(keyboardType: .pickerView)
        case .keywordOrTourCode:
            showKeyboard(keyboardType: .typekeyboard)
        case .keywordOrTourCodeDepartureCity:
            showKeyboard(keyboardType: .pickerView)
        case nil:
            showKeyboard(keyboardType: .hide)
        }
    }
    
    func onKeyChanged(key: String) {
        switch touchInputField {
        case .startTourDate:
            //Note: 不使用PickerView，用DatePicker datePickerChanged(picker:)
            ()
        case .tourDays:
            //Note: 不使用PickerView，用Textfield cell裡 editingDidEnd textFieldDidChange(_:)
            ()
        case .regionCode:
            let keyValue = groupTourSearchInit!.regionList.first{ $0.regionCode == key }!
            groupTourSearchRequest.selectedRegionCode = keyValue
            
        case .departureCity:
            let keyValue = groupTourSearchInit!.departureCityList.first{ $0.departureCode == key }!
            let lastKeyValue = groupTourSearchRequest.selectedDepartureCity
            
            groupTourSearchRequest.selectedDepartureCity = keyValue
            
            if lastKeyValue?.departureCode != keyValue.departureCode {
                getGroupTourSearchInit()
            }
            
        case .airlineCode:
            let keyValue = groupTourSearchInit!.airlineCodeList.first{ $0.airlineCode == key }!
            groupTourSearchRequest.selectedAirlineCode = keyValue
            
        case .tourType:
            let keyValue = groupTourSearchInit!.tourTypeList.first{ $0.tourTypeCode == key }!
            groupTourSearchRequest.selectedTourType = keyValue
            
        case .keywordOrTourCode:
            //Note: 不使用PickerView，用Textfield cell裡 editingDidEnd textFieldDidChange(_:)
            ()
        case .keywordOrTourCodeDepartureCity:
            let keyValue = keywordOrTourCodeDepartureCityShareOptionList.first{ $0.key == key }!
            groupTourSearchKeywordAndTourCodeRequest.selectedDepartureCity = keyValue
            
        case nil:
            ()
        }
        
        self.reloadTableView?()
    }
}
