//
//  CalendarType.swift
//  colatour
//
//  Created by M6853 on 2018/5/10.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit

class CalendarType : NSObject {
    var singleOrMutiple: CalendarSingeleOrMutipleType?
    var isBeforeTodayLimitSelect: Bool?
    var isAcceptLimitDateInMiddle: Bool?
    var confirmTextShowDayOrNight: CalendarConfirmTextType?
    var isAcceptStartDayEqualEndDay: Bool?
    var isEnableTapEvent: Bool?
    var isConfirmButtonHidden: Bool?
    var isDateNoteHiddenWhenDisableDate: Bool? = false
    var colorDef: CalendarColorProtocol?
    var maxLimitedDays: (isLimited: Bool, maxDays: Int?)?
    var dateNoteAtSelectedStartEndDate: (isEnable: Bool, startNote: String?, endNote: String?)?
    
    convenience init (singleOrMituple: CalendarSingeleOrMutipleType
        , isBeforeTodayLimitSelect: Bool
        , isAcceptLimitDateInMiddle: Bool
        , confirmTextShowDayOrNight: CalendarConfirmTextType
        , isAcceptStartDayEqualEndDay: Bool
        , isEnableTapEvent: Bool
        , isConfirmButtonHidden: Bool
        , isDateNoteHiddenWhenDisableDate: Bool
        , colorDef: CalendarColorProtocol
        , maxLimitedDays: (isLimited: Bool, maxDays: Int?)
        , dateNoteAtSelectedStartEndDate: (isEnable: Bool, startNote: String?, endNote: String?)
        ) {
        self.init()
        
        self.singleOrMutiple = singleOrMituple
        self.isBeforeTodayLimitSelect = isBeforeTodayLimitSelect
        self.isAcceptLimitDateInMiddle = isAcceptLimitDateInMiddle
        self.confirmTextShowDayOrNight = confirmTextShowDayOrNight
        self.isAcceptStartDayEqualEndDay = isAcceptStartDayEqualEndDay
        self.isEnableTapEvent = isEnableTapEvent
        self.isConfirmButtonHidden = isConfirmButtonHidden
        self.isDateNoteHiddenWhenDisableDate = isDateNoteHiddenWhenDisableDate
        self.colorDef = colorDef
        self.maxLimitedDays = maxLimitedDays
        self.dateNoteAtSelectedStartEndDate = dateNoteAtSelectedStartEndDate
    }
}
