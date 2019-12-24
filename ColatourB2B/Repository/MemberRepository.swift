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
    
    func getLocalAccessToken() -> String? {
        return UserDefaultUtil.shared.accessToken
    }
    
    func getLocalRefreshToken() -> String? {
        return UserDefaultUtil.shared.refreshToken
    }
    
    func removeLocalAccessToken() {
        
        UserDefaultUtil.shared.accessToken = nil
    }
    
    func setLocalUserToken( accessToken: String) {
        
        UserDefaultUtil.shared.accessToken = accessToken
    }
}
