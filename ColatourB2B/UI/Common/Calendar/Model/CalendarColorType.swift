//
//  CalendarColorType.swift
//  colatour
//
//  Created by M6853 on 2019/8/8.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit

protocol CalendarColorProtocol {
    var colorCalendarSingle: UIColor { get }
    var colorCalendarStart: UIColor { get }
    var colorCalendarEnd: UIColor { get }
    var colorCalendarMiddle: UIColor { get }
    var colorCalendarMiddleCantChoose: UIColor { get }
    var colorCalendarNoteSelected: UIColor { get }
    var colorCalendarNoteNotSelected: UIColor { get }
    var colorCalendarCantChoose: UIColor { get }
}

class CalendarColorForTicket: CalendarColorProtocol {
    var colorCalendarSingle = ColorHexUtil.hexColor(hex: "#9E27BF")
    var colorCalendarStart = ColorHexUtil.hexColor(hex: "#7373b9")
    var colorCalendarEnd =  ColorHexUtil.hexColor(hex: "#5a5aad")
    var colorCalendarMiddle =  ColorHexUtil.hexColor(hex: "#e5e5e5")
    var colorCalendarMiddleCantChoose =  ColorHexUtil.hexColor(hex: "#e5e5e5")
    var colorCalendarNoteSelected = UIColor.white
    var colorCalendarNoteNotSelected = ColorHexUtil.hexColor(hex: "#b4b4b4")
    var colorCalendarCantChoose = ColorHexUtil.hexColor(hex: "#e5e5e5")
}

class CalendarColorForHotel: CalendarColorProtocol {
    var colorCalendarSingle = UIColor.init(named: "通用綠")!
    var colorCalendarStart = UIColor.init(named: "通用綠")!
    var colorCalendarEnd =  UIColor.init(named: "通用綠")!
    var colorCalendarMiddle =  ColorHexUtil.hexColor(hex: "#C6EFD9")
    var colorCalendarMiddleCantChoose =  ColorHexUtil.hexColor(hex: "#e5e5e5")
    var colorCalendarNoteSelected = UIColor.white
    var colorCalendarNoteNotSelected = ColorHexUtil.hexColor(hex: "#b4b4b4")
    var colorCalendarCantChoose = ColorHexUtil.hexColor(hex: "#e5e5e5")
}

