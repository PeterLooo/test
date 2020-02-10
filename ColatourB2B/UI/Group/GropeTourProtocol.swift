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
    func onBindAccessTokenSuccess()
    func onBindVersionRule(versionRule: VersionRuleReponse.Update?)
    func onBindVersionRuleError()
    func onBindBulletin(bulletin:BulletinResponse.Bulletin?)
    func onBindTourIndex(moduleDataList : [IndexResponse.MultiModule],tourType: TourType)
    func onBindGroupMenu(menu: GroupMenuResponse)
}

protocol GropeTourPresenterProtocol: BasePresenterProtocol {
    func getApiToken()
    func getAccessToken()
    func getVersionRule()
    func getBulletin()
    func getTourIndex(tourType: TourType)
    func getGroupMenu(toolBarType: ToolBarType)
}
