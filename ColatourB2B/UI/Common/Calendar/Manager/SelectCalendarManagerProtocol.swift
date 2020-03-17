//
//  SelectCalendarControllerProtocol.swift
//  colatour
//
//  Created by M6853 on 2018/5/10.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit

protocol SelectCalendarManagerProtocol {
    var calendarDateAttribute: CalendarDateAttribute? {get}
    var calendarType: CalendarType? {get}
    var orderCalendar: CustomCalendar? {get}
    var selectedYearMonthDays: CalendarSelectedYearMonthDays? {get}
    
    func tapDate(selectOrderYearMonthDay: YearMonthDay)
}
