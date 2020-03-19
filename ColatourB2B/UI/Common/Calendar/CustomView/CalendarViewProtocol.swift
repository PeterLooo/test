//
//  CalendarViewProtocol.swift
//  colatour
//
//  Created by M6853 on 2018/5/14.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit

protocol CalendarViewProtocol: NSObjectProtocol {
    func onDoNothing()
    func onDenyUserTapDate()
    func onChangeSingleDate()
    func onDeselectSingleDate()
    func onChangeStartDate()
    func onChangeEndDate()
    func onChangeBothStartEndDate()
    func onChangeStartDateResetEndDate()
    func onChangeEndDateWhenEqualStartDate()
}

