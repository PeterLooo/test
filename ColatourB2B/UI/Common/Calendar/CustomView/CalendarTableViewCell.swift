//
//  CalendarTableViewCell.swift
//  colatour
//
//  Created by M6853 on 2018/5/7.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionViewYearMonthDays: UICollectionView!
    var yearMonth: YearMonth?
    weak var delegate: CalendarCollectionViewCellProtocol?
    private var isDateNoteHiddenWhenDisableDate: Bool!
    private var colorDef: CalendarColorProtocol!
    private var dateNoteAtSelectedStartEndDate: (isEnable: Bool, startNote: String?, endNote: String?)!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.collectionViewYearMonthDays.delegate = self
        self.collectionViewYearMonthDays.dataSource = self
        
        self.collectionViewYearMonthDays.register(UINib(nibName: "CalendarDayCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CalendarDayCollectionViewCell")
    }
 
    override func layoutSubviews() {
        super.layoutSubviews()

        self.collectionViewYearMonthDays.collectionViewLayout.invalidateLayout()
    }

    func setCellWithMonth(yearMonth: YearMonth
        , isDateNoteHiddenWhenDisableDate: Bool
        , colorDef: CalendarColorProtocol!
        , dateNoteAtSelectedStartEndDate: (isEnable: Bool, startNote: String?, endNote: String?))  {
        self.yearMonth = yearMonth
        self.isDateNoteHiddenWhenDisableDate = isDateNoteHiddenWhenDisableDate
        self.colorDef = colorDef
        self.dateNoteAtSelectedStartEndDate = dateNoteAtSelectedStartEndDate
        self.collectionViewYearMonthDays.reloadData()
    }
    
    var weekOfFirstDateThisMonth: Int {
        // 星期一 weekOfFirstDate = 1
        // 星期日 weekOfFirstDate = 0
        let yearMonthDateComponent = DateComponents.init(year: yearMonth?.year, month: yearMonth?.month)
        let yearMonthDate = calendar.date(from: yearMonthDateComponent)!
        
        let weekOfFirstDate = calendar.component(.weekday, from: yearMonthDate) - 1
        
        let correctSundayValue = 7
        if weekOfFirstDate == 0 { return correctSundayValue }

        return weekOfFirstDate
    }
    
}

extension CalendarTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numbersOfCollectionCellShouldAdd = weekOfFirstDateThisMonth - 1
        
        return (self.yearMonth == nil) ? 0 : self.yearMonth!.dates.count + numbersOfCollectionCellShouldAdd
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewYearMonthDays.dequeueReusableCell(withReuseIdentifier: "CalendarDayCollectionViewCell", for: indexPath) as! CalendarDayCollectionViewCell
        cell.delegate = self.delegate
        cell.accessibilityIdentifier = "CalendarDayCollectionViewCell"
        let numbersOfCollectionCellShouldAdd = weekOfFirstDateThisMonth - 1

        if (indexPath.row < (weekOfFirstDateThisMonth - 1)) {
            cell.setOrderYearMonthDay(yearMonthDay: nil,
                                      isDateNoteHiddenWhenDisableDate: isDateNoteHiddenWhenDisableDate,
                                      calendarColorType: colorDef,
                                      dateNoteAtSelectedStartEndDate: dateNoteAtSelectedStartEndDate)
            return cell
        }
        
        let indexOfYearMonthDate = indexPath.row - numbersOfCollectionCellShouldAdd
        cell.setOrderYearMonthDay(yearMonthDay: (yearMonth?.dates[indexOfYearMonthDate])!,
                                  isDateNoteHiddenWhenDisableDate: isDateNoteHiddenWhenDisableDate,
                                  calendarColorType: colorDef,
                                  dateNoteAtSelectedStartEndDate: dateNoteAtSelectedStartEndDate)

        return cell

    }
    
    override func reloadInputViews() {
        super.reloadInputViews()
        
        self.collectionViewYearMonthDays.visibleCells.forEach{ $0.reloadInputViews() }
    }
    
}

extension CalendarTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //Note : 更動時需連動 "CalendarView cell Height"  "CalendarTableViewCell sizeForItemat func Height" "CalendarDayCollectionViewCell.xib cell"
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Double(self.collectionViewYearMonthDays.frame.width / 7.0)
        let height = 50.0
        return CGSize(width: width, height: height)
    }

}
