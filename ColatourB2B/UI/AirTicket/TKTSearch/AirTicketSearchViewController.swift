//
//  AirTicketSearchViewController.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2020/3/9.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

enum TKTInputFieldType {
    case startTourDate
    case dateRange
    case id
    case sitClass
    case departureCity
    case sotoArrival
    case airlineCode
    case tourType
}

enum KeyboardType {
    case pickerView
    case datePicker
    case hide
}

enum SearchByType {
    case airTkt
    case soto
    case lcc
}

enum ArrivalType {
    case departureCity
    case backStartingCity
}

enum StartEndType {
    case Departure
    case Destination
}
extension AirTicketSearchViewController {
    func setVC(searchType: SearchByType){
        self.searchType = searchType
    }
}
class AirTicketSearchViewController: BaseViewController {
    
    @IBOutlet weak var topPageScrollView: UIScrollView!
    @IBOutlet weak var topPageButtonView: UIView!
    @IBOutlet weak var topPageGroupAirButton: UIButton!
    @IBOutlet weak var topPageSOTOButton: UIButton!
    @IBOutlet weak var topPageLCCButton: UIButton!
    @IBOutlet weak var pageButtonBottomLineLeading: NSLayoutConstraint!
    @IBOutlet weak var tableViewGroupAir: UITableView!
    @IBOutlet weak var tableViewSotoAir: UITableView!
    @IBOutlet weak var tableViewLCC: UITableView!
    
    private var presenter: AirTicketSearchPresenterProtocol?
    private var airSearchInit: TKTInitResponse.TicketResponse?
    private var sotoSearchInit: TKTInitResponse.TicketResponse?
    private var lccSearchInit: TKTInitResponse.TicketResponse?
    private var airTicketRequest = TKTSearchRequest()
    private var sotoTicketRequest = SotoTicketRequest()
    private var lccTicketRequest = LccTicketRequest()
    private var searchType: SearchByType?
    private var pickerViewTop: NSLayoutConstraint!
    private var datePickerTop: NSLayoutConstraint!
    
    private lazy var datePicker : UIDatePicker = {
        let view = UIDatePicker()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setToBasic()
        view.datePickerMode = .date
        view.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        return view
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
    
    @objc private func onTouchDatePickerDone() {
        datePickerChanged(picker: datePicker)
        
        touchInputField = nil
    }
    
    @objc private func datePickerChanged(picker: UIDatePicker) {
        
        switch searchType {
        case .airTkt:
            airTicketRequest.startTravelDate = FormatUtil.convertDateToString(dateFormatTo: "yyyy/MM/dd", date: picker.date)
        case .soto:
            sotoTicketRequest.startTravelDate = FormatUtil.convertDateToString(dateFormatTo: "yyyy/MM/dd", date: picker.date)
        default:
            ()
        }
        tableViewGroupAir?.reloadData()
        tableViewSotoAir.reloadData()
    }
    
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
    
    @objc private func onTouchPickerViewDone() {
        pickerView.pickerView(pickerView, didSelectRow: pickerView.selectedRow(inComponent: 0), inComponent: 0)
        
        touchInputField = nil
    }
    
    private func layoutPickerView(){
        view.addSubview(pickerView)
        view.addSubview(toolBarOnPickerView)
        
        pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        toolBarOnPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolBarOnPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        pickerViewTop = toolBarOnPickerView.topAnchor.constraint(equalTo: view.bottomAnchor)
        pickerViewTop.isActive = true
    
        pickerView.topAnchor.constraint(equalTo: toolBarOnPickerView.bottomAnchor, constant: 0).isActive = true
    }
    
    private func layoutDatePicker(){
        view.addSubview(datePicker)
        view.addSubview(toolBarOnDatePicker)
        
        datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        toolBarOnDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolBarOnDatePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        datePickerTop = toolBarOnDatePicker.topAnchor.constraint(equalTo: view.bottomAnchor)
        datePickerTop.isActive = true
        
        datePicker.topAnchor.constraint(equalTo: toolBarOnDatePicker.bottomAnchor, constant: 0).isActive = true
    }
    private var touchInputField: TKTInputFieldType? {
        didSet {
            reloadPickerViewAndDatePicker(inputFieldType: touchInputField)
            showKeyBoardWith(inputFieldType: touchInputField)
        }
    }
    
    private func reloadPickerViewAndDatePicker(inputFieldType: TKTInputFieldType?){
        var shareOptionList: [ShareOption] = []
        var selectedKey: String?
        let textAlign: NSTextAlignment = .center
       
        switch inputFieldType {
        case .startTourDate:
            switch searchType {
            case .airTkt:
                if let date = airTicketRequest.startTravelDate {
                    datePicker.date = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: date) ?? Date()
                    datePicker.minimumDate = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: date) ?? Date()
                    datePicker.maximumDate = calendar.date(byAdding: .month, value: 18, to: datePicker.minimumDate!)
                }
            case .soto:
                if let date = sotoTicketRequest.startTravelDate {
                    datePicker.date = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: date) ?? Date()
                }
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
        pickerView.setOptionList(optionList: shareOptionList)
        pickerView.textAlign = textAlign
        pickerView.reloadAllComponents()
        
        if let selectedKey = selectedKey {
            let _ = pickerView.setDefaultKey(key: selectedKey)
        }
    }
    
    private func showKeyBoardWith(inputFieldType: TKTInputFieldType?){
        func showKeyboard(keyboardType : KeyboardType) {
            
            var isDatePickerViewShow: Bool = false {
                didSet {
                    let constant = isDatePickerViewShow ? -datePicker.frame.height - toolBarOnDatePicker.frame.height : 0
                    if datePickerTop != nil {
                        datePickerTop.constant = constant
                    }
                    
                    UIView.animate(withDuration: 0.3) {
                        self.view.layoutIfNeeded()
                    }
                }
            }
            
            var isPickerViewShow: Bool = false {
                didSet {
                    let constant = isPickerViewShow ? -pickerView.frame.height - toolBarOnPickerView.frame.height : 0
                    if pickerViewTop != nil {
                        pickerViewTop.constant = constant
                    }
                    
                    UIView.animate(withDuration: 0.3) {
                        self.view.layoutIfNeeded()
                    }
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
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        presenter = AirTicketSearchPresenter(delegate: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavTitle(title: "搜尋")
        self.setNavBarItem(left: .defaultType, mid: .textTitle, right: .nothing)
        self.setNavType(navBarType: .notHidden)
        self.setTabBarType(tabBarType: .hidden)
        self.setIsNavShadowEnable(false)
        setUpTopPageScrollView()
        presenter?.getAirTicketSearchInit()
        presenter?.getSotoAirSearchInit()
        //presenter?.getLccAirSearchInit()
        pickerView.backgroundColor = UIColor.white
        datePicker.backgroundColor = UIColor.white
        layoutDatePicker()
        layoutPickerView()
        
    }
    
    override func loadData() {
        super.loadData()
        presenter?.getAirTicketSearchInit()
        presenter?.getSotoAirSearchInit()
        //presenter?.getLccAirSearchInit()
    }

    private func setUpTopPageScrollView(){
        self.topPageScrollView.delegate = self
        var contentOffset = CGFloat.zero
        switch searchType {
        case .airTkt:
            scrollTopPageButtonBottomLine(percent: 0)
            switchPageButton(sliderLeading: 0)
        case .soto:
            scrollTopPageButtonBottomLine(percent: 1)
            switchPageButton(sliderLeading: 1)
            contentOffset = screenWidth * 1
        case .lcc:
            scrollTopPageButtonBottomLine(percent: 2)
            switchPageButton(sliderLeading: 2)
            contentOffset = screenWidth * 2
        default:
            ()
        }
        topPageScrollView.layoutIfNeeded()
        topPageScrollView.setContentOffset(CGPoint.init(x: contentOffset, y: 0), animated: true)
    }
    
    private func checkAirTicketRequest() -> Bool{
        var allowToSearch = true
        var errorText:[String] = []
        if airTicketRequest.destination?.cityId == nil{
            errorText.append("請輸入目的地")
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
        if errorText.isEmpty == false {
            let errorResult = errorText.joined(separator: "\n")
            let alertSeverError: UIAlertController = UIAlertController(title: "修正錯誤", message: errorResult, preferredStyle: .alert)
            let action = UIAlertAction(title: "確定", style: UIAlertAction.Style.default, handler: nil)
            alertSeverError.addAction(action)
            self.present(alertSeverError, animated: true)
        }
        return allowToSearch
    }
}

extension AirTicketSearchViewController: AirTicketSearchViewProtocol {
    func onBindSearchUrlResult(result: AirSearchUrlResponse) {
        handleLinkType(linkType: result.airUrlResult!.linkType!, linkValue: result.airUrlResult!.linkValue, linkText: nil)
    }
    
    func onBindAirTicketSearchInit(tktSearchInit: TKTInitResponse) {
        self.airSearchInit = tktSearchInit.initResponse
        self.airTicketRequest = TKTSearchRequest().getAirTicketRequest(response: tktSearchInit.initResponse!)

        tableViewGroupAir.reloadData()
    }
    
    func onBindSotoAirSearchInit(sotoSearchInit: TKTInitResponse) {
        self.sotoSearchInit = sotoSearchInit.initResponse
        self.sotoTicketRequest = SotoTicketRequest().getSotoTicketRequest(response: sotoSearchInit.initResponse!)
        
        tableViewSotoAir.reloadData()
    }
    
//    func onBindLccAirSearchInit(lccSearchInit: LccTicketResponse) {
//
//        self.lccSearchInit = lccSearchInit
//        self.lccTicketRequest = lccTicketRequest().
//        let defaultMinDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
//        let defaultMaxDate = Calendar.current.date(byAdding: .day, value: 2, to: defaultMinDate!)
//        lccTicketRequest.startTourDate = FormatUtil.convertDateToString(dateFormatTo: "yyyy/MM/dd", date: defaultMinDate!)
//        lccTicketRequest.endTourDate = FormatUtil.convertDateToString(dateFormatTo: "yyyy/MM/dd", date: defaultMaxDate!)
//
//        tableViewLCC.reloadData()
//    }
}

extension AirTicketSearchViewController: CustomPickerViewProtocol{
    func onKeyChanged(key: String) {
        
        switch touchInputField {
        case .startTourDate:
            //Note: 不使用PickerView，用DatePicker datePickerChanged(picker:)
            ()
        case .id:
            switch searchType {
            case .airTkt:
                
                let keyValue = airSearchInit?.identityTypeList.filter{ $0 == key }.first
                self.airTicketRequest.identityType = keyValue
            case .soto:
                
                let keyValue = sotoSearchInit?.identityTypeList.filter{ $0 == key }.first
                self.sotoTicketRequest.identityType = keyValue
            default:
                ()
            }
            
        case .airlineCode:
            switch searchType {
            case .airTkt:
                let keyValue = airSearchInit?.airlineList.filter{ $0.airlineId == key }.first
                self.airTicketRequest.airline = keyValue
            case .soto:
                let keyValue = sotoSearchInit?.airlineList.filter{ $0.airlineId == key }.first
                self.sotoTicketRequest.airline = keyValue
            default:
                ()
            }
            
        case .sitClass:
            switch searchType {
            case .airTkt:
                let keyValue = airSearchInit?.serviceClassList.filter{ $0.serviceId == key }.first
                self.airTicketRequest.service = keyValue
            case .soto:
                
                let keyValue = sotoSearchInit?.serviceClassList.filter{ $0.serviceId == key }.first
                self.sotoTicketRequest.service = keyValue
            default:
                ()
            }
            
        case .tourType:
            switch searchType {
            case .airTkt:
                let keyValue = airSearchInit?.journeyTypeList.filter{ $0 == key }.first
                self.airTicketRequest.journeyType = keyValue
            case .soto:
                let keyValue = sotoSearchInit?.journeyTypeList.filter{ $0 == key }.first
                self.sotoTicketRequest.journeyType = keyValue
            default:
                ()
            }
            
        case .dateRange:
            switch searchType {
            case .airTkt:
                
                let keyValue = airSearchInit?.endTravelDateList.filter{ $0.endTravelDateId == key }.first
                self.airTicketRequest.endTravelDate = keyValue
            case .soto:
                
                let keyValue = sotoSearchInit?.endTravelDateList.filter{ $0.endTravelDateId == key }.first
                self.sotoTicketRequest.endTravelDate = keyValue
            default:
                ()
            }
            
        case .departureCity:
            switch searchType {
            case .airTkt:
                let keyValue = airSearchInit?.departureCodeList.filter{ $0.departureCodeId == key }.first
                self.airTicketRequest.departure = keyValue
            case .soto:
                let keyValue = sotoSearchInit?.departureCodeList.filter{ $0.departureCodeId == key }.first
                self.sotoTicketRequest.departure = keyValue
            default:
                ()
            }
        case .sotoArrival:
            
            let keyValue = sotoSearchInit?.destinationCodeList.filter{ $0.destinationCodeId == key }.first
            self.sotoTicketRequest.destination = keyValue
            
        default:
            ()
        }
        
        tableViewGroupAir?.reloadData()
        tableViewSotoAir.reloadData()
    }
}

extension AirTicketSearchViewController: AirTktCellProtocol {
    func onTouchSelection(selection: TKTInputFieldType, searchType: SearchByType) {
        self.searchType = searchType
        self.touchInputField = selection
    }
    
    func onTouchSearch(searchType: SearchByType) {
        switch searchType {
        case .airTkt:
            if checkAirTicketRequest() {
                self.presenter?.postAirTicketSearch(request: self.airTicketRequest)
            }
        case .soto:
            self.presenter?.postSotoTicketSearch(request: self.sotoTicketRequest)
        case .lcc:
            ()
        }
    }
    
    func onTouchArrival(arrival: ArrivalType, searchType: SearchByType) {
        self.searchType = searchType
        let vc = getVC(st: "ChooseLocation", vc: "ChooseLocation") as! ChooseLocationViewController
        
        vc.onBindAirTicketInfo(tktSearchInit: airSearchInit!, searchType: .airTkt, startEndType: .Departure, arrival: arrival)
        vc.delegate = self
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        
        self.navigationController?.present(nav, animated: true)
    }
    
    func onTouchNonStop(searchType: SearchByType) {
        switch searchType {
        case .airTkt:
            self.airTicketRequest.isNonStop = !self.airTicketRequest.isNonStop
        case .soto:
            self.sotoTicketRequest.isNonStop = !self.sotoTicketRequest.isNonStop
        default:
            ()
        }
        
        self.touchInputField = nil
        tableViewGroupAir.reloadData()
        tableViewSotoAir.reloadData()
    }
}

extension AirTicketSearchViewController: LccCellProtocol {
    func onTouchLccDeparture() {
//        let vc = getVC(st: "ChooseLocation", vc: "ChooseLocation") as! ChooseLocationViewController
//        vc.onBindAirTicketInfo(response: airSearchInit!, searchType: SearchByType.lcc, startEndType: StartEndType.Departure)
//
//        let nav = UINavigationController(rootViewController: vc)
//        nav.modalPresentationStyle = .fullScreen
//
//        self.navigationController?.present(nav, animated: true)
    }
    
    func onTouchLccDestination() {
//        let vc = getVC(st: "ChooseLocation", vc: "ChooseLocation") as! ChooseLocationViewController
//        vc.onBindAirTicketInfo(response: airSearchInit!, searchType: SearchByType.lcc, startEndType: StartEndType.Destination)
//
//        let nav = UINavigationController(rootViewController: vc)
//        nav.modalPresentationStyle = .fullScreen
//
//        self.navigationController?.present(nav, animated: true)
    }
    
    func onTouchLccSearch() {
        onTouchSearch(searchType: .lcc)
    }
    
    func onTouchPax() {
        let vc = getVC(st: "TKTSearch", vc: "AirPaxViewController") as! AirPaxViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.setTextWith(lccTicketRequest: self.lccTicketRequest)
        vc.delegate = self
        
        present(vc, animated: true)
    }
    
    func onTouchLccRequestByPerson() {
        ()
    }
    
    func onTouchAirlineSwitch() {
        //self.lccTicketRequest.isSameAirline.toggle()
        self.tableViewLCC.reloadData()
    }
    
    func onTouchDate() {
        let vc = getVC(st: "Calendar", vc: "CalendarForTicketViewController") as! CalendarForTicketViewController
        
        let startDateString = FormatUtil.convertDateToString(dateFormatTo: "yyyy/MM/dd", date: Date())
        let startDate = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: startDateString)!
        let endDate = calendar.date(byAdding: .month, value: 18, to: startDate)!
        
        //let type:CalendarSingeleOrMutipleType = lccTicketRequest.isToAndFro ? .mutiple:.single

        let calendarDateAttribute = CalendarDateAttribute(startDate: startDate, endDate: endDate, limitDates: [], limitWeekdays: [], dateMemo: [:])
//        let calendarType = CalendarType(singleOrMituple: type
//            , isBeforeTodayLimitSelect: true
//            , isAcceptLimitDateInMiddle: false
//            , confirmTextShowDayOrNight: .nights
//            , isAcceptStartDayEqualEndDay: false
//            , isEnableTapEvent: true
//            , isConfirmButtonHidden: false
//            , isDateNoteHiddenWhenDisableDate: true
//            , colorDef: CalendarColorForHotel()
//            , maxLimitedDays: (false , nil)
//            , dateNoteAtSelectedStartEndDate: (isEnable: true, startNote: "出發", endNote: "回程")
//        )
        
//        var selectedDates = CalendarSelectedDates()
//        if let selctedDates = lccTicketRequest.startTourDate {
//            let selectedStartDate = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: selctedDates)
//            let selectedEndDate = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: lccTicketRequest.endTourDate!)
//            selectedDates = CalendarSelectedDates(selectedSingleDate: type == .single ? selectedStartDate : nil, selectedStartDate: type == .single ? nil : selectedStartDate, selectedEndDate: type == .single ? nil : type == .single ? nil : selectedEndDate)
//        }
//
//        let calendarAllAttribute = CalendarAllAttribute(calendarDateAttribute: calendarDateAttribute, calendarType: calendarType, calendarSelectedDates: selectedDates)
        
//        vc.setVCwith(delegate: self,calendarAllAttribute: calendarAllAttribute)
        vc.setVCNavBarItem(navMode: .present, navTitle: "選擇日期")
        vc.setIsPageSheetPresenting(isPresentVC: true)
        let nav = UINavigationController(rootViewController: vc)
        nav.restorationIdentifier = "HotelCalendarNivagationController"
        
        self.present(nav, animated: true, completion: nil)

    }
    
    func onTouchRadio(isToAndFor: Bool) {
        //lccTicketRequest.isToAndFro = isToAndFor
        tableViewLCC.reloadData()
    }
}

//extension AirTicketSearchViewController: CalendarDataDestinationViewControllerProtocol{
//    func setSelectedDate(selectedYearMonthDaysToString: CalendarSelectedYearMonthDaysString) {
//        lccTicketRequest.startTourDate = lccTicketRequest.isToAndFro ? selectedYearMonthDaysToString.startDayString : selectedYearMonthDaysToString.singleDayString
//        let defaultStartDate = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString:lccTicketRequest.startTourDate! )
//        let defaultMaxDate = Calendar.current.date(byAdding: .day, value: 2, to: defaultStartDate!)
//        lccTicketRequest.endTourDate = lccTicketRequest.isToAndFro ? selectedYearMonthDaysToString.endDayString: FormatUtil.convertDateToString(dateFormatTo: "yyyy/MM/dd", date: defaultMaxDate!)
//        tableViewLCC.reloadData()
//    }
//}

extension AirTicketSearchViewController: AirPaxViewControllerProtocol{
    func onTouchBottomButton(lccTicketRequest: LccTicketRequest) {
        self.lccTicketRequest = lccTicketRequest
        tableViewLCC.reloadData()
    }
}

extension AirTicketSearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case tableViewGroupAir:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AirTktCell") as! AirTktCell
            cell.setCell(info: self.airTicketRequest, searchType: .airTkt)
            cell.delegate = self
            return cell
        case tableViewSotoAir:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SotoAirCell") as! SotoAirCell
            cell.setCell(info: self.sotoTicketRequest, searchType: .soto)
            cell.delegate = self
            return cell
        case tableViewLCC:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LccAirCell") as! LccAirCell
            cell.setCell(lccInfo: self.lccTicketRequest)
            cell.delegate = self
            return cell
        default:
           return UITableViewCell()
        }
    }
}

extension AirTicketSearchViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        touchInputField = nil
        if scrollView != self.topPageScrollView { return }
        let wholeWidth = scrollView.contentSize.width
        let nowOffsetX = scrollView.contentOffset.x
        
        let percent = nowOffsetX / (wholeWidth / 3.0)
        scrollTopPageButtonBottomLine(percent: percent)
    }
}

extension AirTicketSearchViewController {
    @IBAction func onTouchGroupAir(_ sender: Any) {
         self.scrollToPage(scrollView: topPageScrollView, page: 0, animated: true)
    }
    @IBAction func onTouchSOTO(_ sender: Any) {
        self.scrollToPage(scrollView: topPageScrollView, page: 1, animated: true)
    }
    @IBAction func onTouchLCC(_ sender: Any) {
        self.scrollToPage(scrollView: topPageScrollView, page: 2, animated: true)
    }
    
    private func scrollToPage(scrollView: UIScrollView, page: Int, animated: Bool) {
        var frame: CGRect = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame, animated: animated)
    }
    
    private func scrollTopPageButtonBottomLine(percent: CGFloat){
        let maxOffset = UIScreen.main.bounds.width / 3.0
        let scrollOffset = maxOffset * percent
        self.pageButtonBottomLineLeading.constant = scrollOffset
        self.switchPageButton(sliderLeading: scrollOffset)
    }
    
    private func switchPageButton(sliderLeading: CGFloat){
        switch sliderLeading {
        case (screenWidth / 3 * 0):
            enableButton(topPageGroupAirButton, isEnable: true)
            enableButton(topPageSOTOButton, isEnable: false)
            enableButton(topPageLCCButton, isEnable: false)
        case (screenWidth / 3 * 1):
            enableButton(topPageGroupAirButton, isEnable: false)
            enableButton(topPageSOTOButton, isEnable: true)
            enableButton(topPageLCCButton, isEnable: false)
        case (screenWidth / 3 * 2):
            enableButton(topPageGroupAirButton, isEnable: false)
            enableButton(topPageSOTOButton, isEnable: false)
            enableButton(topPageLCCButton, isEnable: true)
        default:
            ()
        }
    }
    
    private func enableButton(_ button: UIButton, isEnable: Bool){
        switch isEnable {
        case true:
            let color = UIColor.init(named: "通用綠")!
            button.tintColor = color
            button.setTitleColor(color, for: .normal)
            button.titleLabel?.font = UIFont.init(thickness: .semibold, size: 15.0)
            
        case false:
            let color = UIColor.init(named: "標題黑")!
            button.tintColor = color
            button.setTitleColor(color, for: .normal)
            button.titleLabel?.font = UIFont.init(thickness: .regular, size: 15.0)
        }
    }
}

extension AirTicketSearchViewController: SetChooseLocationProtocol {
    func setLocation(cityInfo: TKTInitResponse.TicketResponse.City, arrival: ArrivalType?) {
        switch arrival {
        case .departureCity:
            airTicketRequest.destination = cityInfo
        case .backStartingCity:
            airTicketRequest.returnCode = cityInfo
        default:
            ()
        }
        tableViewGroupAir.reloadData()
    }
}
