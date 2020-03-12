//
//  YearMonthDay.swift
//  colatour
//
//  Created by AppDemo on 2018/1/10.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit

class YearMonthDay: NSObject {
    var date: Date?
    var isCanChoose = true
    var selectStatus = CalenderSelectStatus.isNotSelect
    var note: String?

    init(date: Date, isCanChoose: Bool, selectStatus: CalenderSelectStatus, note: String?) {
        self.date = date
        self.isCanChoose = isCanChoose
        self.selectStatus = selectStatus
        self.note = note
    }
}

