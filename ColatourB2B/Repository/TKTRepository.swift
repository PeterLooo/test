//
//  TKTRepository.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2020/3/9.
//  Copyright © 2020 Colatour. All rights reserved.
//

import RxSwift
import RxCocoa

class TKTRepository: NSObject {
    
    static let shared = TKTRepository()
    
    func getAirSearchInit() -> Single<TKTInitResponse> {
        
        let api = APIManager.shared.getAirSearchInit()
        
        return AccountRepository.shared.getAccessToken()
            .flatMap { _ in api }
            .map{ TKTInitResponse(JSON: $0)! }
    }
    
    func getSotoSearchInit() -> Single<TKTInitResponse> {
        
        let api = APIManager.shared.getSotoSearchInit()
        
        return AccountRepository.shared.getAccessToken()
            .flatMap { _ in api }
            .map{ TKTInitResponse(JSON: $0)! }
    }
    
    func getLccSearchInit() -> Single<LccResponse> {
        
        let api = APIManager.shared.getLccSearchInit()
        
        return AccountRepository.shared.getAccessToken()
            .flatMap { _ in api }
            .map{ LccResponse(JSON: $0)! }
    }
    
    func postAirTicketSearch(request: TKTSearchRequest) -> Single<AirSearchUrlResponse> {
        let api = APIManager.shared.postAirTicketSearch(request: request)
        return AccountRepository.shared.getAccessToken()
        .flatMap { _ in api }
        .map{ AirSearchUrlResponse(JSON: $0)! }
    }
    
    func postSotoTicketSearch(request: SotoTicketRequest) -> Single<AirSearchUrlResponse> {
        let api = APIManager.shared.postSotoTicketSearch(request: request)
        return AccountRepository.shared.getAccessToken()
        .flatMap { _ in api }
        .map{ AirSearchUrlResponse(JSON: $0)! }
    }
    
    func postLCCicketSearch(request: LccTicketRequest) -> Single<AirSearchUrlResponse> {
        let api = APIManager.shared.postLccTicketSearch(request: request)
        return AccountRepository.shared.getAccessToken()
        .flatMap { _ in api }
        .map{ AirSearchUrlResponse(JSON: $0)! }
    }
}
