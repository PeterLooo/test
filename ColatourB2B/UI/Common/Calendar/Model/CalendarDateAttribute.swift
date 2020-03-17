//
//  CalendarDateAttribute.swift
//  colatour
//
//  Created by M6853 on 2018/5/10.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit
import ObjectMapper

class CalendarDateAttribute: BaseModel {
    var startDate: Date?
    var endDate: Date?
    var limitDates: [Date] = []
    var limitDaysOfWeek: [DayOfTheWeek] = []
    var dateMemo: [Date:String] = [:]
    
    convenience init (startDate: Date, endDate: Date, limitDates: [Date], limitWeekdays: [DayOfTheWeek], dateMemo: [Date:String]) {
        self.init()
        
        self.startDate = startDate
        self.endDate = endDate
        self.limitDates = limitDates
        self.limitDaysOfWeek = limitWeekdays
        self.dateMemo = dateMemo
    }
}
