//
//  CalendarViewControllerProtocol.swift
//  colatour
//
//  Created by M6853 on 2018/5/17.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit

protocol CalendarViewControllerProtocol: NSObjectProtocol {
    func onTouchConfirm(selectedYearMonthDays: CalendarSelectedYearMonthDays)
}
