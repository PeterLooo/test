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
        case keywordOrGroupNo
    }
    
    enum InputFieldType {
        case startTourDate
        case tourDays
        case regionCode
        case departureCity
        case airlineCode
        case tourType
    }
    
    enum KeyboardType {
        case numberPad
        case pickerView
        case datePicker
        case hide
    }
}

extension GroupTourSearchViewController {
    func setDefaultPage(_ tab: GroupTourSearchTabType){
        defaultPage = tab
    }
}

class GroupTourSearchRequest: NSObject {
    var startTourDate: String?
    var tourDays: Int?
    var selectedRegionCode: KeyValue?
    var selectedDepartureCity: KeyValue?
    var selectedAirlineCode: KeyValue?
    var selectedTourType: KeyValue?
    var isBookingTour: Bool = false
}

class GroupTourSearchViewController: BaseViewController {
    @IBOutlet weak var topPageScrollView: UIScrollView!
    @IBOutlet weak var topPageButtonView: UIView!
    @IBOutlet weak var topPageGroupTourButton: UIButton!
    @IBOutlet weak var topPageKeywordOrGroupdNoButton: UIButton!
    @IBOutlet weak var pageButtonBottomLineLeading: NSLayoutConstraint!
    @IBOutlet weak var groupTourPageView: UIView!
    @IBOutlet weak var keywrodOrGroupNoPageView: UIView!
    
    @IBOutlet weak var groupTourTableView: UITableView!
    
    @IBOutlet weak var pickerView: CustomPickerView!
    @IBOutlet weak var pickerViewTop: NSLayoutConstraint!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerTop: NSLayoutConstraint!
    
    private var presenter: GroupTourSearchPresenterProtocol?
    private var groupTourSearchInit: GroupTourSearchInitResponse.GroupTourSearchInit?
    private var groupTourSearchRequest = GroupTourSearchRequest()
    
    private var defaultPage: GroupTourSearchTabType = .groupTour
    private var isNeedShowDefaultPage = true
    
    private var touchInputField: InputFieldType? {
        didSet {
            reloadPickerView(inputFieldType: touchInputField)
            showKeyBoardWith(inputFieldType: touchInputField)
        }
    }
    
    private func reloadPickerView(inputFieldType: InputFieldType?){
        var shareOptionList:[ShareOption] = []
        switch inputFieldType {
        case .startTourDate:
            ()
        case .tourDays:
            ()
        case .regionCode:
            shareOptionList = groupTourSearchInit?.regionCodeList.map({ ShareOption(optionKey: $0.key!, optionValue: $0.value!) }) ?? []
        case .departureCity:
            shareOptionList = groupTourSearchInit?.departureCityList.map({ ShareOption(optionKey: $0.key!, optionValue: $0.value!) }) ?? []
        case .airlineCode:
            shareOptionList = groupTourSearchInit?.airlineCodeList.map({ ShareOption(optionKey: $0.key!, optionValue: $0.value!) }) ?? []
        case .tourType:
            shareOptionList = groupTourSearchInit?.tourTypeList.map({ ShareOption(optionKey: $0.key!, optionValue: $0.value!) }) ?? []
        default:
            ()
        }
        self.pickerView.setOptionList(optionList: shareOptionList)
        pickerView.reloadAllComponents()
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
                      let constant = isDatePickerViewShow ? -datePicker.frame.height - 34 : 0
                      datePickerTop.constant = constant
                      
                      UIView.animate(withDuration: 0.3) {
                          self.view.layoutIfNeeded()
                      }
                  }
              }
              
              var isPickerViewShow: Bool = false {
                  didSet {
                      let constant = isPickerViewShow ? -pickerView.frame.height - 34 : 0
                      pickerViewTop.constant = constant
                      
                      UIView.animate(withDuration: 0.3) {
                          self.view.layoutIfNeeded()
                      }
                  }
              }
        
              switch keyboardType {
              case .numberPad:
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
            showKeyboard(keyboardType: .numberPad)
        case .regionCode:
            showKeyboard(keyboardType: .pickerView)
        case .departureCity:
            showKeyboard(keyboardType: .pickerView)
        case .airlineCode:
            showKeyboard(keyboardType: .pickerView)
        case .tourType:
            showKeyboard(keyboardType: .pickerView)
        default:
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
                                    shadowRadius: 4,
                                    color: UIColor
                                        .black
                                        .withAlphaComponent(0.8))
        datePicker.backgroundColor = UIColor.white
        pickerView.backgroundColor = UIColor.white
        
        setUpTopPageScrollView()
        setUpPickerView()
        setUpDatePicker()
        
        presenter = GroupTourSearchPresenter(delegate: self)
        loadData()

    }
    
    private func setUpTopPageScrollView(){
        self.topPageScrollView.delegate = self
        scrollTopPageButtonBottomLine(percent: 0)
        switchPageButton(toPage: 0)
    }
    
    private func setUpPickerView(){
        let emptyShareOptionList: [ShareOption] = []
        self.pickerView.setOptionList(optionList: emptyShareOptionList)
        self.pickerView.valueChangeDelegate = self
    }
    
    private func setUpDatePicker(){
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        groupTourSearchRequest.startTourDate = FormatUtil.convertDateToString(dateFormatTo: "yyyy/MM/dd", date: picker.date)
        
        groupTourTableView?.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isNeedShowDefaultPage == false { return }
        isNeedShowDefaultPage = false
        switch defaultPage {
        case .groupTour:
            self.scrollToPage(scrollView: topPageScrollView, page: 0, animated: true)
        case .keywordOrGroupNo:
            self.scrollToPage(scrollView: topPageScrollView, page: 1, animated: true)
        }
    }
    
    override func loadData() {
        super.loadData()
        
        presenter?.getGroupTourSearchInit()
    }
    
    @IBAction func onTouchStartTourDateView(_ sender: UIButton) {
        touchInputField = .startTourDate
    }
    
    @IBAction func onTouchTourDaysView(_ sender: UIButton) {
        touchInputField = .tourDays
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
        touchInputField = nil
        groupTourSearchRequest.isBookingTour = !groupTourSearchRequest.isBookingTour
        
        groupTourTableView?.reloadData()
    }
    
    @IBAction func onTouchGroupTourSearchButton(_ sender: UIButton) {
        
    }
}

extension GroupTourSearchViewController: GroupTourSearchViewProtocol {
    func onBindGroupTourSearchInit(groupTourSearchInit: GroupTourSearchInitResponse.GroupTourSearchInit) {
        self.groupTourSearchInit = groupTourSearchInit
        
        groupTourSearchRequest.selectedDepartureCity = groupTourSearchInit.departureCityList.first
        
        groupTourSearchRequest.selectedRegionCode = groupTourSearchInit.regionCodeList.first
        
        groupTourSearchRequest.selectedAirlineCode = groupTourSearchInit.airlineCodeList.first
        
        groupTourSearchRequest.selectedTourType = groupTourSearchInit.tourTypeList.first
        
        groupTourSearchRequest.startTourDate = groupTourSearchInit.defaultStarTourDate
        
        if let date = groupTourSearchInit.defaultStarTourDate {
            datePicker.date = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: date) ?? Date()
        }
        
        groupTourSearchRequest.tourDays = groupTourSearchInit.defaultTourDays
        
        groupTourTableView?.reloadData()
    }
}

extension GroupTourSearchViewController: CustomPickerViewProtocol {
    func onKeyChanged(key: String) {
        switch touchInputField {
        case .startTourDate:
            ()
        case .tourDays:
            ()
        case .regionCode:
            let keyValue = groupTourSearchInit!.regionCodeList.first{ $0.key == key }!
            groupTourSearchRequest.selectedRegionCode = keyValue
            
        case .departureCity:
            let keyValue = groupTourSearchInit!.departureCityList.first{ $0.key == key }!
            groupTourSearchRequest.selectedDepartureCity = keyValue
            
        case .airlineCode:
            let keyValue = groupTourSearchInit!.airlineCodeList.first{ $0.key == key }!
            groupTourSearchRequest.selectedAirlineCode = keyValue
            
        case .tourType:
            let keyValue = groupTourSearchInit!.tourTypeList.first{ $0.key == key }!
            groupTourSearchRequest.selectedTourType = keyValue
            
        default:
            ()
        }
        
        groupTourTableView?.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "InputCell") as! GroupTourSearchInputCell
        cell.setCellWith(groupTourSearchRequest: groupTourSearchRequest)
        cell.delegate = self
        return cell
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
    func onTourDaysTextFieldDidChange(text: String) {
        if text == "" {
            groupTourSearchRequest.tourDays = nil
        } else {
            groupTourSearchRequest.tourDays = Int(text)!
        }
        
        groupTourTableView?.reloadData()
    }
}

extension GroupTourSearchViewController {
    @IBAction func onTouchGroupTour(_ sender: UIButton){
        self.scrollToPage(scrollView: topPageScrollView, page: 0, animated: true)
    }
    
    @IBAction func onTouchKeywordOrGroupNo(_ sender: UIButton){
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
            enableButton(topPageKeywordOrGroupdNoButton, isEnable: false)
        case 1:
            enableButton(topPageGroupTourButton, isEnable: false)
            enableButton(topPageKeywordOrGroupdNoButton, isEnable: true)
        default:
            ()
        }
    }
    
    private func enableButton(_ button: UIButton, isEnable: Bool){
        switch isEnable {
        case true :
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
