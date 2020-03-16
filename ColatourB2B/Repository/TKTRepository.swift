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
    
    func getAirSearchInit() -> Single<AirTicketSearchResponse> {
        
        let api = APIManager.shared.getAirSearchInit()
        
        return AccountRepository.shared.getAccessToken()
            .flatMap { _ in api }
            .map{ AirTicketSearchResponse(JSON: $0)! }
    }
    
    func getSotoSearchInit() -> Single<SotoTicketResponse> {
        
        let api = APIManager.shared.getSotoSearchInit()
        
        return AccountRepository.shared.getAccessToken()
            .flatMap { _ in api }
            .map{ SotoTicketResponse(JSON: $0)! }
    }
    
    func getLccSearchInit() -> Single<LccTicketResponse> {
        
        let api = APIManager.shared.getLccSearchInit()
        
        return AccountRepository.shared.getAccessToken()
            .flatMap { _ in api }
            .map{ LccTicketResponse(JSON: $0)! }
    }
}
