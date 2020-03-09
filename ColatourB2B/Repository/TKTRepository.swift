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
    
    func getSearchInit() -> Single<AirTicketSearchResponse> {
        
        let api = APIManager.shared.getAirSearchInit()
        
        return AccountRepository.shared.getAccessToken()
            .flatMap { _ in api }
            .map{ AirTicketSearchResponse(JSON: $0)! }
    }
}
