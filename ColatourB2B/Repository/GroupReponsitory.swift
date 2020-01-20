//
//  GroupReponsitory.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/3.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GroupReponsitory: NSObject {
    
    fileprivate var dispose = DisposeBag()
    static let shared = GroupReponsitory()
    
    func getGroupIndex() -> Single<IndexResponse> {
        let api = APIManager.shared.getGroupIndex()
        
        return AccountRepository.shared.getAccessToken()
            .flatMap{_ in api}
            .map{IndexResponse(JSON: $0)!}
    }
    
    func getGroupMenu(toolBarType: ToolBarType) -> Single<GroupMenuResponse> {
        let api = APIManager.shared.getGroupMenu(toolBarType: toolBarType)
        return AccountRepository.shared.getAccessToken()
            .flatMap{_ in api}
            .map{ GroupMenuResponse(JSON: $0)!}
    }
}
