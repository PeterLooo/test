//
//  CalendarView.swift
//  colatour
//
//  Created by M6853 on 2018/5/14.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit

class CalendarView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableViewMonths: UITableView!
    @IBOutlet weak var confirm: UIButton!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    var selectCalendarManager: SelectCalendarManagerProtocol?
    
    weak var delegate: CalendarViewControllerProtocol?
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUp()
    }
    
    private func setUp() {
        let bundle = Bundle.init(for: self.classForCoder)
        let nib = UINib.init(nibName: "CalendarView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
        tableViewMonths.delegate = self
        tableViewMonths.dataSource = self
        tableViewMonths.accessibilityIdentifier = "tableViewMonths"
        tableViewMonths.register(UINib(nibName:"CalendarTableViewCell", bundle: nil), forCellReuseIdentifier: "CalendarTableViewCell")
    }
    
    func initCalendarView(delegate: CalendarViewControllerProtocol, calendarAllAttribute: CalendarAllAttribute){
        self.delegate = delegate
        
        initSelectCalendarController(calendarAllAttribute: calendarAllAttribute)
        initConfirmButtonType()
        self.tableViewMonths.reloadData()
        scrollToAlreadySelectedDate()
    }
    
    func scrollToAlreadySelectedDate() {
        var scrollToDate: Date?
        
        if let singleDate = selectCalendarManager?.selectedYearMonthDays?.singleDay?.date {
            scrollToDate = singleDate
            setConfirmEnableWithSingleType()
            
        }else if let startDate = selectCalendarManager?.selectedYearMonthDays?.startDay?.date {
            scrollToDate = startDate
            setConfirmEnableWithMutipleType()
        }
        
        if (scrollToDate == nil) { return }
        
        let year = calendar.component(.year, from: scrollToDate!)
        let month = calendar.component(.month, from: scrollToDate!)
        
        let scrollToDateTableIndex = self.selectCalendarManager?.orderCalendar?.yearMonths.index(where: {$0.year == year && $0.month == month})
        
        let originY = self.tableViewMonths.rectForRow(at: IndexPath(row: 0, section: scrollToDateTableIndex!)).origin.y - self.tableViewMonths.sectionHeaderHeight
        self.tableViewMonths.contentOffset.y = originY
        
    }
    
    private func initSelectCalendarController(calendarAllAttribute: CalendarAllAttribute) {
        self.selectCalendarManager = SelectCalendarManager(delegate: self, calendarAllAttribute: calendarAllAttribute)
    }
    
    private func initConfirmButtonType() {
        confirm.titleLabel?.numberOfLines = 0
        confirm.titleLabel?.textAlignment = .center
        confirm.setBorder(width: 0.1, radius: 4, color: UIColor.lightGray)
        confirm.setShadow(offset: CGSize(width: 0, height: 2), opacity: 0.2, shadowRadius: 2)
        confirm.accessibilityIdentifier = "日期確認"
        switch (self.selectCalendarManager?.calendarType?.singleOrMutiple)! {
        case .single:
            self.confirm.setTitle("\n", for: .normal)
        case .mutiple:
            self.confirm.setTitle("\n\n\n", for: .normal)
        }
        
        self.confirm.isHidden = (self.selectCalendarManager?.calendarType?.isConfirmButtonHidden)!
    }
}

extension CalendarView : CalendarViewProtocol {
    
    func onDoNothing() {
        ()
    }
    
    func onDenyUserTapDate() {
        showDenyAlert()
    }
    
    func onChangeSingleDate() {
        setConfirmEnableWithSingleType()
    }
    
    func onDeselectSingleDate() {
        setConfirmUnableWithHidden()
    }
    
    func onChangeStartDate() {
        setConfirmUnableWithHidden()
    }
    
    func onChangeEndDate() {
        setConfirmEnableWithMutipleType()
    }
    
    func onChangeBothStartEndDate() {
        setConfirmEnableWithMutipleType()
    }
    
    func onChangeStartDateResetEndDate() {
        setConfirmUnableWithHidden()
    }
    
    func onChangeEndDateWhenEqualStartDate() {
        setConfirmEnableWithMutipleType()
    }
    
    private func setConfirmEnableWithSingleType() {
        let singleDate = (selectCalendarManager?
            .selectedYearMonthDays?.singleDay?.date)!
        
        let singleDateComponent = calendar.dateComponents([.timeZone, .year, .month, .day], from: singleDate)
        
        self.confirm.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        self.confirm.setTitle("點此確定日期\n\(singleDateComponent.year!) 年 \(singleDateComponent.month!) 月 \(singleDateComponent.day!) 日", for: .normal)
        
        UIView.animate(withDuration: 0.2) {
            self.confirm.alpha = 1
            //要讓tableView可以完全看到，不被確認按鈕遮住，所以有按鈕的時候，constant等於按鈕高度 + 12
            self.tableViewBottomConstraint.constant = self.confirm.frame.height + 12
            self.layoutIfNeeded()
        }
        
    }
    
    private func setConfirmEnableWithMutipleType () {
        let startDate = (selectCalendarManager?.selectedYearMonthDays?.startDay?.date)!
        let endDate = (selectCalendarManager?.selectedYearMonthDays?.endDay?.date)!
        
        let startDateComponent = calendar.dateComponents([.timeZone, .year, .month, .day], from: startDate)
        let endDateComponent = calendar.dateComponents([.timeZone, .year, .month, .day], from: endDate)
        
        let showDayOrNight = selectCalendarManager?.calendarType?.confirmTextShowDayOrNight
        
        let isStartDayEqualEndDay = (startDate.compare(endDate) == .orderedSame) ? true : false
        let numberOfStartDayAndEndDay = isStartDayEqualEndDay ? 1 : 2
        let selectedNumberOfDays = (selectCalendarManager?.selectedYearMonthDays?.middleDays.count)! + numberOfStartDayAndEndDay
        let isDaysLimited = selectCalendarManager!.calendarType!.maxLimitedDays!.isLimited
        let maxLimitedDays = selectCalendarManager!.calendarType!.maxLimitedDays!.maxDays

        let buttonTitle = getConfirmButtonTitle(startDateComponent: startDateComponent,
                                                endDateComponent: endDateComponent,
                                                showDayOrNight: showDayOrNight!,
                                                selectedDaysCount: selectedNumberOfDays,
                                                isDaysCountLimited: isDaysLimited,
                                                maxLimitedDays: maxLimitedDays
                                                )
        
        UIView.setAnimationsEnabled(false)
        self.confirm.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.confirm.setTitle(buttonTitle, for: .normal)
        enableConfirmButton(showDayOrNight: showDayOrNight!,
                            selectedDaysCount: selectedNumberOfDays,
                            maxLimitedDays: maxLimitedDays)
        self.confirm.layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
        
        UIView.animate(withDuration: 0.2) {
            self.confirm.alpha = 1
            //要讓tableView可以完全看到，不被確認按鈕遮住，所以有按鈕的時候，constant等於按鈕高度 + 12
            self.tableViewBottomConstraint.constant = self.confirm.frame.height + 12
            self.layoutIfNeeded()
        }
    }
    
    private func getConfirmButtonTitle(startDateComponent: DateComponents,
                                       endDateComponent: DateComponents,
                                       showDayOrNight: CalendarConfirmTextType,
                                       selectedDaysCount: Int,
                                       isDaysCountLimited: Bool,
                                       maxLimitedDays: Int?) -> String
    {
        let tapToConfirmTitle = "點此確定日期"
        let startToEndTitle = "\(startDateComponent.month!) 月 \(startDateComponent.day!) 日 -  \(endDateComponent.month!) 月 \(endDateComponent.day!) 日"
        let sumOfDaysTitle = showDayOrNight.getNumberOfDaysTitle(days: selectedDaysCount)
        
        if isDaysCountLimited == false {
            return "\(tapToConfirmTitle)\n\(startToEndTitle) "
        }
        
        let isOutOfBounds = showDayOrNight.isOutOfBounds(selectedDays: selectedDaysCount, maxDays: maxLimitedDays)
        
        switch isOutOfBounds {
        case true:
            let limitedDaysTitle = showDayOrNight.getLimitedDaysTitle(maxDays: maxLimitedDays!)
            return "\(limitedDaysTitle)\n\(startToEndTitle) \(sumOfDaysTitle)"
        case false:
            return "\(tapToConfirmTitle)\n\(startToEndTitle) \(sumOfDaysTitle)"
        }
    }
    
    private func enableConfirmButton(showDayOrNight: CalendarConfirmTextType,
                                     selectedDaysCount: Int,
                                     maxLimitedDays: Int?){
        let isOutOfBounds = showDayOrNight.isOutOfBounds(selectedDays: selectedDaysCount, maxDays: maxLimitedDays)
        switch isOutOfBounds {
        case true:
            self.confirm.backgroundColor = ColorHexUtil.hexColor(hex: "#b4b4b4")
            self.confirm.isEnabled = false
        case false:
            self.confirm.backgroundColor = UIColor.init(named: "通用綠")
            self.confirm.isEnabled = true
        }
    }
    
    private func setConfirmUnableWithHidden(){
        UIView.animate(withDuration: 0.2) {
            self.confirm.alpha = 0
            //要讓tableView底下不會多出空白，所以沒有按鈕的時候，constant等於 0
            self.tableViewBottomConstraint.constant = 0
            self.layoutIfNeeded()
        }
        
        UIView.setAnimationsEnabled(false)
        switch self.selectCalendarManager?.calendarType?.singleOrMutiple ?? .single {
        case .single:
            self.confirm.setTitle("\n", for: .normal)
        case .mutiple:
            self.confirm.setTitle("\n", for: .normal)
        }
        layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
    }
    
    private func showDenyAlert(){
        let alertSeverError:UIAlertController = UIAlertController(title: "不適用日期", message: "選擇範圍中含有不適用日期", preferredStyle: .alert)
        let action = UIAlertAction(title: "再選一次", style: UIAlertAction.Style.default, handler: nil)
        alertSeverError.addAction(action)
        //editing
        UIApplication.shared.keyWindow?.rootViewController?.present(alertSeverError, animated: true)
    }
    
    @IBAction func onTouchConfirm(_ sender: UIButton) {
        self.delegate?.onTouchConfirm(selectedYearMonthDays: (selectCalendarManager?.selectedYearMonthDays)!)
    }
}

extension CalendarView: CalendarCollectionViewCellProtocol {
    
    func onTouchDay(selectOrderYearMonthDay: YearMonthDay) {
        self.selectCalendarManager!.tapDate(selectOrderYearMonthDay: selectOrderYearMonthDay)
        
        self.tableViewMonths.visibleCells.forEach{ $0.reloadInputViews() }
    }
    
    func weekOfFirstDateThisMonth(yearMonth: YearMonth) -> Int {
        // 星期一 weekOfFirstDate = 1 回傳 1
        // 星期日 weekOfFirstDate = 0 回傳 7
        let yearMonthDateComponent = DateComponents(year: yearMonth.year, month: yearMonth.month)
        let yearMonthDate = calendar.date(from: yearMonthDateComponent)!
        
        let weekOfFirstDate = calendar.component(.weekday, from: yearMonthDate) - 1
        
        let correctSundayValue = 7
        if weekOfFirstDate == 0 { return correctSundayValue }
        
        return weekOfFirstDate
    }
}

extension CalendarView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let lastSection = self.selectCalendarManager?.orderCalendar?.yearMonths.count
        
        if (indexPath.section == lastSection) {
            return self.confirm.frame.height + 30
        }
        
        if (self.selectCalendarManager?.orderCalendar?.yearMonths == nil) {
            return 50
        }
        
        //editing
        let addCount = weekOfFirstDateThisMonth(yearMonth: (self.selectCalendarManager?.orderCalendar?.yearMonths[indexPath.section])!) - 1
        let collectionItemCount = (self.selectCalendarManager?.orderCalendar?.yearMonths[indexPath.section])!.dates.count + addCount
        //Note : 更動時需連動 CalendarTableViewCell.xib 上下數字
        let cellTopAndBottomSpace: CGFloat = 12.0
        
        //Note : 更動時需連動 "CalendarView cell Height"  "CalendarTableViewCell sizeForItemat func Height" "CalendarDayCollectionViewCell.xib cell"
        switch true {
        case collectionItemCount <= 28:
            return 50 * 4 + cellTopAndBottomSpace
        case collectionItemCount > 28 && collectionItemCount <= 35:
            return 50 * 5 + cellTopAndBottomSpace
        case collectionItemCount > 35:
            return 50 * 6 + cellTopAndBottomSpace
        default:
            return 50 + cellTopAndBottomSpace
        }
    }
    
}

extension CalendarView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let yearMonths = self.selectCalendarManager?.orderCalendar?.yearMonths
        return ((yearMonths?.count) ?? 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let yearMonths = self.selectCalendarManager?.orderCalendar?.yearMonths
        
        let cell = tableViewMonths.dequeueReusableCell(withIdentifier: "CalendarTableViewCell") as! CalendarTableViewCell
        cell.setCellWithMonth(yearMonth: (yearMonths![indexPath.section]),
                              isDateNoteHiddenWhenDisableDate: selectCalendarManager!.calendarType!.isDateNoteHiddenWhenDisableDate!,
                              colorDef: selectCalendarManager!.calendarType!.colorDef!,
                              dateNoteAtSelectedStartEndDate: selectCalendarManager!.calendarType!.dateNoteAtSelectedStartEndDate!)
        cell.accessibilityIdentifier = "CalendarTableViewCell"
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let yearMonths = self.selectCalendarManager?.orderCalendar?.yearMonths
        
        if section == (yearMonths?.count) ?? 0 {
            return ""
        }
        
        let addMonthValue = section
        let thisMonth = calendar.date(byAdding: .month, value: addMonthValue, to: ( self.selectCalendarManager?.calendarDateAttribute?.startDate)!)
        
        let thisMonthYear = calendar.component(.year, from: thisMonth!)
        let thisMonthMonth = calendar.component(.month, from: thisMonth!)
        
        return "\(thisMonthYear)年 \(thisMonthMonth)月"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        
        header.textLabel?.font = UIFont(name: "PingFangTC-Medium", size: 18)
        header.textLabel?.textColor = ColorHexUtil.hexColor(hex: "#979797")
        header.textLabel?.textAlignment = NSTextAlignment.center
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
}
