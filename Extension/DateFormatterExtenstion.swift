//
//  UIViewExtenstion.swift
//  colatour
//
//  Created by M6853 on 2019/4/24.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit

extension DateFormatter {
    func setToBasic(dateFormat: String? = nil, amSymbol: String? = nil, pmSymbol: String? = nil) {
        self.calendar = calendarForDatePicker
        self.timeZone = TimeZone(abbreviation: "UTC+8:00")
        self.locale = Locale(identifier: "zh_TW") // 語系
        self.dateFormat = dateFormat
        self.amSymbol = amSymbol
        self.pmSymbol = pmSymbol
    }
}

extension UIDatePicker {
    func setToBasic() {
        self.calendar = calendarForDatePicker
        self.timeZone = TimeZone(abbreviation: "UTC+8:00") // 顯示的
        self.locale = Locale(identifier: "zh_TW")
    }
}
