//
//  FormatUtil.swift
//  colatour
//
//  Created by M6853 on 2018/11/12.
//  Copyright © 2018 Colatour. All rights reserved.
//

import UIKit

class FormatUtil: NSObject {
    static func priceFormat(price: Int?) -> String{
        if (price == nil) { return "$ "}
        let priceFormatter = NumberFormatter()
        priceFormatter.numberStyle = NumberFormatter.Style.decimal
        let priceAddComma = priceFormatter.string(from: price! as NSNumber)
        
        let priceAddDolarSign = "$\(priceAddComma ?? "")"
        return priceAddDolarSign
    }
    
    static func removeTimeFromDate(dateString: String?) -> String{
        var dateStringAfterTransform = ""
        let dateFormmaterConvertTo = DateFormatter()
        dateFormmaterConvertTo.setToBasic(dateFormat: "yyyy/MM/dd")
        
        let dateFormatterConvertFrom = DateFormatter()
        dateFormatterConvertFrom.setToBasic()
        
        if let date = dateString {
            dateFormatList.forEach { (dateFormat) in
                if (dateStringAfterTransform == "") {
                    dateFormatterConvertFrom.dateFormat = dateFormat
                    if let dateBeforeConvert = dateFormatterConvertFrom.date(from: date) {
                        let dateStringAfterConvert = dateFormmaterConvertTo.string(from: dateBeforeConvert)
                        dateStringAfterTransform = "\(dateStringAfterConvert)"
                    }
                }
            }
        }
        
        return dateStringAfterTransform
    }
    
    //MARK: 如果From的時間有aaa，可能不適用
    //TODO: 如果來的時間格式固定．應該盡量不要用，有空再想想解決方法
    static func convertStringToString(dateStringFrom: String?, dateFormatTo: String, amSymbolTo: String? = nil, pmSymbolTo: String? = nil) -> String {
        guard let dateStringFrom = dateStringFrom else {  return "" }
        var dateStringAfterTransform = ""
        let dateFormmaterConvertTo = DateFormatter()
        dateFormmaterConvertTo.setToBasic(dateFormat: dateFormatTo, amSymbol: amSymbolTo, pmSymbol: pmSymbolTo)
        
        let dateFormatterConvertFrom = DateFormatter()
        dateFormatterConvertFrom.setToBasic()
        
        dateFormatList.forEach { (dateFormat) in
            if (dateStringAfterTransform == "") {
                dateFormatterConvertFrom.dateFormat = dateFormat
                if let dateBeforeConvert = dateFormatterConvertFrom.date(from: dateStringFrom) {
                    let dateStringAfterConvert = dateFormmaterConvertTo.string(from: dateBeforeConvert)
                    dateStringAfterTransform = "\(dateStringAfterConvert)"
                }
            }
        }
        
        return dateStringAfterTransform
    }
    
    static func convertDateToString(dateFormatTo: String, date: Date, amSymbolTo: String? = nil, pmSymbolTo: String? = nil) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setToBasic(dateFormat: dateFormatTo, amSymbol: amSymbolTo, pmSymbol: pmSymbolTo)
        return dateFormatter.string(from: date)
    }
    
    static func convertStringToDate(dateFormatFrom: String, dateString: String, amSymbolFrom: String? = nil, pmSymbolFrom: String? = nil) -> Date? {
        if ( dateString == "" ) { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.setToBasic(dateFormat: dateFormatFrom, amSymbol: amSymbolFrom, pmSymbol: pmSymbolFrom)
        
        let date = dateFormatter.date(from: dateString)
        return date == nil ? convertStringToDate(dateString: dateString) : date
    }
    
    static private func convertStringToDate(dateString: String?) -> Date? {
        #if DEBUG
        print("****** 字串轉時間，時間格式不正確，再確認一下！ ******")
        print("****** 字串轉時間，時間格式不正確，再確認一下！ ******")
        print("****** 字串轉時間，時間格式不正確，再確認一下！ ******")
        #endif
        guard let dateString = dateString else {  return nil }
        var dateStringToDate: Date?
        
        let dateFormatterConvertFrom = DateFormatter()
        dateFormatterConvertFrom.setToBasic()
        
        dateFormatList.forEach { (dateFormat) in
            if (dateStringToDate == nil) {
                dateFormatterConvertFrom.dateFormat = dateFormat
                if let dateBeforeConvert = dateFormatterConvertFrom.date(from: dateString) {
                    dateStringToDate = dateBeforeConvert
                }
            }
        }
        
        return dateStringToDate
    }
    
    //TODO 待修正為判斷型態Date，非字串
    static func isDefaultDateTime(dateString: String?) -> Bool {
        guard let dateString = dateString else { return true }
        for defaultDate in defaultDateList {
            if (dateString == defaultDate) { return true }
        }
        return false
    }
}
