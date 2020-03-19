//
//  CustomCalendar.swift
//  colatour
//
//  Created by AppDemo on 2018/1/10.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit

class CustomCalendar: NSObject {
    var yearMonths: [YearMonth] = []
    var selectedYearMonthDays = CalendarSelectedYearMonthDays()
    
    var calendarDateAttribute: CalendarDateAttribute?
    var calendarType: CalendarType?
    
    required init (calendarAllAttribute: CalendarAllAttribute) {
        super.init()
        
        self.calendarDateAttribute = (calendarAllAttribute.calendarDateAttribute)!
        self.calendarType = (calendarAllAttribute.calendarType)!
        let calendarSelectedDates = calendarAllAttribute.calendarSelectedDates
        
        let startMonthComponent = calendar.dateComponents([.timeZone, .year, .month], from: (calendarDateAttribute?.startDate)!)
        let endMonthComponent = calendar.dateComponents([.timeZone, .year, .month], from: (calendarDateAttribute?.endDate)!)
        
        //生成yearMonths，包含適用日期開始日和結束日
        var flag = startMonthComponent
        
        while(flag != endMonthComponent.nextMonth) {
            
            let flagYearMonth = YearMonth(yearMonthComponent: flag, calendarDateAttribute: calendarDateAttribute!, calendarType: calendarType!, calendarSelectedDates: calendarSelectedDates!, selectedYearMonthDays: selectedYearMonthDays)
            
            self.yearMonths.append(flagYearMonth)
            
            flag = flag.nextMonth
        }
        
    }
    
    //可以放日期nil，也可以找不到資料，都會回傳nil
    func getYearMonthDay(date: Date?) -> YearMonthDay? {
        
        if (date == nil){ return nil }
        
        let year = calendar.component(.year, from: date!)
        let month = calendar.component(.month, from: date!)
        
        if let yearMonthIndex = self.yearMonths.index(where: {$0.year == year && $0.month == month}) {
            if let dayIndex = yearMonths[yearMonthIndex].dates.index(where: {calendar.compare($0.date!, to: date!, toGranularity: .day) == .orderedSame}) {
                return self.yearMonths[yearMonthIndex].dates[dayIndex]
            }
        }
        
        return nil
    }
    
    //可以放日期nil，也可以找不到資料，都會回傳[]
    func getYearMonthDays(startDate: Date?, endDate: Date?, isIncludeStartAndEnd: Bool) -> [YearMonthDay] {
        var yearMonthDays: [YearMonthDay] = []
        
        if(startDate == nil || endDate == nil ){
            return []
        }
        
        let startYear = calendar.component(.year, from: startDate!)
        let startMonth = calendar.component(.month, from: startDate!)
        
        let endYear = calendar.component(.year, from: endDate!)
        let endMonth = calendar.component(.month, from: endDate!)
        
        var startYearMonthIndex: Int?
        var endYearMonthIndex: Int?
        
        if let yearMonthIndex = self.yearMonths.index(where: {$0.year == startYear && $0.month == startMonth}) {
            startYearMonthIndex = yearMonthIndex
        }
        
        if let yearMonthIndex = self.yearMonths.index(where: {$0.year == endYear && $0.month == endMonth}) {
            endYearMonthIndex = yearMonthIndex
        }
        
        self.yearMonths[startYearMonthIndex!...endYearMonthIndex!].forEach{
            $0.dates.forEach{
                if (isIncludeStartAndEnd == true ) {
                    let isEqualStartDate = calendar.compare(startDate!, to: $0.date!, toGranularity: .day) == .orderedSame
                    let isEqualEndDate = calendar.compare(endDate!, to: $0.date!, toGranularity: .day) == .orderedSame
                    
                    if (isEqualStartDate || isEqualEndDate) {
                        yearMonthDays.append($0)
                    }
                }
                
                let isAfterStartDate = calendar.compare(startDate!, to: $0.date!, toGranularity: .day) == .orderedAscending
                let isBeforeEndDate =  calendar.compare($0.date!, to: endDate!, toGranularity: .day) == .orderedAscending
                
                if (isAfterStartDate && isBeforeEndDate) {
                    yearMonthDays.append($0)
                }
            }
        }
        
        return yearMonthDays
    }
}
