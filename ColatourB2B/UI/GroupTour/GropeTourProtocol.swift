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
}

protocol GropeTourPresenterProtocol: BasePresenterProtocol {
    func getApiToken()
    func getVersionRule()
}
