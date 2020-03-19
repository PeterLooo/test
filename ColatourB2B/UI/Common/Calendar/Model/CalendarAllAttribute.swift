//
//  CalendarAllAttribure.swift
//  colatour
//
//  Created by M6853 on 2018/6/1.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit

public class CalendarAllAttribute : NSObject {
    var calendarDateAttribute: CalendarDateAttribute?
    var calendarType: CalendarType?
    var calendarSelectedDates: CalendarSelectedDates?
    
    convenience init(calendarDateAttribute: CalendarDateAttribute, calendarType: CalendarType, calendarSelectedDates: CalendarSelectedDates) {
        self.init()
        
        self.calendarDateAttribute = calendarDateAttribute
        self.calendarType = calendarType
        self.calendarSelectedDates = calendarSelectedDates
    }
}
