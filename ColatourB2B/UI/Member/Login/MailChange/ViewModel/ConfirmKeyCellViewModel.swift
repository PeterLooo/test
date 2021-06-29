//
//  ConfirmKeyCellViewModel.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/6/29.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation

class ConfirmKeyCellViewModel {
    
    var sendKey: ((String?)->())?
    var confirmKeyAreError: ((String?)->())?
    var receiveFail: (()->())?
    var email: String?
    var confirmKey: String?
    
    required convenience init(email: String) {
        self.init()
        self.email = email
    }
    
    func checkConfirmKey(){
        if confirmKey.isNilOrEmpty {
            self.confirmKeyAreError?("請輸入確認碼")
        } else {
            self.sendKey?(confirmKey)
        }
    }
}
