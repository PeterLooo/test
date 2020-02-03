//
//  GroupTourViewController.swift
//  ColatourB2B
//
//  Created by M6853 on 2020/1/13.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

extension GroupTourSearchViewController {
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

extension GroupTourSearchViewController {
    func setDefaultPage(_ tab: GroupTourSearchTabType){
        defaultPage = tab
    }
}

class GroupTourSearchViewController: BaseViewController {
    @IBOutlet weak var topPageScrollView: UIScrollView!
    @IBOutlet weak var topPageButtonView: UIView!
    @IBOutlet weak var topPageGroupTourButton: UIButton!
    @IBOutlet weak var topPageKeywordOrTourCodeButton: UIButton!
    @IBOutlet weak var pageButtonBottomLineLeading: NSLayoutConstraint!
    @IBOutlet weak var groupTourPageView: UIView!
    @IBOutlet weak var keywrodOrTourCodePageView: UIView!
    
    @IBOutlet weak var groupTourTableView: UITableView!
    @IBOutlet weak var keywordOrTourCodeTableView: UITableView!
    
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
        groupTourSearchRequest.startTourDate = FormatUtil.convertDateToString(dateFormatTo: "yyyy/MM/dd", date: picker.date)
        
        groupTourTableView?.reloadData()
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
    
    private var presenter: GroupTourSearchPresenterProtocol?
    private var groupTourSearchInit: GroupTourSearchInitResponse.GroupTourSearchInit?
    private var groupTourSearchRequest = GroupTourSearchRequest()
    private var groupTourSearchKeywordAndTourCodeRequest = GroupTourSearchKeywordAndTourCodeRequest()
    private var keywordOrTourCodeDepartureCityShareOptionList =
        [KeyValue(key: "*", value: "不限出發地"),
         KeyValue(key: "台北", value: "台北出發"),
         KeyValue(key: "台中", value: "台中出發"),
         KeyValue(key: "高雄", value: "高雄出發")]
    
    private var defaultPage: GroupTourSearchTabType = .groupTour
    private var isNeedShowDefaultPage = true
    
    private var touchInputField: InputFieldType? {
        didSet {
            reloadPickerViewAndDatePicker(inputFieldType: touchInputField)
            showKeyBoardWith(inputFieldType: touchInputField)
        }
    }
    
    private func reloadPickerViewAndDatePicker(inputFieldType: InputFieldType?){
        var shareOptionList:[ShareOption] = []
        var selectedKey: String?
        var textAlign: NSTextAlignment = .center
        switch inputFieldType {
        case .startTourDate:
            if let date = groupTourSearchRequest.startTourDate {
                datePicker.date = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: date) ?? Date()
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
        pickerView.setOptionList(optionList: shareOptionList)
        pickerView.textAlign = textAlign
        pickerView.reloadAllComponents()
        
        if let selectedKey = selectedKey {
            let _ = pickerView.setDefaultKey(key: selectedKey)
        }
    }
    
    private func showKeyBoardWith(inputFieldType: InputFieldType?){
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavTitle(title: "搜尋")
        self.setNavBarItem(left: .defaultType, mid: .textTitle, right: .nothing)
        self.setNavType(navBarType: .notHidden)
        self.setTabBarType(tabBarType: .hidden)
        self.setIsNavShadowEnable(false)
        
        topPageButtonView.setShadow(offset: CGSize(width: 0, height: 1),
                                    opacity: 0.2,
                                    shadowRadius: 1,
                                    color: UIColor.init(named: "陰影灰")!)
        datePicker.backgroundColor = UIColor.white
        pickerView.backgroundColor = UIColor.white
        
        
        setUpTopPageScrollView()
        layoutPickerView()
        layoutDatePicker()
        
        presenter = GroupTourSearchPresenter(delegate: self)
        loadData()

    }
    
    private func setUpTopPageScrollView(){
        self.topPageScrollView.delegate = self
        scrollTopPageButtonBottomLine(percent: 0)
        switchPageButton(toPage: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isNeedShowDefaultPage == false { return }
        isNeedShowDefaultPage = false
        switch defaultPage {
        case .groupTour:
            self.scrollToPage(scrollView: topPageScrollView, page: 0, animated: true)
        case .keywordOrTourCode:
            self.scrollToPage(scrollView: topPageScrollView, page: 1, animated: true)
        }
    }
    
    override func loadData() {
        super.loadData()
        
        getTourSearchInit()
    }
    
    private func getTourSearchInit(){
        presenter?.getGroupTourSearchInit(departureCode: groupTourSearchRequest.selectedDepartureCity?.departureName)
    }
    
    private func getTourSearchUrl(searchByType: SearchByType){
        switch searchByType {
        case .groupTour:
            presenter?.getGroupTourSearchUrl(groupTourSearchRequest: groupTourSearchRequest)
            
        case .keyword,
             .tourCode:
            presenter?.getGroupTourSearchUrl(groupTourSearchKeywordAndTourCodeRequest: groupTourSearchKeywordAndTourCodeRequest)
        }
    }
    
    @IBAction func onTouchStartTourDateView(_ sender: UIButton) {
        touchInputField = .startTourDate
    }
    
    @IBAction func onTouchRegionCodeView(_ sender: UIButton) {
        touchInputField = .regionCode
    }
    
    @IBAction func onTouchDepartureCityView(_ sender: UIButton) {
        touchInputField = .departureCity
    }
    
    @IBAction func onTouchAirlineCodeView(_ sender: UIButton) {
        touchInputField = .airlineCode
    }
    
    @IBAction func onTouchTourTypeView(_ sender: UIButton) {
        touchInputField = .tourType
    }
    
    @IBAction func onTouchBookingTourView(_ sender: UIButton) {
        groupTourSearchRequest.isBookingTour = !groupTourSearchRequest.isBookingTour
        
        touchInputField = nil
        
        groupTourTableView?.reloadData()
    }
    
    @IBAction func onTouchGroupTourSearchButton(_ sender: UIButton) {
        getTourSearchUrl(searchByType: .groupTour)
    }
    
    @IBAction func onTouchSearchByKeywordButton(_ sender: UIButton) {
        groupTourSearchKeywordAndTourCodeRequest.keywordOrTourCodeSearchType = .keyword
        
        getTourSearchUrl(searchByType: .keyword)
    }
    
    @IBAction func onTouchSearchByTourCodeButton(_ sender: UIButton) {
        groupTourSearchKeywordAndTourCodeRequest.keywordOrTourCodeSearchType = .tourCode
        
        getTourSearchUrl(searchByType: .tourCode)
    }
    
    @IBAction func onTouchKeywordAndTourCodeDepartureCityView(_ sender: UIButton) {
        touchInputField = .keywordOrTourCodeDepartureCity
    }
}

extension GroupTourSearchViewController: GroupTourSearchViewProtocol {
    func onBindGroupTourSearchInit(groupTourSearchInit: GroupTourSearchInitResponse.GroupTourSearchInit) {
        self.groupTourSearchInit = groupTourSearchInit
        
        if groupTourSearchRequest.selectedDepartureCity == nil {
            groupTourSearchRequest.selectedDepartureCity = groupTourSearchInit.departureCityList.first
            getTourSearchInit()
        }
        
        groupTourSearchRequest.selectedRegionCode = groupTourSearchInit.regionList.first
        
        groupTourSearchRequest.selectedAirlineCode = groupTourSearchInit.airlineCodeList.first
        
        groupTourSearchRequest.selectedTourType = groupTourSearchInit.tourTypeList.first
        
        groupTourSearchRequest.startTourDate = groupTourSearchInit.defaultDepartureDate
        
        if groupTourSearchKeywordAndTourCodeRequest.selectedDepartureCity == nil {
            groupTourSearchKeywordAndTourCodeRequest.selectedDepartureCity = keywordOrTourCodeDepartureCityShareOptionList.first
        }
       
        groupTourTableView?.reloadData()
        keywordOrTourCodeTableView?.reloadData()
    }
    
    func onBindGroupTourSearchUrl(groupTourSearchUrl: GroupTourSearchUrlResponse.GroupTourSearchUrl) {
        handleLinkType(linkType: groupTourSearchUrl.linkType!, linkValue: groupTourSearchUrl.linkValue, linkText: nil)
    }
}

extension GroupTourSearchViewController: CustomPickerViewProtocol {
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
                getTourSearchInit()
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
        
        groupTourTableView?.reloadData()
        keywordOrTourCodeTableView?.reloadData()
    }
}

extension GroupTourSearchViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case groupTourTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputCell") as! GroupTourSearchInputCell
            cell.setCellWith(groupTourSearchRequest: groupTourSearchRequest)
            cell.delegate = self
            return cell
        case keywordOrTourCodeTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputCell") as! GroupTourSearchKeywordAndTourCodeInputCell
            cell.setCellWith(groupTourSearchKeywordAndTourCodeRequest: groupTourSearchKeywordAndTourCodeRequest)
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
}

//MARK: scroll top page 左邊滑到右邊，右邊滑到左邊
extension GroupTourSearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        touchInputField = nil
        
        if scrollView != topPageScrollView { return }
        
        let wholeWidth = scrollView.contentSize.width
        let nowOffsetX = scrollView.contentOffset.x
        //註解: 使用者滑動時，滑超過一半就應該算下一頁，所以是4.0，不是2.0
        let nowPage = (nowOffsetX < wholeWidth / 4.0) ? 0 : 1
        let percent = nowOffsetX / (wholeWidth / 2.0)
        scrollTopPageButtonBottomLine(percent: percent)
        switchPageButton(toPage: nowPage)
    }
}

extension GroupTourSearchViewController: GroupTourSearchInputCellProtocol {
    func onTouchTourDaysView(_ sender: UIButton) {
        touchInputField = .tourDays
    }
    
    func onTourDaysTextFieldDidChange(text: String) {
        if text == "" {
            groupTourSearchRequest.tourDays = nil
        } else {
            groupTourSearchRequest.tourDays = Int(text)!
        }
        
        groupTourTableView?.reloadData()
    }
}

extension GroupTourSearchViewController: GroupTourSearchKeywordAndTourCodeInputCellProtocol {
    func onTouchKeywordOrTourCodeView(_ sender: UIButton) {
        touchInputField = .keywordOrTourCode
    }
    
    func onKeywordOrTourCodeTextFieldDidChange(text: String) {
        groupTourSearchKeywordAndTourCodeRequest.keywordOrTourCode = text
        
        keywordOrTourCodeTableView?.reloadData()
    }
}

extension GroupTourSearchViewController {
    @IBAction func onTouchGroupTour(_ sender: UIButton){
        self.scrollToPage(scrollView: topPageScrollView, page: 0, animated: true)
    }
    
    @IBAction func onTouchKeywordOrTourCode(_ sender: UIButton){
        self.scrollToPage(scrollView: topPageScrollView, page: 1, animated: true)
    }
    
    private func scrollToPage(scrollView: UIScrollView, page: Int, animated: Bool) {
        var frame: CGRect = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame, animated: animated)
    }
    
    private func scrollTopPageButtonBottomLine(percent: CGFloat){
        let maxOffset = UIScreen.main.bounds.width / 2.0
        let scrollOffset = maxOffset * percent
        self.pageButtonBottomLineLeading.constant = scrollOffset
    }
    
    private func switchPageButton(toPage: Int){
        switch toPage {
        case 0:
            enableButton(topPageGroupTourButton, isEnable: true)
            enableButton(topPageKeywordOrTourCodeButton, isEnable: false)
        case 1:
            enableButton(topPageGroupTourButton, isEnable: false)
            enableButton(topPageKeywordOrTourCodeButton, isEnable: true)
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
