//
//  BaseViewModelPrivate.swift
//  ColatourB2B
//
//  Created by 吳思賢 on 2021/5/28.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation
import RxSwift

class BaseViewModelPrivate: BaseViewModel {
    
    static let share = BaseViewModelPrivate()
    
    private var dispose = DisposeBag()
    
    
}
