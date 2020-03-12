//
//  OrderYearMonth.swift
//  colatour
//
//  Created by AppDemo on 2018/1/10.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit

class YearMonth: NSObject {
    var year: Int?
    var month: Int?
    var dates: [YearMonthDay] = []
    
    init(yearMonthComponent: DateComponents, calendarDateAttribute: CalendarDateAttribute, calendarType: CalendarType, calendarSelectedDates: CalendarSelectedDates, selectedYearMonthDays: CalendarSelectedYearMonthDays) {
        
        let limitDates = calendarDateAttribute.limitDates
        let limitDaysOfWeek = calendarDateAttribute.limitDaysOfWeek
        let startDate = calendarDateAttribute.startDate!
        let endDate = calendarDateAttribute.endDate!
        
        self.year = yearMonthComponent.year
        self.month = yearMonthComponent.month
        
        var date = calendar.date(from: yearMonthComponent)!
        
        while(calendar.component(.month, from: date) == self.month){
            
            //不可選日期 isCanChoose = false
            var isCanChoose = true
            
            //Note: 此處取得的Int，星期一到星期日(2,3,4,5,6,7,1)
            let dayOfWeekInt: Int = calendar.component(.weekday, from: date)
            let dayOfWeek: DayOfTheWeek = DayOfTheWeek(rawValue: String(dayOfWeekInt))!
            
            if limitDaysOfWeek.contains(dayOfWeek) {
                isCanChoose = false
            }
            
            //開始月份中 小於 開始日 的 isCanChoose = false
            //結束月份中 大於 結束日 的 isCanChoose = false
            if isCanChoose == true && (date < startDate || date > endDate) {
                isCanChoose = false
            }
            
            //過了今天 今天之前的日期 的 isCanChoose = false
            if isCanChoose == true && (calendarType.isBeforeTodayLimitSelect == true) {
                let today = Date()
                let isBeforeToday = calendar.compare(date, to: today, toGranularity: .day) == .orderedAscending
                if isBeforeToday {
                    isCanChoose = false
                }
            }
            
            let isLimitDate = limitDates.first(where: { $0.compare(date) == .orderedSame }) != nil
            if isLimitDate {
                isCanChoose = false
            }
            
            #warning("可多選的時候，如果預設日帶入日期，最後判斷為不可以選日，還是會帶入，不應該要帶入，所以要在解決bug")
            if isCanChoose == false {
                if date == calendarSelectedDates.singleDate{
                    calendarSelectedDates.singleDate = nil
                }
            }
            
            //日期選取狀態 - 選取單日、開始日、結束日、中間日、沒有被選取日
            var selectStatus: CalenderSelectStatus?
            
            switch true {
            case date == calendarSelectedDates.singleDate && date == calendarSelectedDates.endDate:
                selectStatus = .isSelectedForStartDateAndEndDate
            case date == calendarSelectedDates.singleDate:
                selectStatus = .isSelectedForSingleDate
            case date == calendarSelectedDates.startDate:
                selectStatus = .isSelectedForStartDate
            case date == calendarSelectedDates.endDate:
                selectStatus = .isSelectedForEndDate
            case date > calendarSelectedDates.startDate ?? Date() && date < calendarSelectedDates.endDate ?? Date() :
                selectStatus = .isSelectedForMiddleDate
            default:
                selectStatus = .isNotSelect
            }
            
            //日期備註
            let note = calendarDateAttribute.dateMemo.first(where: {
                calendar.compare($0.key, to: date, toGranularity: .day) == .orderedSame
            })?.value ?? ""
            
            let yearMonthDay = YearMonthDay(date: date, isCanChoose: isCanChoose, selectStatus: selectStatus!, note: note)
            
            //editing
            //選取單日、開始日、結束日、中間日、沒有被選取日放入self.selectedYearMonthDays
            switch yearMonthDay.selectStatus {
            case .isSelectedForSingleDate:
                selectedYearMonthDays.singleDay = yearMonthDay
            case .isSelectedForStartDate:
                selectedYearMonthDays.startDay = yearMonthDay
            case .isSelectedForEndDate:
                selectedYearMonthDays.endDay = yearMonthDay
            case .isSelectedForStartDateAndEndDate:
                selectedYearMonthDays.startDay = yearMonthDay
                selectedYearMonthDays.endDay = yearMonthDay
            case .isSelectedForMiddleDate:
                selectedYearMonthDays.middleDays.append(yearMonthDay)
            case .isNotSelect:
                ()
            }
            
            self.dates.append(yearMonthDay)
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
    }
}

