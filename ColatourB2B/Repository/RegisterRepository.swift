//
//  RegisterRepository.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/12/7.
//  Copyright © 2021 Colatour. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa

class RegisterRepository: NSObject {
    
    static let shared = RegisterRepository()
    
    func getEditorAgent(companyIdno: String) -> Single<RegisterAgentModel> {
        
        let api = APIManager.shared.getEditorAgent(companyIdno: companyIdno)
        
        return AccountRepository.shared.apiToken
            .flatMap{_ in api}
            .map{RegisterAgentModel(JSON: $0)!}
    }
    
    func getRegisterIdNo(idNo: String) -> Single<RegisterIdNoModel> {
        
        let api = APIManager.shared.getRegisterIdNo(idNo: idNo)
        
        return AccountRepository.shared.apiToken
            .flatMap{_ in api}
            .map{RegisterIdNoModel(JSON: $0)!}
    }
    
    func getIDTitle() -> Single<RegisterIdTitleModel> {
        
        let api = APIManager.shared.getIDTitle()
        
        return AccountRepository.shared.apiToken
            .flatMap{_ in api}
            .map{RegisterIdTitleModel(JSON: $0)!}
    }
    
    func getCity() -> Single<RegisterCityResponse> {
        
        let api = APIManager.shared.getCity()
        
        return AccountRepository.shared.apiToken
            .flatMap{_ in api}
            .map{RegisterCityResponse(JSON: $0)!}
    }
    
    func memberRegister(registerRequest: RegisterCompanyRequest) -> Single<RegisterResponse> {
        let api = APIManager.shared.postCompanyRegister(request: registerRequest)
        
        return AccountRepository.shared.apiToken
            .flatMap{_ in api}
            .map{RegisterResponse(JSON: $0)!}
    }
    
    func memberRegister(registerRequest: RegisterBasicInfoRequest) -> Single<RegisterResponse> {
        let api = APIManager.shared.postBasicRegister(request: registerRequest)
        
        return AccountRepository.shared.apiToken
            .flatMap{_ in api}
            .map{RegisterResponse(JSON: $0)!}
    }
}
