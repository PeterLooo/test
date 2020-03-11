//
//  CalenaderSelectStatus.swift
//  colatour
//
//  Created by M6853 on 2018/5/17.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit

public enum CalenderSelectStatus {
    public typealias RawValue = CalenderSelectStatus
    case isSelectedForSingleDate
    case isSelectedForStartDate
    case isSelectedForMiddleDate
    case isSelectedForEndDate
    case isSelectedForStartDateAndEndDate
    case isNotSelect
}
