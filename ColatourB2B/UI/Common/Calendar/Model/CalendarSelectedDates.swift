   //
//  CalendarSelectedDates.swift
//  colatour
//
//  Created by M6853 on 2018/5/10.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit

class CalendarSelectedDates : NSObject {
    var singleDate: Date?
    var startDate: Date?
    var endDate: Date?
    
    convenience init (selectedSingleDate: Date?, selectedStartDate: Date?, selectedEndDate: Date?) {
        self.init()
        
        self.singleDate = selectedSingleDate
        self.startDate = selectedStartDate
        self.endDate = selectedEndDate
    }
    
    public static func ==(lhs: CalendarSelectedDates, rhs: CalendarSelectedDates) -> Bool {
        return customIsEqual(lhs: lhs, rhs: rhs)
    }
    
    public static func !=(lhs: CalendarSelectedDates, rhs: CalendarSelectedDates) -> Bool {
        return !customIsEqual(lhs: lhs, rhs: rhs)
    }
    
    private static func customIsEqual(lhs: CalendarSelectedDates, rhs: CalendarSelectedDates) -> Bool{
        switch true {
        case lhs.singleDate != rhs.singleDate:
            return false
        case lhs.startDate != rhs.startDate:
            return false
        case lhs.endDate != rhs.endDate:
            return false
        default:
            return true
        }
    }
}
