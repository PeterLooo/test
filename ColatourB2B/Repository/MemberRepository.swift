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
    
    func removeLocalRefreshToken() {
        
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
    
    func setEmployeeMark(emloyeeMark: Bool) {
        UserDefaultUtil.shared.employeeMark = emloyeeMark
    }
    
    func setAllowTour(allowTour: Bool) {
        UserDefaultUtil.shared.allowTour = allowTour
    }
    
    func setAllowTkt(allowTkt: Bool) {
        UserDefaultUtil.shared.allowTkt = allowTkt
    }
    
    func setTabBarLinkType(linkType: String) {
        UserDefaultUtil.shared.tabBarLinkType = linkType
    }
    
    func getSalesList() -> Single<SalesResponse> {
        let api = APIManager.shared.getSalesList()
        
        return AccountRepository.shared.getAccessToken()
            .flatMap{ _ in api}
            .map{SalesResponse(JSON: $0)!}
    }
    
    func getChangeCompany() -> Single<ChangeCompanyModel> {
        let api = APIManager.shared.getCompanyInfo()
        
        return AccountRepository.shared.getAccessToken()
            .flatMap{_ in api}
            .map{ChangeCompanyModel(JSON: $0)!}
    }
    
    func postChangeCompany(model: ChangeCompanyModel) -> Single<ChangeCompanyModel> {
        let api = APIManager.shared.changeCompanyAction(changeModel: model)
        
        return AccountRepository.shared.getAccessToken()
            .flatMap{ _ in api}
            .map{ChangeCompanyModel(JSON: $0)!}
    }
}
