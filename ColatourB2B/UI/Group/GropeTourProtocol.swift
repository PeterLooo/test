//
//  GropeTourProtocol.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/23.
//  Copyright © 2019 Colatour. All rights reserved.
//

import Foundation
protocol GropeTourViewProtocol: BaseViewProtocol {
    
    func onBindApiTokenComplete()
    func onBindVersionRule(versionRule: VersionRuleReponse.Update?)
    func onBindGroupIndex(moduleDataList : [IndexResponse.MultiModule])
    func onBindGroupMenu(menu: GroupMenuResponse)
}

protocol GropeTourPresenterProtocol: BasePresenterProtocol {
    func getApiToken()
    func getVersionRule()
    func getGroupIndex()
    func getGroupMenu(toolBarType: ToolBarType)
}
