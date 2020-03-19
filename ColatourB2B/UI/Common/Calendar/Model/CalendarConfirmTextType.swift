//
//  CalendarConfirmTextType.swift
//  colatour
//
//  Created by M6853 on 2018/5/10.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit

public enum CalendarConfirmTextType {
    public typealias RawValue = CalendarConfirmTextType
    case days
    case nights
    
    func getNumberOfDaysTitle(days: Int) -> String {
        switch self {
        case .days:
            return "\(days) 個天數"
        case .nights:
            return "共 \(days - 1) 晚"
        }
    }
    
    func getLimitedDaysTitle(maxDays: Int) -> String {
        switch self {
        case .days:
            return "最多可訂 \(maxDays) 個天數"
        case .nights:
            return "最多可訂 \(maxDays - 1) 晚"
        }
    }
    
    func isOutOfBounds(selectedDays: Int, maxDays: Int?) -> Bool {
        guard let maxDays = maxDays else { return false }
        switch self {
        case .days:
            //Note: 超過可訂天數
            if ( selectedDays > maxDays ) {
                return true
            } else {
                return false
            }
        case .nights:
            //Note: 超過可訂晚
            if ( (selectedDays - 1) > ( maxDays - 1 ) ) {
                return true
            } else {
                return false
            }
        }
    }
}

