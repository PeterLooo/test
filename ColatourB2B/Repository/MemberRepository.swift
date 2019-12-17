//
//  MemberRepository.swift
//  colatour
//
//  Created by AppDemo on 2018/1/17.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MemberRepository: MemberRepositoryProtocol {
    
    static let shared = MemberRepository()
    
    func getLocalMemberToken() -> String? {
        return UserDefaultUtil.shared.memberToken
    }
    
    func getLocalMemberNo() -> Int? {
        return UserDefaultUtil.shared.memberNo
    }
    
    func removeLocalUserToken() {
        UserDefaultUtil.shared.memberNo = nil
        UserDefaultUtil.shared.memberToken = nil
        
        FirebaseCrashManager.setUserName("NoLogin")
    }
    
    func setLocalUserToken(memberNo: Int, memberToken: String) {
        UserDefaultUtil.shared.memberNo = memberNo
        UserDefaultUtil.shared.memberToken = memberToken
        
        FirebaseCrashManager.setUserName("\(memberNo)")
    }
}
