//
//  CalendarSelectedYearMonthDays.swift
//  colatour
//
//  Created by M6853 on 2018/5/10.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit

class CalendarSelectedYearMonthDays : NSObject {
    var singleDay: YearMonthDay?
    var startDay: YearMonthDay?
    var endDay: YearMonthDay?
    var middleDays: [YearMonthDay] = []
    
    convenience init (selectedSingleDate: YearMonthDay?, selectedStartDate: YearMonthDay?, selectedEndDate: YearMonthDay?, selectedMiddleDates: [YearMonthDay]?) {
        self.init()
        
        self.singleDay = selectedSingleDate
        self.startDay = selectedStartDate
        self.endDay = selectedEndDate
        self.middleDays = selectedMiddleDates ?? []
    }
}
