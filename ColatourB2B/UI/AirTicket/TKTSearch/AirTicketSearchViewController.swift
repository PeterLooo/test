//
//  AirTicketSearchViewController.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2020/3/9.
//  Copyright © 2020 Colatour. All rights reserved.
//
import UIKit

extension AirTicketSearchViewController {
    func setVC(viewModel: AirTicketSearchViewModel) {
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
    
    @objc private func onTouchPickerViewDone() {
        pickerView.pickerView(pickerView, didSelectRow: pickerView.selectedRow(inComponent: 0), inComponent: 0)
        viewModel?.touchInputField = nil
    }
    
    @objc private func onTouchDatePickerDone() {
        datePickerChanged(picker: datePicker)
        viewModel?.touchInputField = nil
    }
    
    @objc private func datePickerChanged(picker: UIDatePicker) {
        
        viewModel?.datePickerChanged(date: picker.date )
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
        
        viewModel?.touchInputField = nil
        if scrollView != self.topPageScrollView { return }
        let wholeWidth = scrollView.contentSize.width
        let nowOffsetX = scrollView.contentOffset.x
        let percent = nowOffsetX / (wholeWidth / 3.0)
        scrollTopPageButtonBottomLine(percent: percent)
    }
}

extension AirTicketSearchViewController: CustomPickerViewProtocol {
    
    func onKeyChanged(key: String) {
        
        viewModel?.onKeyChanged(key: key)
    }
}

extension AirTicketSearchViewController: CalendarDataDestinationViewControllerProtocol {
    
    func setSelectedDate(selectedYearMonthDaysToString: CalendarSelectedYearMonthDaysString) {
        
        viewModel?.setSelectedDate(selectedYearMonthDaysToString: selectedYearMonthDaysToString)
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
        
        viewModel?.bindSearchUrlResult = { [weak self]  result  in
            self?.handleLinkType(linkType: result.linkType!, linkValue: result.linkValue, linkText: nil)
        }
        
        viewModel?.onTouchLccDeparture = { [weak self] in
            self?.setChooseLocationViewController(tktSearchInit: nil, lccSearchInit: self?.viewModel!.lccSearchInit, searchType: .lcc, startEndType: .Departure, arrival: nil)
        }
        
        viewModel?.onTouchLccDestination = { [weak self] in
            self?.setChooseLocationViewController(tktSearchInit: nil, lccSearchInit: self?.viewModel!.lccSearchInit, searchType: .lcc, startEndType: .Destination, arrival: nil)
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
        
        viewModel?.setDatePicker = { [weak self] date, searchType in
            
            switch searchType {
            case "airTkt" :
                self?.datePicker.date = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: date) ?? Date()
                self?.datePicker.minimumDate = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: date) ?? Date()
                self?.datePicker.maximumDate = calendar.date(byAdding: .month, value: 18, to: self?.datePicker.minimumDate! ?? Date())
            case "soto" :
                self?.datePicker.date = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: date) ?? Date()
            default:
                ()
            }
        }
        
        viewModel?.setPickerView = { [weak self] in
            
            let textAlign: NSTextAlignment = .center
            self?.pickerView.setOptionList(optionList: self?.viewModel?.shareOptionList ?? [])
            self?.pickerView.textAlign = textAlign
            self?.pickerView.reloadAllComponents()
            if let selectedKey = self?.viewModel?.selectedKey {
                let _ = self?.pickerView.setDefaultKey(key: selectedKey)
            }
        }
        
        viewModel?.presentDatePicker = { [weak self] isDatePickerViewShow in
            let constant = isDatePickerViewShow ? -(self?.datePicker.frame.height ?? 0) - (self?.toolBarOnDatePicker.frame.height ?? 0) : 0
            if self?.datePickerTop != nil {
                self?.datePickerTop.constant = constant
            }
            
            UIView.animate(withDuration: 0.3) {
                self?.view.layoutIfNeeded()
            }
        }
        
        viewModel?.presentPickerView = { [weak self] isPickerViewShow in
            let constant = isPickerViewShow ? -(self?.pickerView.frame.height ?? 0) - (self?.toolBarOnPickerView.frame.height ?? 0) : 0
            if self?.pickerViewTop != nil {
                self?.pickerViewTop.constant = constant
            }
            
            UIView.animate(withDuration: 0.3) {
                self?.view.layoutIfNeeded()
            }
        }
        
        viewModel?.setAlertSeverError = { [weak self] alertSeverError, action in
            alertSeverError.addAction(action)
            self?.present(alertSeverError, animated: true)
        }
        
        viewModel?.presentCalendarForTicketViewController = { [weak self] calendarAllAttribute in
            
            let vc = self?.getVC(st: "Calendar", vc: "CalendarForTicketViewController") as! CalendarForTicketViewController
            vc.setVCwith(delegate: self, calendarAllAttribute: calendarAllAttribute)
            vc.setVCNavBarItem(navMode: .present, navTitle: "選擇日期")
            vc.setIsPageSheetPresenting(isPresentVC: true)
            
            let nav = UINavigationController(rootViewController: vc)
            nav.restorationIdentifier = "HotelCalendarNivagationController"
            
            self?.present(nav, animated: true, completion: nil)
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
    
    private func layoutPickerView() {
        
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
    
    private func layoutDatePicker() {
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
