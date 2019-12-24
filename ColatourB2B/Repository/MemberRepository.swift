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
        UserDefaultUtil.shared.refreshToken = nil
    }
    
    func setLocalUserToken( accessToken: String) {
        
        UserDefaultUtil.shared.accessToken = accessToken
    }
    
    private func procressToken(loginResponse: LoginResponse) -> Single<LoginResponse> {
        switch loginResponse.passwordReset! {
        case true:
            MemberRepository.shared.removeLocalAccessToken()
        case false:
            MemberRepository.shared.setLocalUserToken(refreshToken: loginResponse.refreshToken!, accessToken: loginResponse.accessToken!)
        }

        return Single.just(loginResponse)
    }
    
    func setLocalUserToken(refreshToken: String, accessToken: String) {
        UserDefaultUtil.shared.refreshToken = refreshToken
        UserDefaultUtil.shared.accessToken = accessToken
        
    }
}
