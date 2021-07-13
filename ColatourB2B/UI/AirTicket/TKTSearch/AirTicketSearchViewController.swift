//
//  AirTicketSearchViewController.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2020/3/9.
//  Copyright © 2020 Colatour. All rights reserved.
//
import UIKit

extension AirTicketSearchViewController {
    func setVC(viewModel: AirTicketSearchViewModel){
        self.viewModel = viewModel
    }
}

class AirTicketSearchViewController: BaseViewControllerMVVM {
    
    @IBOutlet weak var topPageScrollView: UIScrollView!
    @IBOutlet weak var topPageButtonView: UIView!
    @IBOutlet weak var topPageGroupAirButton: UIButton!
    @IBOutlet weak var topPageSOTOButton: UIButton!
    @IBOutlet weak var topPageLCCButton: UIButton!
    @IBOutlet weak var pageButtonBottomLineLeading: NSLayoutConstraint!
    @IBOutlet weak var tableViewGroupAir: UITableView!
    @IBOutlet weak var tableViewSotoAir: UITableView!
    @IBOutlet weak var tableViewLCC: UITableView!
    
    private var pickerViewTop: NSLayoutConstraint!
    private var datePickerTop: NSLayoutConstraint!
    
    private var viewModel: AirTicketSearchViewModel?
    
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
        
        switch viewModel?.searchType {
        
        case .airTkt:
            viewModel?.airTicketRequest.startTravelDate = FormatUtil.convertDateToString(dateFormatTo: "yyyy/MM/dd", date: picker.date)
        case .soto:
            viewModel?.sotoTicketRequest.startTravelDate = FormatUtil.convertDateToString(dateFormatTo: "yyyy/MM/dd", date: picker.date)
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
            switch viewModel?.searchType {
            case .airTkt:
                if let date = viewModel?.airTicketRequest.startTravelDate {
                    datePicker.date = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: date) ?? Date()
                    datePicker.minimumDate = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: date) ?? Date()
                    datePicker.maximumDate = calendar.date(byAdding: .month, value: 18, to: datePicker.minimumDate!)
                }
            case .soto:
                if let date = viewModel?.sotoTicketRequest.startTravelDate {
                    datePicker.date = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: date) ?? Date()
                }
            default:
                ()
            }
            
        case .id:
            shareOptionList = viewModel?.sotoSearchInit?.identityTypeList.map({ ShareOption(optionKey: $0, optionValue: $0) }) ?? []
            switch viewModel?.searchType {
            case .airTkt:
                selectedKey = viewModel?.airTicketRequest.identityType
            case .soto:
                selectedKey = viewModel?.sotoTicketRequest.identityType
            default:
                ()
            }
            
        case .departureCity:
            switch viewModel?.searchType {
            case .airTkt:
                shareOptionList = viewModel?.airSearchInit?.departureCodeList.map({ ShareOption(optionKey: $0.departureCodeId!, optionValue: $0.departureCodeName!) }) ?? []
                selectedKey = viewModel?.airTicketRequest.departure?.departureCodeId
            case .soto:
                shareOptionList = viewModel?.sotoSearchInit?.departureCodeList.map({ ShareOption(optionKey: $0.departureCodeId!, optionValue: $0.departureCodeName!) }) ?? []
                selectedKey = viewModel?.sotoTicketRequest.departure?.departureCodeId
            default:
                ()
            }
            
        case .sitClass:
            switch viewModel?.searchType {
            case .airTkt:
                shareOptionList = viewModel?.airSearchInit?.serviceClassList.map({ ShareOption(optionKey: $0.serviceId!, optionValue: $0.serviceName!) }) ?? []
                selectedKey = viewModel?.airTicketRequest.service?.serviceId
            case .soto:
                shareOptionList = viewModel?.sotoSearchInit?.serviceClassList.map({ ShareOption(optionKey: $0.serviceId!, optionValue: $0.serviceName!) }) ?? []
                selectedKey = viewModel?.sotoTicketRequest.service?.serviceId
            default:
                ()
            }
            
        case .airlineCode:
            switch viewModel?.searchType {
            case .airTkt:
                shareOptionList = viewModel?.airSearchInit?.airlineList.map({ ShareOption(optionKey: $0.airlineId!, optionValue: $0.airlineName!) }) ?? []
                selectedKey = viewModel?.airTicketRequest.airline?.airlineId
            case .soto:
                shareOptionList = viewModel?.sotoSearchInit?.airlineList.map({ ShareOption(optionKey: $0.airlineId!, optionValue: $0.airlineName!) }) ?? []
                selectedKey = viewModel?.sotoTicketRequest.airline?.airlineId
            default:
                ()
            }
            
        case .tourType:
            switch viewModel?.searchType {
            case .airTkt:
                shareOptionList = viewModel?.airSearchInit?.journeyTypeList.map({ ShareOption(optionKey: $0, optionValue: $0) }) ?? []
                selectedKey = viewModel?.airTicketRequest.journeyType
            case .soto:
                shareOptionList = viewModel?.sotoSearchInit?.journeyTypeList.map({ ShareOption(optionKey: $0, optionValue: $0) }) ?? []
                selectedKey = viewModel?.sotoTicketRequest.journeyType
            default:
                ()
            }
            
        case .dateRange:
            switch viewModel?.searchType {
            case .airTkt:
                shareOptionList = viewModel?.airSearchInit?.endTravelDateList.map({ ShareOption(optionKey: $0.endTravelDateId!, optionValue: $0.endTravelDateName!) }) ?? []
                selectedKey = viewModel?.airTicketRequest.endTravelDate?.endTravelDateId
            case .soto:
                shareOptionList = viewModel?.sotoSearchInit?.endTravelDateList.map({ ShareOption(optionKey: $0.endTravelDateId!, optionValue: $0.endTravelDateName!) }) ?? []
                selectedKey = viewModel?.sotoTicketRequest.endTravelDate?.endTravelDateId
            default:
                ()
            }
            
        case nil:
            ()
            
        case .sotoArrival:
            shareOptionList = viewModel?.sotoSearchInit?.destinationCodeList.map({ ShareOption(optionKey: $0.destinationCodeId!, optionValue: $0.destinationCodeId!) }) ?? []
            selectedKey = viewModel?.sotoTicketRequest.destination?.destinationCodeId
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setView()
        setUpTopPageScrollView()
        
        viewModel?.getAirTicketSearchInit()
        viewModel?.getLccAirSearchInit()
        viewModel?.getSotoAirSearchInit()
        layoutDatePicker()
        layoutPickerView()
    }
    
    private func setUpTopPageScrollView() {
        
        self.topPageScrollView.delegate = self
        var contentOffset = CGFloat.zero
        
        switch viewModel?.searchType {
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
    
    private func checkAirTicketRequest() -> Bool {
        var allowToSearch = true
        var errorText:[String] = []
        
        switch viewModel?.searchType {
        case .airTkt:
            
            if viewModel?.airTicketRequest.destination?.cityId == nil{
                errorText.append("請輸入目的地")
                allowToSearch = false
            }
            
            if viewModel?.airTicketRequest.journeyType == "雙程" || viewModel?.airTicketRequest.journeyType == "環遊" {
                if viewModel?.airTicketRequest.returnCode?.cityId == nil {
                    errorText.append("請輸入回程目的地")
                    allowToSearch = false
                }
                if viewModel?.airTicketRequest.journeyType == "雙程" || viewModel?.airTicketRequest.journeyType == "環遊" {
                    if viewModel?.airTicketRequest.returnCode?.cityId == nil {
                        errorText.append("請輸入回程目的地")
                        allowToSearch = false
                    }
                    
                    if viewModel?.airTicketRequest.returnCode?.cityId == viewModel?.airTicketRequest.destination?.cityId {
                        errorText.append("回程起點城市代碼不可與目的地相同")
                        allowToSearch = false
                    }
                }
            }
        case .soto:
            if viewModel?.sotoTicketRequest.departure?.departureCodeId == "0" {
                errorText.append("請輸入出發地")
                allowToSearch = false
            }
        case .lcc:
            if viewModel?.lccTicketRequest.departure?.cityId == nil {
                errorText.append("請輸入出發地")
                allowToSearch = false
            }
            if viewModel?.lccTicketRequest.destination?.cityId == nil {
                errorText.append("請輸入目的地")
                allowToSearch = false
            }
            if viewModel?.lccTicketRequest.departure?.cityId != nil && viewModel?.lccTicketRequest.destination?.cityId != nil {
                if checkDestinationIncludeTW() == false {
                    errorText.append("出發地或目的地至少一個為台灣出發")
                    allowToSearch = false
                }
                if viewModel?.lccTicketRequest.departure?.cityId == viewModel?.lccTicketRequest.destination?.cityId{
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
            alertSeverError.addAction(action)
            self.present(alertSeverError, animated: true)
        }
        return allowToSearch
    }
    
    private func checkDestinationIncludeTW() -> Bool {
        let departure = viewModel?.lccTicketRequest.departure
        let destination = viewModel?.lccTicketRequest.destination
        let departureCountry = viewModel?.lccSearchInit?.countryList.filter{$0.countryName == "台灣"}.first
        
        return departureCountry?.cityList.contains(departure!) ?? false || departureCountry?.cityList.contains(destination!) ?? false
    }
    
    private func openCalendar(searchType: SearchByType) {
        
        viewModel?.searchType = searchType
        let vc = getVC(st: "Calendar", vc: "CalendarForTicketViewController") as! CalendarForTicketViewController
        var startDate = Date()
        let endDate = calendar.date(byAdding: .month, value: 18, to: startDate)!
        var type: CalendarSingeleOrMutipleType?
        var selectedDates = CalendarSelectedDates()
        
        switch searchType {
        case .airTkt:
            type = .single
            startDate = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: viewModel?.airSearchInit?.startTravelDate ?? "") ?? Date()
            
            if let selctedDates = viewModel?.airTicketRequest.startTravelDate {
                let selectedStartDate = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: selctedDates)
                selectedDates = CalendarSelectedDates(selectedSingleDate: selectedStartDate,
                                                      selectedStartDate: nil,
                                                      selectedEndDate: nil)
            }
            
        case .soto:
            type = .single
            startDate = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: viewModel?.sotoSearchInit?.startTravelDate ?? "") ?? Date()
            
            if let selctedDates = viewModel?.sotoTicketRequest.startTravelDate {
                let selectedStartDate = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: selctedDates)
                selectedDates = CalendarSelectedDates(selectedSingleDate: selectedStartDate,
                                                      selectedStartDate: nil,
                                                      selectedEndDate: nil)
            }
            
        case .lcc:
            type = viewModel?.lccTicketRequest.isToAndFro ?? false ? .mutiple : .single
            
            if let selctedDates = viewModel?.lccTicketRequest.startTravelDate {
                let selectedStartDate = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: selctedDates)
                let selectedEndDate = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: viewModel?.lccTicketRequest.endTravelDate! ?? "")
                selectedDates = CalendarSelectedDates(selectedSingleDate: type == .single ? selectedStartDate : nil,
                                                      selectedStartDate: type == .single ? nil : selectedStartDate,
                                                      selectedEndDate: type == .single ? nil : type == .single ? nil : selectedEndDate)
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
        
        vc.setVCwith(delegate: self, calendarAllAttribute: calendarAllAttribute)
        vc.setVCNavBarItem(navMode: .present, navTitle: "選擇日期")
        vc.setIsPageSheetPresenting(isPresentVC: true)
        
        let nav = UINavigationController(rootViewController: vc)
        nav.restorationIdentifier = "HotelCalendarNivagationController"
        
        self.present(nav, animated: true, completion: nil)
    }
    
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
    
    private func scrollTopPageButtonBottomLine(percent: CGFloat) {
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

extension AirTicketSearchViewController: CustomPickerViewProtocol {
    func onKeyChanged(key: String) {
        
        switch touchInputField {
        case .startTourDate:
            //Note: 不使用PickerView，用DatePicker datePickerChanged(picker:)
            ()
        case .id:
            switch viewModel?.searchType {
            case .airTkt:
                let keyValue = viewModel?.airSearchInit?.identityTypeList.filter{ $0 == key }.first
                viewModel?.airTicketRequest.identityType = keyValue
            case .soto:
                let keyValue = viewModel?.sotoSearchInit?.identityTypeList.filter{ $0 == key }.first
                viewModel?.sotoTicketRequest.identityType = keyValue
            default:
                ()
            }
            
        case .airlineCode:
            switch viewModel?.searchType {
            case .airTkt:
                let keyValue = viewModel?.airSearchInit?.airlineList.filter{ $0.airlineId == key }.first
                viewModel?.airTicketRequest.airline = keyValue
            case .soto:
                let keyValue = viewModel?.sotoSearchInit?.airlineList.filter{ $0.airlineId == key }.first
                viewModel?.sotoTicketRequest.airline = keyValue
            default:
                ()
            }
            
        case .sitClass:
            switch viewModel?.searchType {
            case .airTkt:
                let keyValue = viewModel?.airSearchInit?.serviceClassList.filter{ $0.serviceId == key }.first
                viewModel?.airTicketRequest.service = keyValue
            case .soto:
                let keyValue = viewModel?.sotoSearchInit?.serviceClassList.filter{ $0.serviceId == key }.first
                viewModel?.sotoTicketRequest.service = keyValue
            default:
                ()
            }
            
        case .tourType:
            switch viewModel?.searchType {
            case .airTkt:
                let keyValue = viewModel?.airSearchInit?.journeyTypeList.filter{ $0 == key }.first
                viewModel?.airTicketRequest.journeyType = keyValue
            case .soto:
                let keyValue = viewModel?.sotoSearchInit?.journeyTypeList.filter{ $0 == key }.first
                viewModel?.sotoTicketRequest.journeyType = keyValue
            default:
                ()
            }
            
        case .dateRange:
            switch viewModel?.searchType {
            case .airTkt:
                let keyValue = viewModel?.airSearchInit?.endTravelDateList.filter{ $0.endTravelDateId == key }.first
                viewModel?.airTicketRequest.endTravelDate = keyValue
            case .soto:
                let keyValue = viewModel?.sotoSearchInit?.endTravelDateList.filter{ $0.endTravelDateId == key }.first
                viewModel?.sotoTicketRequest.endTravelDate = keyValue
            default:
                ()
            }
            
        case .departureCity:
            switch viewModel?.searchType {
            case .airTkt:
                let keyValue = viewModel?.airSearchInit?.departureCodeList.filter{ $0.departureCodeId == key }.first
                viewModel?.airTicketRequest.departure = keyValue
            case .soto:
                let keyValue = viewModel?.sotoSearchInit?.departureCodeList.filter{ $0.departureCodeId == key }.first
                viewModel?.sotoTicketRequest.departure = keyValue
            default:
                ()
            }
            
        case .sotoArrival:
            let keyValue = viewModel?.sotoSearchInit?.destinationCodeList.filter{ $0.destinationCodeId == key }.first
            viewModel?.sotoTicketRequest.destination = keyValue
            
        default:
            ()
        }
        
        tableViewGroupAir?.reloadData()
        tableViewSotoAir.reloadData()
    }
}

extension AirTicketSearchViewController: CalendarDataDestinationViewControllerProtocol {
    func setSelectedDate(selectedYearMonthDaysToString: CalendarSelectedYearMonthDaysString) {
        
        switch viewModel?.searchType {
        case .airTkt:
            viewModel?.airTicketRequest.startTravelDate = selectedYearMonthDaysToString.singleDayString
            tableViewGroupAir.reloadData()
            
        case .soto:
            viewModel?.sotoTicketRequest.startTravelDate = selectedYearMonthDaysToString.singleDayString
            tableViewSotoAir.reloadData()
            
        case .lcc:
            viewModel?.lccTicketRequest.startTravelDate = viewModel?.lccTicketRequest.isToAndFro ?? false ? selectedYearMonthDaysToString.startDayString : selectedYearMonthDaysToString.singleDayString
            let defaultStartDate = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: viewModel?.lccTicketRequest.startTravelDate ?? "")
            let defaultMaxDate = Calendar.current.date(byAdding: .day, value: 2, to: defaultStartDate!)
            viewModel?.lccTicketRequest.endTravelDate = viewModel?.lccTicketRequest.isToAndFro ?? false ? selectedYearMonthDaysToString.endDayString: FormatUtil.convertDateToString(dateFormatTo: "yyyy/MM/dd", date: defaultMaxDate!)
            tableViewLCC.reloadData()
            
        default:
            ()
        }
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
            viewModel?.setCellViewModel(tableView: "AirTktCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "AirTktCell") as! AirTktCell
            cell.setCell(viewModel: (viewModel?.airTktCellViewModel)!)
            return cell
            
        case tableViewSotoAir:
            viewModel?.setCellViewModel(tableView: "SotoAirCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "SotoAirCell") as! SotoAirCell
            cell.setCell(viewModel: (viewModel?.sotoAirCellViewModel)!)
            return cell
            
        case tableViewLCC:
            viewModel?.setCellViewModel(tableView: "LccAirCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "LccAirCell") as! LccAirCell
            cell.setCell(viewModel: (viewModel?.lccAirCellViewModel)!)
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
    
    private func bindViewModel() {
        self.bindToBaseViewModel(viewModel: self.viewModel!)
        
        viewModel?.groupAirReloadData = { [weak self] in
            self?.tableViewGroupAir.reloadData()
        }
        
        viewModel?.sotoAirReloadData = { [weak self] in
            self?.tableViewSotoAir.reloadData()
        }
        
        viewModel?.lccReloadData = { [weak self] in
            self?.tableViewLCC.reloadData()
        }
        
        viewModel?.onTouchArrival = { [weak self] arrival in
            
            self?.setChooseLocationViewController(tktSearchInit: self?.viewModel!.airSearchInit, lccSearchInit: nil, searchType: .airTkt, startEndType: .Departure, arrival: arrival)
        }
        
        viewModel?.onTouchSelection = { [weak self] selection in
            
            self?.touchInputField = selection
            
        }
        
        viewModel?.onTouchDate = { [weak self] in
            self?.openCalendar(searchType: (self?.viewModel?.searchType)!)
        }
        
        viewModel?.onTouchSearch = { [weak self] in
            
            switch self?.viewModel?.searchType {
            case .airTkt:
                if ((self?.checkAirTicketRequest()) != nil) {
                    self?.viewModel?.postAirTicketSearch()
                }
            case .soto:
                if ((self?.checkAirTicketRequest()) != nil) {
                    self?.viewModel?.postSotoTicketSearch()
                }
            case .lcc:
                if ((self?.checkAirTicketRequest()) != nil) {
                    self?.viewModel?.postLCCTicketSearch()
                }
            default:
                ()
            }
        }
        
        viewModel?.onTouchNonStop = { [weak self] in
            self?.touchInputField = nil
            self?.tableViewGroupAir.reloadData()
            self?.tableViewSotoAir.reloadData()
        }
        
        viewModel?.bindSearchUrlResult = { [weak self]  result  in
            self?.handleLinkType(linkType: result.linkType!, linkValue: result.linkValue, linkText: nil)
        }
        
        viewModel?.onTouchLccDeparture = { [weak self] in
            self?.setChooseLocationViewController(tktSearchInit: nil, lccSearchInit: self?.viewModel!.lccSearchInit, searchType: .lcc, startEndType: .Departure, arrival: nil)
        }
        
        viewModel?.onTouchLccDestination = { [weak self] in
            self?.setChooseLocationViewController(tktSearchInit: nil, lccSearchInit: self?.viewModel!.lccSearchInit, searchType: .lcc, startEndType: .Destination, arrival: nil)
        }
        
        viewModel?.onTouchLccRequestByPerson = { [weak self] in
            ()
        }
        
        viewModel?.onTouchAirlineSwitch = { [weak self] in
            self?.tableViewLCC.reloadData()
        }
        
        viewModel?.onTouchLccDate = { [weak self] in
            self?.openCalendar(searchType: .lcc)
        }
        
        viewModel?.onTouchRadio = { [weak self] in
            self?.tableViewLCC.reloadData()
        }
        
        viewModel?.onTouchPax = { [weak self] in
            
            let vc = self?.getVC(st: "TKTSearch", vc: "AirPaxViewController") as! AirPaxViewController
            vc.modalPresentationStyle = .overCurrentContext
            vc.setTextWith(viewModel: AirPaxViewModel(lccTicketRequest: (self?.viewModel?.lccTicketRequest)!))
            vc.onTouchBottomButton = { [weak self] lccTicketRequest in
                self?.viewModel?.lccTicketRequest = lccTicketRequest
                self?.tableViewLCC.reloadData()
            }
            self?.present(vc, animated: true)
        }
    }
    
    private func setView() {
        self.setNavTitle(title: "搜尋")
        self.setNavBarItem(left: .defaultType, mid: .textTitle, right: .nothing)
        self.setNavType(navBarType: .notHidden)
        self.setTabBarType(tabBarType: .hidden)
        self.setIsNavShadowEnable(false)
        pickerView.backgroundColor = UIColor.white
        datePicker.backgroundColor = UIColor.white
    }
    
    private func setChooseLocationViewController(tktSearchInit: TKTInitResponse.TicketResponse?, lccSearchInit: LccResponse.LCCSearchInitialData?, searchType: SearchByType, startEndType: StartEndType, arrival: ArrivalType? = nil) {
        
        let vc = self.getVC(st: "ChooseLocation", vc: "ChooseLocation") as! ChooseLocationViewController
        vc.setVC(viewModel: ChooseLocationViewModel(tktSearchInit: tktSearchInit, lccSearchInit: lccSearchInit, searchType: searchType, startEndType: startEndType, arrival: arrival))
        
        vc.setLocation = { [weak self] cityInfo, searchType, arrival, startEndType in
            
            switch searchType {
            case .airTkt:
                switch arrival {
                case .departureCity:
                    self?.viewModel?.airTicketRequest.destination = cityInfo
                case .backStartingCity:
                    self?.viewModel?.airTicketRequest.returnCode = cityInfo
                default:
                    ()
                }
                self?.tableViewGroupAir.reloadData()
                
            case .lcc:
                switch startEndType {
                case .Departure:
                    self?.viewModel?.lccTicketRequest.departure = cityInfo
                case .Destination:
                    self?.viewModel?.lccTicketRequest.destination = cityInfo
                default:
                    ()
                }
                self?.tableViewLCC.reloadData()
                
            default:
                ()
            }
        }
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        
        self.navigationController?.present(nav, animated: true)
    }
}
