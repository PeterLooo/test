//
//  CalendarSelectedYearMonthDaysString.swift
//  colatour
//
//  Created by M6853 on 2018/6/1.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit

class CalendarSelectedYearMonthDaysString : NSObject {
    var singleDayString: String?
    var startDayString: String?
    var endDayString: String?
    
    convenience init (selectedYearMonthDays: CalendarSelectedYearMonthDays) {
        self.init()

        let dateFormat = DateFormatter()
        dateFormat.setToBasic(dateFormat: "yyyy/MM/dd")
        
        var singleDateString = ""
        if let date = selectedYearMonthDays.singleDay?.date {
            singleDateString = dateFormat.string(from: date)
        }
        
        var startDateString = ""
        if let date = selectedYearMonthDays.startDay?.date {
            startDateString = dateFormat.string(from: date)
        }
        
        var endDateString = ""
        if let date = selectedYearMonthDays.endDay?.date {
            endDateString = dateFormat.string(from: date)
        }
        
        self.singleDayString = singleDateString
        self.startDayString = startDateString
        self.endDayString = endDateString
    }
    
    convenience init (startDayString: String?, endDayString: String?, singleDayString: String?) {
        self.init()

        self.singleDayString = singleDayString
        self.startDayString = startDayString
        self.endDayString = endDayString
    }
}
