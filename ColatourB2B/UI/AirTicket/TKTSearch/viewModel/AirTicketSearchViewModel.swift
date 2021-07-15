//
//  AirTicketSearchViewModel.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/7/6.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation
import RxSwift

class AirTicketSearchViewModel: BaseViewModel {
        
    var searchType: SearchByType?
    var airSearchInit: TKTInitResponse.TicketResponse?
    var sotoSearchInit: TKTInitResponse.TicketResponse?
    var lccSearchInit: LccResponse.LCCSearchInitialData?
    var airTicketRequest = TKTSearchRequest()
    var sotoTicketRequest = SotoTicketRequest()
    var lccTicketRequest = LccTicketRequest()
    
    var airTktCellViewModel : AirTktCellViewModel?
    var sotoAirCellViewModel: SotoAirCellViewModel?
    var lccAirCellViewModel: LccAirCellViewModel?
    
    var groupAirReloadData: (() -> ())?
    var sotoAirReloadData: (() -> ())?
    var lccReloadData: (() -> ())?
    var onTouchLccDeparture: (() -> ())?
    var onTouchLccDestination: (() -> ())?
    var onTouchPax: (() -> ())?
    var setPickerView: (() -> ())?
    
    var setAlertSeverError: ((_ alertSeverError: UIAlertController,_ action: UIAlertAction) -> ())?
    var presentCalendarForTicketViewController: ((_ calendarAllAttribute: CalendarAllAttribute) ->())?
    var presentDatePicker: ((Bool)->())?
    var presentPickerView: ((Bool)->())?
    var onTouchArrival: ((_ arrival: ArrivalType) -> ())?
    var bindSearchUrlResult: ((_ result: AirSearchUrlResponse.AirUrlResult) -> ())?
    var setDatePicker: ((_ date: String,_ searchType: String) -> ())?
    
    var touchInputField: TKTInputFieldType? {
        didSet {
            reloadPickerViewAndDatePicker(inputFieldType: touchInputField)
            showKeyBoardWith(inputFieldType: touchInputField)
        }
    }
    
    var shareOptionList: [ShareOption] = []
    var selectedKey: String?
    
    fileprivate let repository = TKTRepository.shared
    fileprivate var dispose = DisposeBag()
    
    required init (searchType: SearchByType) {
        self.searchType = searchType
    }
    
    func getAirTicketSearchInit() {
        onStartLoadingHandle?(.coverPlate)
        
        repository.getAirSearchInit().subscribe(onSuccess: { [weak self] (model) in
            self?.onBindAirTicketSearchInit(tktSearchInit: model)
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.onApiErrorHandle?((error as! APIError), .coverPlate)
            self?.onCompletedLoadingHandle?()
        }).disposed(by: dispose)
    }
    
    func getSotoAirSearchInit() {
        onStartLoadingHandle?(.coverPlate)
        
        repository.getSotoSearchInit().subscribe(onSuccess: { [weak self] (model) in
            self?.onBindSotoAirSearchInit(sotoSearchInit: model)
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.onApiErrorHandle?((error as! APIError), .coverPlate)
            self?.onCompletedLoadingHandle?()
        }).disposed(by: dispose)
    }
    
    func getLccAirSearchInit() {
        onStartLoadingHandle?(.coverPlate)
        
        repository.getLccSearchInit().subscribe(onSuccess: { [weak self] (model) in
            
            self?.onBindLccAirSearchInit(lccSearchInit: model)
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.onApiErrorHandle?((error as! APIError), .custom)
            self?.onCompletedLoadingHandle?()
        }).disposed(by: dispose)
    }
    
    func postAirTicketSearch() {
        onStartLoadingHandle?(.coverPlate)
        repository.postAirTicketSearch(request: airTicketRequest).subscribe(onSuccess: { [weak self] (model) in
            self?.onBindSearchUrlResult(result: model)
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.onApiErrorHandle?((error as! APIError), .alert)
            self?.onCompletedLoadingHandle?()
        }).disposed(by: dispose)
    }
    
    func postSotoTicketSearch() {
        onStartLoadingHandle?(.coverPlate)
        repository.postSotoTicketSearch(request: sotoTicketRequest).subscribe(onSuccess: { [weak self] (model) in
            self?.onBindSearchUrlResult(result: model)
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.onApiErrorHandle?((error as! APIError), .alert)
            self?.onCompletedLoadingHandle?()
        }).disposed(by: dispose)
    }
    
    func postLCCTicketSearch() {
        onStartLoadingHandle?(.coverPlate)
        repository.postLCCicketSearch(request: lccTicketRequest).subscribe(onSuccess: { [weak self] (model) in
            self?.onBindSearchUrlResult(result: model)
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.onApiErrorHandle?((error as! APIError), .alert)
            self?.onCompletedLoadingHandle?()
        }).disposed(by: dispose)
    }
    
    func datePickerChanged(date: Date)  {
        
        switch searchType {
        
        case .airTkt:
            airTicketRequest.startTravelDate = FormatUtil.convertDateToString(dateFormatTo: "yyyy/MM/dd", date: date)
        case .soto:
            sotoTicketRequest.startTravelDate = FormatUtil.convertDateToString(dateFormatTo: "yyyy/MM/dd", date: date)
        default:
            ()
        }
        groupAirReloadData?()
        sotoAirReloadData?()
    }
    
    func onKeyChanged(key: String) {
        
        switch touchInputField {
        case .startTourDate:
            //Note: 不使用PickerView，用DatePicker datePickerChanged(picker:)
            ()
        case .id:
            switch searchType {
            case .airTkt:
                let keyValue = airSearchInit?.identityTypeList.filter{ $0 == key }.first
                airTicketRequest.identityType = keyValue
            case .soto:
                let keyValue = sotoSearchInit?.identityTypeList.filter{ $0 == key }.first
                sotoTicketRequest.identityType = keyValue
            default:
                ()
            }
            
        case .airlineCode:
            switch searchType {
            case .airTkt:
                let keyValue = airSearchInit?.airlineList.filter{ $0.airlineId == key }.first
                airTicketRequest.airline = keyValue
            case .soto:
                let keyValue = sotoSearchInit?.airlineList.filter{ $0.airlineId == key }.first
                sotoTicketRequest.airline = keyValue
            default:
                ()
            }
            
        case .sitClass:
            switch searchType {
            case .airTkt:
                let keyValue = airSearchInit?.serviceClassList.filter{ $0.serviceId == key }.first
                airTicketRequest.service = keyValue
            case .soto:
                let keyValue = sotoSearchInit?.serviceClassList.filter{ $0.serviceId == key }.first
                sotoTicketRequest.service = keyValue
            default:
                ()
            }
            
        case .tourType:
            switch searchType {
            case .airTkt:
                let keyValue = airSearchInit?.journeyTypeList.filter{ $0 == key }.first
                airTicketRequest.journeyType = keyValue
            case .soto:
                let keyValue = sotoSearchInit?.journeyTypeList.filter{ $0 == key }.first
                sotoTicketRequest.journeyType = keyValue
            default:
                ()
            }
            
        case .dateRange:
            switch searchType {
            case .airTkt:
                let keyValue = airSearchInit?.endTravelDateList.filter{ $0.endTravelDateId == key }.first
                airTicketRequest.endTravelDate = keyValue
            case .soto:
                let keyValue = sotoSearchInit?.endTravelDateList.filter{ $0.endTravelDateId == key }.first
                sotoTicketRequest.endTravelDate = keyValue
            default:
                ()
            }
            
        case .departureCity:
            switch searchType {
            case .airTkt:
                let keyValue = airSearchInit?.departureCodeList.filter{ $0.departureCodeId == key }.first
                airTicketRequest.departure = keyValue
            case .soto:
                let keyValue = sotoSearchInit?.departureCodeList.filter{ $0.departureCodeId == key }.first
                sotoTicketRequest.departure = keyValue
            default:
                ()
            }
            
        case .sotoArrival:
            let keyValue = sotoSearchInit?.destinationCodeList.filter{ $0.destinationCodeId == key }.first
            sotoTicketRequest.destination = keyValue
            
        default:
            ()
        }
        
        groupAirReloadData?()
        sotoAirReloadData?()
    }
    
    func setSelectedDate(selectedYearMonthDaysToString: CalendarSelectedYearMonthDaysString) {
        
        switch searchType {
        case .airTkt:
            airTicketRequest.startTravelDate = selectedYearMonthDaysToString.singleDayString
            groupAirReloadData?()
            
        case .soto:
            sotoTicketRequest.startTravelDate = selectedYearMonthDaysToString.singleDayString
            sotoAirReloadData?()
            
        case .lcc:
            lccTicketRequest.startTravelDate = lccTicketRequest.isToAndFro ? selectedYearMonthDaysToString.startDayString : selectedYearMonthDaysToString.singleDayString
            let defaultStartDate = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: lccTicketRequest.startTravelDate ?? "")
            let defaultMaxDate = Calendar.current.date(byAdding: .day, value: 2, to: defaultStartDate!)
            lccTicketRequest.endTravelDate = lccTicketRequest.isToAndFro ? selectedYearMonthDaysToString.endDayString: FormatUtil.convertDateToString(dateFormatTo: "yyyy/MM/dd", date: defaultMaxDate!)
            lccReloadData?()
            
        default:
            ()
        }
    }
    
    func openCalendar(searchType: SearchByType) {
        
        self.searchType = searchType
        var startDate = Date()
        let endDate = calendar.date(byAdding: .month, value: 18, to: startDate)!
        var type: CalendarSingeleOrMutipleType?
        var selectedDates = CalendarSelectedDates()
        
        switch searchType {
        case .airTkt:
            type = .single
            startDate = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: airSearchInit?.startTravelDate ?? "") ?? Date()
            
            if let selctedDates = airTicketRequest.startTravelDate {
                let selectedStartDate = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: selctedDates)
                selectedDates = CalendarSelectedDates(selectedSingleDate: selectedStartDate, selectedStartDate: nil, selectedEndDate: nil)
            }
            
        case .soto:
            type = .single
            startDate = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: sotoSearchInit?.startTravelDate ?? "") ?? Date()
            
            if let selctedDates = sotoTicketRequest.startTravelDate {
                let selectedStartDate = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: selctedDates)
                selectedDates = CalendarSelectedDates(selectedSingleDate: selectedStartDate, selectedStartDate: nil, selectedEndDate: nil)
            }
            
        case .lcc:
            type = lccTicketRequest.isToAndFro ? .mutiple : .single
            
            if let selctedDates = lccTicketRequest.startTravelDate {
                let selectedStartDate = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: selctedDates)
                let selectedEndDate = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: lccTicketRequest.endTravelDate!)
                selectedDates = CalendarSelectedDates(selectedSingleDate: type == .single ? selectedStartDate : nil, selectedStartDate: type == .single ? nil : selectedStartDate, selectedEndDate: type == .single ? nil : type == .single ? nil : selectedEndDate)
            }
        }
        
        let calendarType = CalendarType(singleOrMituple: type!,
                                        isBeforeTodayLimitSelect: true,
                                        isAcceptLimitDateInMiddle: false,
                                        confirmTextShowDayOrNight: .nights,
                                        isAcceptStartDayEqualEndDay: false,
                                        isEnableTapEvent: true,
                                        isConfirmButtonHidden: false,
                                        isDateNoteHiddenWhenDisableDate: true,
                                        colorDef: CalendarColorForHotel(),
                                        maxLimitedDays: (false , nil),
                                        dateNoteAtSelectedStartEndDate: (isEnable: true, startNote: "出發", endNote: "回程"))
        let calendarDateAttribute = CalendarDateAttribute(startDate: startDate, endDate: endDate, limitDates: [], limitWeekdays: [], dateMemo: [:])
        let calendarAllAttribute = CalendarAllAttribute(calendarDateAttribute: calendarDateAttribute, calendarType: calendarType, calendarSelectedDates: selectedDates)

        presentCalendarForTicketViewController?(calendarAllAttribute)
    }

    
    func setCellViewModel(tableView: String) {
        
        switch tableView {
        case "AirTktCell":
            airTktCellViewModel = AirTktCellViewModel(info: airTicketRequest)
            
            airTktCellViewModel?.onTouchArrival = { [weak self] arrival, searchType in
                self?.searchType = searchType
                self?.onTouchArrival?(arrival)
            }
            
            airTktCellViewModel?.onTouchDate = { [weak self]  searchType in
                self?.searchType = searchType
                self?.openCalendar(searchType: searchType)
            }
            
            airTktCellViewModel?.onTouchSearch = { [weak self] searchType in
                self?.searchType = searchType
                self?.checkAirTicket()
            }
            
            airTktCellViewModel?.onTouchSelection = { [weak self] selection, searchType in
                self?.searchType = searchType
                self?.touchInputField = selection
            }
            airTktCellViewModel?.onTouchNonStop =  { [weak self] searchType in
                
                switch searchType {
                case .airTkt:
                    self?.airTicketRequest.isNonStop = !(self?.airTicketRequest.isNonStop ?? false)
                case .soto:
                    self?.sotoTicketRequest.isNonStop = !(self?.sotoTicketRequest.isNonStop ?? false)
                default:
                    ()
                }
                self?.touchInputField = nil
                self?.groupAirReloadData?()
                self?.sotoAirReloadData?()
            }
            
        case "SotoAirCell":
            sotoAirCellViewModel = SotoAirCellViewModel(info: sotoTicketRequest)
            
            sotoAirCellViewModel?.onTouchSelection = { [weak self]  selection, searchType in
                self?.searchType = searchType
                self?.touchInputField = selection
            }
            
            sotoAirCellViewModel?.onTouchDate = { [weak self] searchType in
                self?.searchType = searchType
                self?.openCalendar(searchType: searchType)
            }
            
            sotoAirCellViewModel?.onTouchNonStop = { [weak self] searchType in
                switch searchType {
                case .airTkt:
                    self?.airTicketRequest.isNonStop = !(self?.airTicketRequest.isNonStop ?? false)
                case .soto:
                    self?.sotoTicketRequest.isNonStop = !(self?.sotoTicketRequest.isNonStop ?? false)
                default:
                    ()
                }
                self?.groupAirReloadData?()
                self?.sotoAirReloadData?()
            }
            
            sotoAirCellViewModel?.onTouchSearch = { [weak self] searchType in
                self?.searchType = searchType
                self?.checkAirTicket()
            }
            
        case "LccAirCell":
            lccAirCellViewModel = LccAirCellViewModel(lccInfo: lccTicketRequest)
            
            lccAirCellViewModel?.onTouchLccDeparture = { [weak self] in
                self?.onTouchLccDeparture?()
            }
            
            lccAirCellViewModel?.onTouchLccDestination = { [weak self] in
                self?.onTouchLccDestination?()
            }
            
            lccAirCellViewModel?.onTouchLccRequestByPerson = { [weak self] in
                ()
            }
            
            lccAirCellViewModel?.onTouchAirlineSwitch = { [weak self] in
                self?.lccTicketRequest.isSameAirline.toggle()
                self?.lccReloadData?()
            }
            
            lccAirCellViewModel?.onTouchLccDate = { [weak self] in
                self?.openCalendar(searchType: .lcc)
            }
            
            lccAirCellViewModel?.onTouchRadio = { [weak self] isToAndFor in
                self?.lccTicketRequest.isToAndFro = isToAndFor
                self?.lccReloadData?()
            }
            
            lccAirCellViewModel?.onTouchPax = { [weak self] in
                self?.onTouchPax?()
            }
            
            lccAirCellViewModel?.onTouchLccSearch = { [weak self] in
                self?.searchType = .lcc
                self?.checkAirTicket()
            }
            
        default:
            ()
        }
    }
}

extension AirTicketSearchViewModel {
    
    private func onBindAirTicketSearchInit(tktSearchInit: TKTInitResponse) {
        self.airSearchInit = tktSearchInit.initResponse
        self.airTicketRequest = TKTSearchRequest().getAirTicketRequest(response: tktSearchInit.initResponse!)
        if self.airSearchInit?.journeyTypeList.contains("來回") == true {
            self.airTicketRequest.journeyType = "來回"
        }
        groupAirReloadData?()
    }
    
    private func onBindSotoAirSearchInit(sotoSearchInit: TKTInitResponse) {
        self.sotoSearchInit = sotoSearchInit.initResponse
        self.sotoTicketRequest = SotoTicketRequest().getSotoTicketRequest(response: sotoSearchInit.initResponse!)
        if self.sotoSearchInit?.journeyTypeList.contains("來回") == true {
            self.sotoTicketRequest.journeyType = "來回"
        }
        sotoAirReloadData?()
    }
    
    private func onBindLccAirSearchInit(lccSearchInit: LccResponse) {
        self.lccSearchInit = lccSearchInit.lCCSearchInitialData
        self.lccTicketRequest = LccTicketRequest().getLccTicketRequest(reponse: self.lccSearchInit!)
        
        lccReloadData?()
    }
    
    private func onBindSearchUrlResult(result: AirSearchUrlResponse) {
        
        bindSearchUrlResult?(result.airUrlResult!)
    }
    
    private func reloadPickerViewAndDatePicker(inputFieldType: TKTInputFieldType?) {
        
        switch inputFieldType {
        case .startTourDate:
            switch searchType {
            case .airTkt:
                let date = airTicketRequest.startTravelDate ?? ""
                setDatePicker?(date, "airTkt")
            case .soto:
                let date = sotoTicketRequest.startTravelDate ?? ""
                setDatePicker?(date, "soto")
            default:
                ()
            }
            
        case .id:
            shareOptionList = sotoSearchInit?.identityTypeList.map({ ShareOption(optionKey: $0, optionValue: $0) }) ?? []
            switch searchType {
            case .airTkt:
                selectedKey = airTicketRequest.identityType
            case .soto:
                selectedKey = sotoTicketRequest.identityType
            default:
                ()
            }
            
        case .departureCity:
            switch searchType {
            case .airTkt:
                shareOptionList = airSearchInit?.departureCodeList.map({ ShareOption(optionKey: $0.departureCodeId!, optionValue: $0.departureCodeName!) }) ?? []
                selectedKey = airTicketRequest.departure?.departureCodeId
            case .soto:
                shareOptionList = sotoSearchInit?.departureCodeList.map({ ShareOption(optionKey: $0.departureCodeId!, optionValue: $0.departureCodeName!) }) ?? []
                selectedKey = sotoTicketRequest.departure?.departureCodeId
            default:
                ()
            }
            
        case .sitClass:
            switch searchType {
            case .airTkt:
                shareOptionList = airSearchInit?.serviceClassList.map({ ShareOption(optionKey: $0.serviceId!, optionValue: $0.serviceName!) }) ?? []
                selectedKey = airTicketRequest.service?.serviceId
            case .soto:
                shareOptionList = sotoSearchInit?.serviceClassList.map({ ShareOption(optionKey: $0.serviceId!, optionValue: $0.serviceName!) }) ?? []
                selectedKey = sotoTicketRequest.service?.serviceId
            default:
                ()
            }
            
        case .airlineCode:
            switch searchType {
            case .airTkt:
                shareOptionList = airSearchInit?.airlineList.map({ ShareOption(optionKey: $0.airlineId!, optionValue: $0.airlineName!) }) ?? []
                selectedKey = airTicketRequest.airline?.airlineId
            case .soto:
                shareOptionList = sotoSearchInit?.airlineList.map({ ShareOption(optionKey: $0.airlineId!, optionValue: $0.airlineName!) }) ?? []
                selectedKey = sotoTicketRequest.airline?.airlineId
            default:
                ()
            }
            
        case .tourType:
            switch searchType {
            case .airTkt:
                shareOptionList = airSearchInit?.journeyTypeList.map({ ShareOption(optionKey: $0, optionValue: $0) }) ?? []
                selectedKey = airTicketRequest.journeyType
            case .soto:
                shareOptionList = sotoSearchInit?.journeyTypeList.map({ ShareOption(optionKey: $0, optionValue: $0) }) ?? []
                selectedKey = sotoTicketRequest.journeyType
            default:
                ()
            }
            
        case .dateRange:
            switch searchType {
            case .airTkt:
                shareOptionList = airSearchInit?.endTravelDateList.map({ ShareOption(optionKey: $0.endTravelDateId!, optionValue: $0.endTravelDateName!) }) ?? []
                selectedKey = airTicketRequest.endTravelDate?.endTravelDateId
            case .soto:
                shareOptionList = sotoSearchInit?.endTravelDateList.map({ ShareOption(optionKey: $0.endTravelDateId!, optionValue: $0.endTravelDateName!) }) ?? []
                selectedKey = sotoTicketRequest.endTravelDate?.endTravelDateId
            default:
                ()
            }
            
        case nil:
            ()
            
        case .sotoArrival:
            shareOptionList = sotoSearchInit?.destinationCodeList.map({ ShareOption(optionKey: $0.destinationCodeId!, optionValue: $0.destinationCodeId!) }) ?? []
            selectedKey = sotoTicketRequest.destination?.destinationCodeId
        }
        
        setPickerView?()
    }
    
    private func showKeyBoardWith(inputFieldType: TKTInputFieldType?){
        func showKeyboard(keyboardType : KeyboardType) {
            
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
            case .pickerView:
                isPickerViewShow = true
                isDatePickerViewShow = false
            case .datePicker:
                isPickerViewShow = false
                isDatePickerViewShow = true
            case .hide:
                isPickerViewShow = false
                isDatePickerViewShow = false
            }
        }
        
        switch inputFieldType {
        case .startTourDate:
            showKeyboard(keyboardType: .datePicker)
        case .id:
            showKeyboard(keyboardType: .pickerView)
        case .sitClass:
            showKeyboard(keyboardType: .pickerView)
        case .dateRange:
            showKeyboard(keyboardType: .pickerView)
        case .departureCity:
            showKeyboard(keyboardType: .pickerView)
        case .airlineCode:
            showKeyboard(keyboardType: .pickerView)
        case .tourType:
            showKeyboard(keyboardType: .pickerView)
        case .sotoArrival:
            showKeyboard(keyboardType: .pickerView)
        case nil:
            showKeyboard(keyboardType: .hide)
        }
    }
    
    private func checkAirTicketRequest() -> Bool {
        var allowToSearch = true
        var errorText:[String] = []
        
        switch searchType {
        case .airTkt:
            
            if airTicketRequest.destination?.cityId == nil{
                errorText.append("請輸入目的地")
                allowToSearch = false
            }
            
            if airTicketRequest.journeyType == "雙程" || airTicketRequest.journeyType == "環遊" {
                if airTicketRequest.returnCode?.cityId == nil {
                    errorText.append("請輸入回程目的地")
                    allowToSearch = false
                }
                if airTicketRequest.journeyType == "雙程" || airTicketRequest.journeyType == "環遊" {
                    if airTicketRequest.returnCode?.cityId == nil {
                        errorText.append("請輸入回程目的地")
                        allowToSearch = false
                    }
                    
                    if airTicketRequest.returnCode?.cityId == airTicketRequest.destination?.cityId {
                        errorText.append("回程起點城市代碼不可與目的地相同")
                        allowToSearch = false
                    }
                }
            }
        case .soto:
            if sotoTicketRequest.departure?.departureCodeId == "0" {
                errorText.append("請輸入出發地")
                allowToSearch = false
            }
        case .lcc:
            if lccTicketRequest.departure?.cityId == nil {
                errorText.append("請輸入出發地")
                allowToSearch = false
            }
            if lccTicketRequest.destination?.cityId == nil {
                errorText.append("請輸入目的地")
                allowToSearch = false
            }
            if lccTicketRequest.departure?.cityId != nil && lccTicketRequest.destination?.cityId != nil {
                if checkDestinationIncludeTW() == false {
                    errorText.append("出發地或目的地至少一個為台灣出發")
                    allowToSearch = false
                }
                if lccTicketRequest.departure?.cityId == lccTicketRequest.destination?.cityId{
                    errorText.append("回程起點城市代碼不可與目的地相同")
                    allowToSearch = false
                }
            }
        default:
            ()
        }
        
        if errorText.isEmpty == false {
            let errorResult = errorText.joined(separator: "\n")
            let alertSeverError: UIAlertController = UIAlertController(title: "修正錯誤", message: errorResult, preferredStyle: .alert)
            let action = UIAlertAction(title: "確定", style: UIAlertAction.Style.default, handler: nil)
            setAlertSeverError?(alertSeverError, action)
        }
        return allowToSearch
    }
    
    private func checkDestinationIncludeTW() -> Bool {
        let departure = lccTicketRequest.departure
        let destination = lccTicketRequest.destination
        let departureCountry = lccSearchInit?.countryList.filter{$0.countryName == "台灣"}.first
        
        return departureCountry?.cityList.contains(departure!) ?? false || departureCountry?.cityList.contains(destination!) ?? false
    }
    
    private func checkAirTicket() {
        
        switch searchType {
        case .airTkt:
            if checkAirTicketRequest() {
                postAirTicketSearch()
            }
        case .soto:
            if checkAirTicketRequest() {
                postSotoTicketSearch()
            }
        case .lcc:
            if checkAirTicketRequest() {
                postLCCTicketSearch()
            }
        default:
            ()
        }
    }
}
