//
//  CalendarCalendarDayCollectionViewCell.swift
//  colatour
//
//  Created by M6853 on 2018/5/7.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit

protocol CalendarCollectionViewCellProtocol: NSObjectProtocol {
    func onTouchDay(selectOrderYearMonthDay : YearMonthDay)
}

class CalendarDayCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var button: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var note: UILabel!
    var yearMonthDay: YearMonthDay?
    weak var delegate: CalendarCollectionViewCellProtocol?
    private var isDateNoteHiddenWhenDisableDate : Bool!
    private var calendarColorType: CalendarColorProtocol!
    private var dateNoteAtSelectedStartEndDate: (isEnable: Bool, startNote: String?, endNote: String?)!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = UIColor.white
        self.isOpaque = true
        self.button.backgroundColor = self.backgroundColor
        self.button.isOpaque = true
        self.day.backgroundColor = self.button.backgroundColor
        self.day.isOpaque = true
        self.note.backgroundColor = self.button.backgroundColor
        self.note.isOpaque = true
        self.note.adjustsFontSizeToFitWidth = true
        
        self.button.setBorder(width: 0, radius: 4, color: UIColor.white)

        let ges = UITapGestureRecognizer.init(target: self, action: #selector(self.onTouchDay(_:)))
        self.addGestureRecognizer(ges)
    }
    
    func setOrderYearMonthDay(yearMonthDay : YearMonthDay?,
                              isDateNoteHiddenWhenDisableDate: Bool,
                              calendarColorType: CalendarColorProtocol,
                              dateNoteAtSelectedStartEndDate: (isEnable: Bool, startNote: String?, endNote: String?))
    {
    
        self.yearMonthDay = yearMonthDay
        self.isDateNoteHiddenWhenDisableDate = isDateNoteHiddenWhenDisableDate
        self.calendarColorType = calendarColorType
        self.dateNoteAtSelectedStartEndDate = dateNoteAtSelectedStartEndDate
        var dayTitle = ""
        if self.yearMonthDay != nil {
            dayTitle = "\(calendar.component(.day, from: (self.yearMonthDay?.date)!))"
        }
        
        self.day.text = dayTitle
        
        setOrderYearMonthDayAppearance()
    }
    
    func setOrderYearMonthDayAppearance() {
        switch self.yearMonthDay?.isCanChoose {
        case true:
            self.note.isHidden = false
        case false:
            self.note.isHidden = isDateNoteHiddenWhenDisableDate ? true : false
        default:
            self.note.isHidden = true
        }
        
        switch true {
        //Note: 月曆上，空白的格子
        case (self.yearMonthDay == nil):
            self.day.textColor = calendarColorType.colorCalendarCantChoose
            self.note.textColor = calendarColorType.colorCalendarNoteNotSelected
            self.button.backgroundColor = UIColor.white
            self.isUserInteractionEnabled = false
            self.note.text = self.yearMonthDay?.note ?? ""
            
        //Note: 月曆上，不能選，且不介於開始、結束日之間
        case (self.yearMonthDay?.isCanChoose == false && self.yearMonthDay?.selectStatus != .isSelectedForMiddleDate):
            self.day.textColor = calendarColorType.colorCalendarCantChoose
            self.note.textColor = calendarColorType.colorCalendarNoteNotSelected
            self.button.backgroundColor = UIColor.white
            self.isUserInteractionEnabled = false
            self.note.text = self.yearMonthDay?.note ?? ""

        //Note: 月曆上，單選模式下，選擇的單日
        case (self.yearMonthDay?.selectStatus == .isSelectedForSingleDate):
            self.day.textColor = ColorHexUtil.hexColor(hex: "#ffffff")
            self.note.textColor = calendarColorType.colorCalendarNoteSelected
            self.button.backgroundColor = calendarColorType.colorCalendarSingle
            self.isUserInteractionEnabled = true
            self.note.text = dateNoteAtSelectedStartEndDate.isEnable ? dateNoteAtSelectedStartEndDate!.startNote : self.yearMonthDay?.note ?? ""
            
        //Note: 月曆上，多選模式下，選擇的起始日
        case (self.yearMonthDay?.selectStatus == .isSelectedForStartDate):
            self.day.textColor = ColorHexUtil.hexColor(hex: "#f0f0f0")
            self.note.textColor = calendarColorType.colorCalendarNoteSelected
            self.button.backgroundColor = calendarColorType.colorCalendarStart
            self.isUserInteractionEnabled = true
            self.note.text = dateNoteAtSelectedStartEndDate.isEnable ? dateNoteAtSelectedStartEndDate!.startNote : self.yearMonthDay?.note ?? ""

        //Note: 月曆上，不能選，且介於開始、結束日之間的選擇的日
        case (self.yearMonthDay?.isCanChoose == false && self.yearMonthDay?.selectStatus == .isSelectedForMiddleDate):
            self.day.textColor =  UIColor.lightGray
            self.note.textColor = calendarColorType.colorCalendarNoteNotSelected
            self.button.backgroundColor = calendarColorType.colorCalendarMiddleCantChoose
            self.isUserInteractionEnabled = true
            self.note.text = self.yearMonthDay?.note ?? ""
            
        //Note: 月曆上，能選，且介於開始、結束日之間的選擇的日
        case (self.yearMonthDay?.selectStatus == .isSelectedForMiddleDate):
            self.day.textColor =  UIColor.lightGray
            self.note.textColor = calendarColorType.colorCalendarNoteSelected
            self.button.backgroundColor = calendarColorType.colorCalendarMiddle
            self.isUserInteractionEnabled = true
            self.note.text = self.yearMonthDay?.note ?? ""
            
        //Note: 月曆上，多選模式下，選擇的結束日
        case (self.yearMonthDay?.selectStatus == .isSelectedForEndDate):
            self.day.textColor = ColorHexUtil.hexColor(hex: "#ffffff")
            self.note.textColor = calendarColorType.colorCalendarNoteSelected
            self.button.backgroundColor = calendarColorType.colorCalendarEnd
            self.isUserInteractionEnabled = true
            self.note.text = dateNoteAtSelectedStartEndDate.isEnable ? dateNoteAtSelectedStartEndDate!.endNote : self.yearMonthDay?.note ?? ""
            
        //Note: 月曆上，多選模式下，選擇的開始、結束日為同一天的日
        case (self.yearMonthDay?.selectStatus == .isSelectedForStartDateAndEndDate):
            self.day.textColor = ColorHexUtil.hexColor(hex: "#ffffff")
            self.note.textColor = calendarColorType.colorCalendarNoteSelected
            self.button.backgroundColor = calendarColorType.colorCalendarEnd
            self.isUserInteractionEnabled = true
            self.note.text = dateNoteAtSelectedStartEndDate.isEnable ? dateNoteAtSelectedStartEndDate!.startNote : self.yearMonthDay?.note ?? ""
            
        //Note: 月曆上，不能選的日
        case (self.yearMonthDay?.isCanChoose == false):
            self.day.textColor = calendarColorType.colorCalendarCantChoose
            self.note.textColor = calendarColorType.colorCalendarNoteNotSelected
            self.button.backgroundColor = UIColor.white
            self.isUserInteractionEnabled = false
            self.note.text = self.yearMonthDay?.note ?? ""
            
        //Note: 月曆上，沒有被選擇的日
        case (self.yearMonthDay?.selectStatus == .isNotSelect):
            self.day.textColor = ColorHexUtil.hexColor(hex: "#4A4A4A")
            self.note.textColor = calendarColorType.colorCalendarNoteNotSelected
            self.button.backgroundColor = UIColor.white
            self.isUserInteractionEnabled = true
            self.note.text = self.yearMonthDay?.note ?? ""
            
        default:
            self.day.textColor = ColorHexUtil.hexColor(hex: "#4A4A4A")
            self.note.textColor = calendarColorType.colorCalendarNoteNotSelected
            self.button.backgroundColor = UIColor.white
            self.isUserInteractionEnabled = true
            self.note.text = self.yearMonthDay?.note ?? ""
        }
        
        self.button.isOpaque = true
        self.day.backgroundColor = self.button.backgroundColor
        self.day.isOpaque = true
        self.note.backgroundColor = self.button.backgroundColor
        self.note.isOpaque = true
    }
    
    override func prepareForReuse() {
        switch true {
        case (self.yearMonthDay == nil):
            self.day.textColor = UIColor.lightGray
            self.note.textColor = calendarColorType.colorCalendarNoteNotSelected
            self.button.backgroundColor = UIColor.white
            self.day.backgroundColor = self.button.backgroundColor
            self.isUserInteractionEnabled = false
            
        case (self.yearMonthDay?.isCanChoose == false):
            self.day.textColor = UIColor.lightGray
            self.note.textColor = calendarColorType.colorCalendarNoteNotSelected
            self.button.backgroundColor = UIColor.white
            self.day.backgroundColor = self.button.backgroundColor
            self.isUserInteractionEnabled = false
            
        default:
            self.day.textColor = ColorHexUtil.hexColor(hex: "#4A4A4A")
            self.note.textColor = calendarColorType.colorCalendarNoteNotSelected
            self.button.backgroundColor = UIColor.white
            self.day.backgroundColor = self.button.backgroundColor
            self.isUserInteractionEnabled = true
        }
        
        self.button.isOpaque = true
        self.day.backgroundColor = self.button.backgroundColor
        self.day.isOpaque = true
        self.note.backgroundColor = self.button.backgroundColor
        self.note.isOpaque = true
    }
    
    override func reloadInputViews() {
         super.reloadInputViews()
        
         setOrderYearMonthDayAppearance()
    }

    @objc func onTouchDay(_ sender: UILabel) {
        self.delegate?.onTouchDay(selectOrderYearMonthDay: (self.yearMonthDay)!)
    }

}
