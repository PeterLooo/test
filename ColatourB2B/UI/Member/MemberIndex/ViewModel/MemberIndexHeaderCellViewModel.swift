//
//  MemberIndexHeaderCellViewModel.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/7/7.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation

class MemberIndexHeaderCellViewModel {
    var onTouchLogout: (()->())?
    var memberName: String?
    
    init(name: String){
        memberName = name
    }
}
