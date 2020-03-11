//
//  SelectCalendarController.swift
//  colatourTests
//
//  Created by M6853 on 2018/5/10.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit

class SelectCalendarManager: SelectCalendarManagerProtocol {
    var orderCalendar: CustomCalendar?
    
    var calendarDateAttribute: CalendarDateAttribute? {
        get{
            return self.orderCalendar?.calendarDateAttribute
        }
    }
    
    var calendarType: CalendarType? {
        get{
            return self.orderCalendar?.calendarType
        }
    }
    
    var selectedYearMonthDays: CalendarSelectedYearMonthDays? {
        get{
            return self.orderCalendar?.selectedYearMonthDays
        }
    }
    
    var userTapYearMonthDay: YearMonthDay?
    
    weak var delegate: CalendarViewProtocol?
    
    required init (delegate: CalendarViewProtocol, calendarAllAttribute: CalendarAllAttribute){
        self.delegate = delegate
        
        self.orderCalendar = CustomCalendar(calendarAllAttribute: calendarAllAttribute)
    }

    func tapDate(selectOrderYearMonthDay: YearMonthDay) {
        self.userTapYearMonthDay = selectOrderYearMonthDay

        let isSelectedDayCanChoose = selectOrderYearMonthDay.isCanChoose

        if (isSelectedDayCanChoose == false) {
            onDoNothing()
            return
        }
        
        if (self.calendarType!.isEnableTapEvent == false ){
            onDoNothing()
            return
        }
        
        if(calendarType?.singleOrMutiple == .single) {
            tapDateWithSingleType()
        }else if (calendarType?.singleOrMutiple == .mutiple){
            tapDateWithMutipleType()
        }
    }
    
    private func tapDateWithSingleType() {
        switch true {
        case userTapYearMonthDay == selectedYearMonthDays?.singleDay:
            onDeselectSingleDate()
        default:
            onChangeSingleDate()
        }
    }
    
    private func tapDateWithMutipleType() {
        switch true {
            
        //當開始日未選，結束日未選時，選擇任一，則開始等於選擇日
        case selectedYearMonthDays?.startDay == nil:
            onChangeStartDate()
            
        //當開始日已選，結束日未選時，選擇開始日時
        case userTapYearMonthDay == selectedYearMonthDays?.startDay && selectedYearMonthDays?.endDay == nil:
            switch (calendarType?.isAcceptStartDayEqualEndDay)! {
            ///當開始日已選，結束日未選時，選擇開始日，且接受開始與結束日同一天時，則結束等於選擇日
            case true:
                onChangeEndDateWhenEqualStartDate()
            ///當開始日已選，結束日未選時，選擇開始日，且不接受開始與結束日同一天時，則不做事
            case false:
                onDoNothing()
            }
            
        //當開始日已選，結束日未選時，選擇開始以外任一時
        case selectedYearMonthDays?.endDay == nil:
            switch true {
            ///當開始日已選，結束日未選時，選擇開始以外，且小於開始日時
            case (userTapYearMonthDay?.date)! < (selectedYearMonthDays?.startDay?.date)!:
                let isLimitDateInMiddleCheckAndAccept = isLimitDateInMiddleCheckAndAcceptCheck(startDate: (userTapYearMonthDay?.date)!, endDate: (selectedYearMonthDays?.startDay?.date)!)
                ////當接受中間包含不適用日期，則結束日清空，開始日等選擇日
                if (isLimitDateInMiddleCheckAndAccept == true) {
                    onChangeStartDateResetEndDate()
                ////當開始與結束中間，包含且不接受中間包含不適用日期，則拒絕用戶點擊
                } else {
                    onDenyUserTapDate()
                }
                
            ///當開始日已選，結束日未選時，選擇開始以外，且大於開始日，則結束日等於選擇日
            default:
                let needToChangeSelectedDate = isLimitDateInMiddleCheckAndAcceptCheck(startDate: (selectedYearMonthDays?.startDay?.date)!, endDate: (userTapYearMonthDay?.date)!)
                if (needToChangeSelectedDate == true) {
                    onChangeEndDate()
                } else {
                    onDenyUserTapDate()
                }
            }
        
        //當開始日已選，結束日已選時，選擇開始日時，則開始日等於選擇日，結束日清空
        case userTapYearMonthDay == selectedYearMonthDays?.startDay:
            onChangeStartDateResetEndDate()
            
        //當開始日已選，結束日已選時，選擇結束日，則開始日等於選擇日，結束日清空
        case (userTapYearMonthDay?.date)! == (selectedYearMonthDays?.endDay?.date)!:
            onChangeStartDateResetEndDate()
            
        //當開始日已選，結束日已選時，選擇小於開始日，則開始日等於選擇日，結束日清空
        case (userTapYearMonthDay?.date)!! < (selectedYearMonthDays?.startDay?.date)!:
            onChangeStartDateResetEndDate()
            
        //當開始日已選，結束日已選時，選擇大於結束日，則開始日等於選擇日，結束日清空
        case (userTapYearMonthDay?.date)!! > (selectedYearMonthDays?.endDay?.date)!:
            onChangeStartDateResetEndDate()
            
        //當開始日已選，結束日已選時，選擇介於開始日以及結束日，則開始日等於選擇日，結束日清空
        default:
            onChangeStartDateResetEndDate()
            
        }
    }
    
    private func onDoNothing() {
        self.delegate?.onDoNothing()
    }
    
    private func onDenyUserTapDate() {
        self.selectedYearMonthDays?.startDay?.selectStatus = .isNotSelect
        self.selectedYearMonthDays?.startDay = nil
        
        self.delegate?.onDenyUserTapDate()
    }
    
    private func onChangeSingleDate() {
        self.selectedYearMonthDays?.singleDay?.selectStatus = .isNotSelect
        self.userTapYearMonthDay?.selectStatus = .isSelectedForSingleDate
        
        self.selectedYearMonthDays?.singleDay = self.userTapYearMonthDay

        self.delegate?.onChangeSingleDate()
    }
    
    private func onDeselectSingleDate() {
        self.selectedYearMonthDays?.singleDay?.selectStatus = .isNotSelect
        self.selectedYearMonthDays?.singleDay = nil
        
        self.delegate?.onDeselectSingleDate()
    }
    
    private func onChangeStartDate() {
        self.selectedYearMonthDays?.startDay?.selectStatus = .isNotSelect
        self.userTapYearMonthDay?.selectStatus = .isSelectedForStartDate
        
        self.selectedYearMonthDays?.startDay = self.userTapYearMonthDay
        
        self.delegate?.onChangeStartDate()
    }
    
    private func onChangeEndDate() {
        self.selectedYearMonthDays?.endDay?.selectStatus = .isNotSelect
        self.selectedYearMonthDays?.middleDays.forEach{ $0.selectStatus = .isNotSelect }
        
        self.userTapYearMonthDay?.selectStatus = .isSelectedForEndDate

        let newMiddleDays = self.orderCalendar?.getYearMonthDays(startDate: (selectedYearMonthDays?.startDay?.date)!, endDate: (userTapYearMonthDay?.date)!, isIncludeStartAndEnd: false)
        newMiddleDays?.forEach{ $0.selectStatus = .isSelectedForMiddleDate}

        self.selectedYearMonthDays?.middleDays = newMiddleDays!
        self.selectedYearMonthDays?.endDay = self.userTapYearMonthDay
        
        self.delegate?.onChangeEndDate()
    }
    
    private func onChangeEndDateWhenEqualStartDate() {
        self.selectedYearMonthDays?.endDay?.selectStatus = .isNotSelect
        self.selectedYearMonthDays?.middleDays.forEach{ $0.selectStatus = .isNotSelect }
        
        self.userTapYearMonthDay?.selectStatus = .isSelectedForStartDateAndEndDate
        
        let newMiddleDays = self.orderCalendar?.getYearMonthDays(startDate: (selectedYearMonthDays?.startDay?.date)!, endDate: (userTapYearMonthDay?.date)!, isIncludeStartAndEnd: false)
        newMiddleDays?.forEach{ $0.selectStatus = .isSelectedForMiddleDate}
        
        self.selectedYearMonthDays?.middleDays = newMiddleDays!
        self.selectedYearMonthDays?.endDay = self.userTapYearMonthDay
        
        self.delegate?.onChangeEndDateWhenEqualStartDate()
    }
    
    private func onChangeBothStartEndDate() {
        self.selectedYearMonthDays?.middleDays.forEach{ $0.selectStatus = .isNotSelect }
        
        self.userTapYearMonthDay?.selectStatus = .isSelectedForStartDate
        self.selectedYearMonthDays?.startDay?.selectStatus = .isSelectedForEndDate
        
        let newMiddleDays = self.orderCalendar?.getYearMonthDays(startDate: self.userTapYearMonthDay!.date!, endDate: selectedYearMonthDays?.startDay?.date!, isIncludeStartAndEnd: false)
        newMiddleDays?.forEach{ $0.selectStatus = .isSelectedForMiddleDate}
        
        self.selectedYearMonthDays?.middleDays = newMiddleDays!
        self.selectedYearMonthDays?.endDay = selectedYearMonthDays?.startDay
        self.selectedYearMonthDays?.startDay = self.userTapYearMonthDay
        
        self.delegate?.onChangeBothStartEndDate()
    }
    
    private func onChangeStartDateResetEndDate() {
        self.selectedYearMonthDays?.startDay?.selectStatus = .isNotSelect
        self.selectedYearMonthDays?.endDay?.selectStatus = .isNotSelect
        self.selectedYearMonthDays?.middleDays.forEach{ $0.selectStatus = .isNotSelect }
        
        self.userTapYearMonthDay?.selectStatus = .isSelectedForStartDate
    
        self.selectedYearMonthDays?.middleDays = []
        self.selectedYearMonthDays?.startDay = self.userTapYearMonthDay
        self.selectedYearMonthDays?.endDay = nil

        self.delegate?.onChangeStartDateResetEndDate()
    }
    
    private func isLimitDateInMiddleCheckAndAcceptCheck (startDate: Date, endDate: Date) -> Bool {
        let isAcceptLimitDateInMiddle = calendarType?.isAcceptLimitDateInMiddle
        let isLimitDateInMiddle = self.isLimitDateInMiddle(startDate: startDate, endDate: endDate)
        
        //中間有不適用日期，且不接受中間有不適用日期，拒絕點擊
        if (isAcceptLimitDateInMiddle == false && isLimitDateInMiddle == true) {
            return false
            
        }
        
        return true
    }
    
    private func isLimitDateInMiddle(startDate: Date, endDate: Date) -> Bool {
        var isLimitDateInMiddle = false
  
        self.orderCalendar?.getYearMonthDays(startDate: startDate, endDate: endDate, isIncludeStartAndEnd: true).forEach {
            if ($0.isCanChoose == false) {
                isLimitDateInMiddle = true
            }
        }

        return isLimitDateInMiddle
    }
}
