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
    case typekeyboard
    case pickerView
    case datePicker
    case hide
}

enum SearchByType {
    case groupAir
    case soto
    case lcc
}
enum ArrivalType {
    case departureCity
    case backStartingCity
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
    private var tktSearchInit: AirTicketSearchResponse?
    private var groupTicketRequest = TKTSearchRequest()
    private var sotoTicketRequest = TKTSearchRequest()
    private var lccTicketRequest = LCCTicketRequest()
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
        case .groupAir:
            groupTicketRequest.startTourDate = FormatUtil.convertDateToString(dateFormatTo: "yyyy/MM/dd", date: picker.date)
        case .soto:
            sotoTicketRequest.startTourDate = FormatUtil.convertDateToString(dateFormatTo: "yyyy/MM/dd", date: picker.date)
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
        var shareOptionList:[ShareOption] = []
        var selectedKey: String?
        let textAlign: NSTextAlignment = .center
       
        switch inputFieldType {
        case .startTourDate:
            switch searchType {
            case .groupAir:
                if let date = groupTicketRequest.startTourDate {
                    datePicker.date = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: date) ?? Date()
                }
            case .soto:
                if let date = sotoTicketRequest.startTourDate {
                    datePicker.date = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: date) ?? Date()
                }
            default:
                ()
            }
            
    
        case .id:
            shareOptionList = tktSearchInit?.identity.map({ ShareOption(optionKey: $0.value!, optionValue: $0.text!) }) ?? []
            switch searchType {
            case .groupAir:
                selectedKey = groupTicketRequest.selectedID?.value
            case .soto:
                selectedKey = sotoTicketRequest.selectedID?.value
            default:
                ()
            }
            
        case .departureCity:
           
            switch searchType {
            case .groupAir:
                 shareOptionList = tktSearchInit?.groupAir?.departure.map({ ShareOption(optionKey: $0.value!, optionValue: $0.text!) }) ?? []
                 selectedKey = groupTicketRequest.selectedDeparture?.value
            case .soto:
                 shareOptionList = tktSearchInit?.sOTOTicket?.departure.map({ ShareOption(optionKey: $0.value!, optionValue: $0.text!) }) ?? []
                 selectedKey = sotoTicketRequest.selectedDeparture?.value
            default:
                ()
            }
           
        case .sitClass:
            shareOptionList = tktSearchInit?.sitClass.map({ ShareOption(optionKey: $0.value!, optionValue: $0.text!) }) ?? []
            switch searchType {
            case .groupAir:
                selectedKey = groupTicketRequest.selectedSitClass?.value
            case .soto:
                selectedKey = sotoTicketRequest.selectedSitClass?.value
            default:
                ()
            }
            
        case .airlineCode:
            switch searchType {
            case .groupAir:
                 shareOptionList = tktSearchInit?.groupAir?.airline.map({ ShareOption(optionKey: $0.value!, optionValue: $0.text!) }) ?? []
                 selectedKey = groupTicketRequest.selectedAirlineCode?.value
            case .soto:
                 shareOptionList = tktSearchInit?.sOTOTicket?.airline.map({ ShareOption(optionKey: $0.value!, optionValue: $0.text!) }) ?? []
                 selectedKey = sotoTicketRequest.selectedAirlineCode?.value
            default:
                ()
            }
            
        case .tourType:
            switch searchType {
            case .groupAir:
                 shareOptionList = tktSearchInit?.groupAir?.tourType.map({ ShareOption(optionKey: $0.value!, optionValue: $0.text!) }) ?? []
                 selectedKey = groupTicketRequest.selectedTourWay?.value
            case .soto:
                 shareOptionList = tktSearchInit?.sOTOTicket?.tourType.map({ ShareOption(optionKey: $0.value!, optionValue: $0.text!) }) ?? []
                 selectedKey = sotoTicketRequest.selectedTourWay?.value
            default:
                ()
            }
            
        case .dateRange:
            shareOptionList = tktSearchInit?.daterange.map({ ShareOption(optionKey: $0.value!, optionValue: $0.text!) }) ?? []
            switch searchType {
            case .groupAir:
                selectedKey = groupTicketRequest.selectedDateRange?.value
            case .soto:
                selectedKey = sotoTicketRequest.selectedDateRange?.value
            default:
                ()
            }
            
        case nil:
            ()
        
        case .sotoArrival:
            shareOptionList = tktSearchInit?.sOTOTicket?.arrivals.map({ ShareOption(optionKey: $0.value!, optionValue: $0.text!) }) ?? []
            selectedKey = sotoTicketRequest.selectedDestinatione?.value
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
            var isNumberpadKeyboardShow: Bool = false {
                didSet {
                    switch isNumberpadKeyboardShow {
                    case true :
                        ()
                    case false:
                        self.view.endEditing(true)
                    }
                }
            }
            
            var isDatePickerViewShow: Bool = false {
                didSet {
                    let constant = isDatePickerViewShow ? -datePicker.frame.height - toolBarOnDatePicker.frame.height : 0
                    datePickerTop.constant = constant
                    
                    UIView.animate(withDuration: 0.3) {
                        self.view.layoutIfNeeded()
                    }
                }
            }
            
            var isPickerViewShow: Bool = false {
                didSet {
                    let constant = isPickerViewShow ? -pickerView.frame.height - toolBarOnPickerView.frame.height : 0
                    pickerViewTop.constant = constant
                    
                    UIView.animate(withDuration: 0.3) {
                        self.view.layoutIfNeeded()
                    }
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
        
        case nil:
            showKeyboard(keyboardType: .hide)
        
        case .sotoArrival:
            showKeyboard(keyboardType: .pickerView)
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
        pickerView.backgroundColor = UIColor.white
        datePicker.backgroundColor = UIColor.white
        layoutDatePicker()
        layoutPickerView()
    }
    
    override func loadData() {
        super.loadData()
        presenter?.getAirTicketSearchInit()
    }

    private func setUpTopPageScrollView(){
        self.topPageScrollView.delegate = self
        scrollTopPageButtonBottomLine(percent: 0)
        switchPageButton(sliderLeading: 0)
    }
}
extension AirTicketSearchViewController: AirTicketSearchViewProtocol {
    func onBindAirTicketSearchInit(groupTourSearchInit: AirTicketSearchResponse) {
        self.tktSearchInit = groupTourSearchInit
        groupTicketRequest.selectedID = groupTourSearchInit.identity.first
        groupTicketRequest.selectedSitClass = groupTourSearchInit.sitClass.first
        groupTicketRequest.selectedAirlineCode = groupTourSearchInit.groupAir?.airline.first
        groupTicketRequest.startTourDate = groupTourSearchInit.minDate
        groupTicketRequest.selectedDateRange = groupTourSearchInit.daterange.first
        groupTicketRequest.selectedTourWay = groupTourSearchInit.groupAir?.tourType.first
        groupTicketRequest.selectedDeparture = groupTourSearchInit.groupAir?.departure.first
        
        sotoTicketRequest.selectedID = groupTourSearchInit.identity.first
        sotoTicketRequest.selectedSitClass = groupTourSearchInit.sitClass.first
        sotoTicketRequest.selectedAirlineCode = groupTourSearchInit.sOTOTicket?.airline.first
        sotoTicketRequest.startTourDate = groupTourSearchInit.minDate
        sotoTicketRequest.selectedDateRange = groupTourSearchInit.daterange.first
        sotoTicketRequest.selectedTourWay = groupTourSearchInit.sOTOTicket?.tourType.first
        sotoTicketRequest.selectedDeparture = groupTourSearchInit.sOTOTicket?.departure.first
        sotoTicketRequest.selectedDestinatione = groupTourSearchInit.sOTOTicket?.arrivals.first
        let defaultMinDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        let defaultMaxDate = Calendar.current.date(byAdding: .day, value: 2, to: defaultMinDate!)
        lccTicketRequest.startTourDate = FormatUtil.convertDateToString(dateFormatTo: "yyyy/MM/dd", date: defaultMinDate!)
        lccTicketRequest.endTourDate = FormatUtil.convertDateToString(dateFormatTo: "yyyy/MM/dd", date: defaultMaxDate!)
        tableViewGroupAir.reloadData()
    }
}
extension AirTicketSearchViewController: CustomPickerViewProtocol{
    func onKeyChanged(key: String) {
        
        switch touchInputField {
        case .startTourDate:
            //Note: 不使用PickerView，用DatePicker datePickerChanged(picker:)
            ()
        case .id:
            switch searchType {
            case .groupAir:
                let keyValue = tktSearchInit!.identity.first{ $0.value == key }!
                self.groupTicketRequest.selectedID = keyValue
            case .soto:
                let keyValue = tktSearchInit!.identity.first{ $0.value == key }!
                self.sotoTicketRequest.selectedID = keyValue
            default:
                ()
            }
            
        case .airlineCode:
            switch searchType {
            case .groupAir:
                let keyValue = tktSearchInit!.groupAir?.airline.first{ $0.value == key }!
                self.groupTicketRequest.selectedAirlineCode = keyValue
            case .soto:
                let keyValue = tktSearchInit!.sOTOTicket?.airline.first{ $0.value == key }!
                self.sotoTicketRequest.selectedAirlineCode = keyValue
            default:
                ()
            }
            
        case .sitClass:
            switch searchType {
            case .groupAir:
                let keyValue = tktSearchInit!.sitClass.first{ $0.value == key }!
                self.groupTicketRequest.selectedSitClass = keyValue
            case .soto:
                let keyValue = tktSearchInit!.sitClass.first{ $0.value == key }!
                self.sotoTicketRequest.selectedSitClass = keyValue
            default:
                ()
            }
            
        case .tourType:
            switch searchType {
            case .groupAir:
                let keyValue = tktSearchInit!.groupAir?.tourType.first{ $0.value == key }!
                self.groupTicketRequest.selectedTourWay = keyValue
            case .soto:
                let keyValue = tktSearchInit!.sOTOTicket?.tourType.first{ $0.value == key }!
                self.sotoTicketRequest.selectedTourWay = keyValue
            default:
                ()
            }
            
        case .dateRange:
            switch searchType {
            case .groupAir:
                let keyValue = tktSearchInit!.daterange.first{ $0.value == key }!
                self.groupTicketRequest.selectedDateRange = keyValue
            case .soto:
                let keyValue = tktSearchInit!.daterange.first{ $0.value == key }!
                self.sotoTicketRequest.selectedDateRange = keyValue
            default:
                ()
            }
            
        case .departureCity:
            switch searchType {
            case .groupAir:
                let keyValue = tktSearchInit!.groupAir?.departure.first{ $0.value == key }!
                self.groupTicketRequest.selectedDeparture = keyValue
            case .soto:
                let keyValue = tktSearchInit!.sOTOTicket?.departure.first{ $0.value == key }!
                self.sotoTicketRequest.selectedDeparture = keyValue
            default:
                ()
            }
        case .sotoArrival:
            let keyValue = tktSearchInit!.sOTOTicket?.arrivals.first{ $0.value == key }!
            self.sotoTicketRequest.selectedDestinatione = keyValue
            
        default:
            ()
        }
        
        tableViewGroupAir?.reloadData()
        tableViewSotoAir.reloadData()
    }
}
extension AirTicketSearchViewController: GroupAirCellProtocol {
    func onTouchSelection(selection: TKTInputFieldType, searchType: SearchByType) {
        self.searchType = searchType
        self.touchInputField = selection
    }
    
    func onTouchSearch(searchType: SearchByType) {
        switch searchType {
        case .groupAir:
            ()
        case .soto:
            ()
        case .lcc:
            ()
        }
    }
    
    func onTouchArrival(arrival: ArrivalType, searchType: SearchByType) {
        self.searchType = searchType
        switch arrival {
        case .backStartingCity:
            ()
        case .departureCity:
            ()

        }
    }
    
    func onTouchNonStop(searchType: SearchByType) {
        switch searchType {
        case .groupAir:
            self.groupTicketRequest.isNonStop = !self.groupTicketRequest.isNonStop
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
    func onTouchAirlineSwitch() {
        self.lccTicketRequest.isSameAirline.toggle()
        self.tableViewLCC.reloadData()
    }
    
    func onTouchDate() {
        ()
    }
    
    func onTouchRadio(isToAndFor: Bool) {
        lccTicketRequest.isToAndFro = isToAndFor
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupAirCell") as! GroupAirCell
            cell.setCell(info: self.groupTicketRequest, searchType: .groupAir)
            cell.delegate = self
            return cell
        case tableViewSotoAir:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SotoAirCell") as! SotoAirCell
            cell.setCell(info: self.sotoTicketRequest, searchType: .soto)
            cell.delegate = self
            return cell
        case tableViewLCC:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LccCell") as! LccCell
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
