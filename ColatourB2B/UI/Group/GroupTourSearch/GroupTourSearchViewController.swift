//
//  GroupTourViewController.swift
//  ColatourB2B
//
//  Created by M6853 on 2020/1/13.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

extension GroupTourSearchViewController {

    func setViewModle(viewModel: GroupTourSearchViewModel) {
        self.viewModel = viewModel
    }
}

class GroupTourSearchViewController: BaseViewControllerMVVM {
    @IBOutlet weak var topPageScrollView: UIScrollView!
    @IBOutlet weak var topPageButtonView: UIView!
    @IBOutlet weak var topPageGroupTourButton: UIButton!
    @IBOutlet weak var topPageKeywordOrTourCodeButton: UIButton!
    @IBOutlet weak var pageButtonBottomLineLeading: NSLayoutConstraint!
    @IBOutlet weak var groupTourPageView: UIView!
    @IBOutlet weak var keywrodOrTourCodePageView: UIView!
    
    @IBOutlet weak var groupTourTableView: UITableView!
    @IBOutlet weak var keywordOrTourCodeTableView: UITableView!
    
    private var viewModel: GroupTourSearchViewModel?
    
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
        viewModel?.setInputFieldType(inputFieldType: nil)
    }
    
    @objc private func datePickerChanged(picker: UIDatePicker) {
        viewModel?.groupTourSearchRequest.startTourDate = FormatUtil.convertDateToString(dateFormatTo: "yyyy/MM/dd", date: picker.date)
        
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
        
        viewModel?.setInputFieldType(inputFieldType: nil)
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
        
        if #available(iOS 14.0, *) {
            datePicker.isHidden = true
            datePicker.preferredDatePickerStyle = .wheels
        }else{
            datePicker.isHidden = false
            datePicker.backgroundColor = UIColor.white
            datePicker.sizeToFit()
        }
        
        setUpTopPageScrollView()
        layoutPickerView()
        layoutDatePicker()
        
        bindViewModel()
        loadData()
        
    }
    
    private func setUpTopPageScrollView(){
        self.topPageScrollView.delegate = self
        scrollTopPageButtonBottomLine(percent: 0)
        switchPageButton(toPage: 0)
    }
    
    override func loadData() {
        super.loadData()
        
        getTourSearchInit()
    }
    
    func bindViewModel(){
        self.bindToBaseViewModel(viewModel: self.viewModel!)
        
        viewModel?.endEditing = {[weak self] in
            self?.view.endEditing(true)
        }
        
        viewModel?.presentPickerView = {[weak self] isPickerViewShow in
            let constant = isPickerViewShow ? -(self?.pickerView.frame.height)! - (self?.toolBarOnPickerView.frame.height)! : 0
            self?.pickerViewTop.constant = constant

            UIView.animate(withDuration: 0.3) {
                self?.view.layoutIfNeeded()
            }
        }
        
        viewModel?.presentDatePicker = {[weak self] isDatePickerViewShow in
            let constant = isDatePickerViewShow ? -(self?.datePicker.frame.height)! - (self?.toolBarOnDatePicker.frame.height)! : 0
            self?.datePickerTop.constant = constant

            UIView.animate(withDuration: 0.3) {
                self?.view.layoutIfNeeded()
            }
        }
        
        viewModel?.updatePickerView = { [weak self] list, textAlign, selectedKey in
            self?.pickerView.setOptionList(optionList: list)
            self?.pickerView.textAlign = textAlign
            
            if let key = selectedKey {
                _ = self?.pickerView.setDefaultKey(key: key)
            }
        }
        
        viewModel?.reloadTableView = { [weak self] in
            self?.groupTourTableView?.reloadData()
            self?.keywordOrTourCodeTableView?.reloadData()
        }
    }
    
    private func getTourSearchInit(){
        viewModel?.getGroupTourSearchInit()
    }
    
    @IBAction func onTouchStartTourDateView(_ sender: UIButton) {
        viewModel?.setInputFieldType(inputFieldType: .startTourDate)
    }
    
    @IBAction func onTouchRegionCodeView(_ sender: UIButton) {
        viewModel?.setInputFieldType(inputFieldType: .regionCode)
    }
    
    @IBAction func onTouchDepartureCityView(_ sender: UIButton) {
        viewModel?.setInputFieldType(inputFieldType: .departureCity)
    }
    
    @IBAction func onTouchAirlineCodeView(_ sender: UIButton) {
        viewModel?.setInputFieldType(inputFieldType: .airlineCode)
    }
    
    @IBAction func onTouchTourTypeView(_ sender: UIButton) {
        viewModel?.setInputFieldType(inputFieldType: .tourType)
    }
    
    @IBAction func onTouchPriceLimit(_ sender: UIButton) {
        viewModel?.groupTourSearchRequest.isPriceLimit = !(viewModel?.groupTourSearchRequest.isPriceLimit)!
        
        viewModel?.setInputFieldType(inputFieldType: nil)
        
        groupTourTableView?.reloadData()
    }
    
    @IBAction func onTouchBookingTourView(_ sender: UIButton) {
        viewModel?.groupTourSearchRequest.isBookingTour = !(viewModel?.groupTourSearchRequest.isBookingTour)!
        
        viewModel?.setInputFieldType(inputFieldType: nil)
        
        groupTourTableView?.reloadData()
    }
    
    @IBAction func onTouchGroupTourSearchButton(_ sender: UIButton) {
        viewModel?.getTourSearchUrl(searchByType: .groupTour, cell: self.groupTourTableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! GroupTourSearchInputCell)
    }
    
    @IBAction func onTouchSearchByKeywordButton(_ sender: UIButton) {
        viewModel?.groupTourSearchKeywordAndTourCodeRequest.keywordOrTourCodeSearchType = .keyword
        
        viewModel?.getTourSearchUrl(searchByType: .keyword, cell: self.groupTourTableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! GroupTourSearchInputCell)
    }
    
    @IBAction func onTouchSearchByTourCodeButton(_ sender: UIButton) {
        viewModel?.groupTourSearchKeywordAndTourCodeRequest.keywordOrTourCodeSearchType = .tourCode
        
        viewModel?.getTourSearchUrl(searchByType: .tourCode, cell: self.groupTourTableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! GroupTourSearchInputCell)
    }
    
    @IBAction func onTouchKeywordAndTourCodeDepartureCityView(_ sender: UIButton) {
        viewModel?.setInputFieldType(inputFieldType: .keywordOrTourCodeDepartureCity)
    }
    
    @IBAction func onTouchInputDescription(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let vc = getVC(st: "PopText", vc: "PopTextViewController") as! PopTextViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        
        let inputDescription = "若需同時查詢多組關鍵字，且\n（１）希望搜尋結果『同時』包含這些關鍵字，請使用『空格』或『,』\n※例如：『迪士尼螃蟹』或『迪士尼,螃蟹』\n（２）希望搜尋結果『至少』包含其中一組關鍵字，請使用『/』\n※例如：『賞楓/泡湯』，則搜尋結果至少包含『賞楓』或『泡湯』其中一項"
        vc.setTextWith(text: inputDescription,
                       navTitle: "輸入說明",
                       bottomButtonTitle: "關閉")
        present(vc, animated: true)
    }
}

extension GroupTourSearchViewController: PopTextViewControllerProtocol {
    func onTouchBottomButton() {
        ()
    }
}

extension GroupTourSearchViewController: CustomPickerViewProtocol {
    func onKeyChanged(key: String) {
        viewModel?.onKeyChanged(key: key)
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
            cell.setCellWith(groupTourSearchRequest: viewModel!.groupTourSearchRequest)
            
            return cell
        case keywordOrTourCodeTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputCell") as! GroupTourSearchKeywordAndTourCodeInputCell
            cell.setCellWith(groupTourSearchKeywordAndTourCodeRequest: viewModel!.groupTourSearchKeywordAndTourCodeRequest)
            
            return cell
        default:
            return UITableViewCell()
        }
    }
}

//MARK: scroll top page 左邊滑到右邊，右邊滑到左邊
extension GroupTourSearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel?.setInputFieldType(inputFieldType: nil)
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
