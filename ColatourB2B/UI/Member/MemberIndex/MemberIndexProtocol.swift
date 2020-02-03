//
//  MemberIndexProtocol.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/31.
//  Copyright © 2019 Colatour. All rights reserved.
//

import Foundation
protocol MemberIndexViewProtocol:BaseViewProtocol {
    func onBindMemberIndex(result: MemberIndexResponse)
}

protocol MemberIndexPresenterProtocol:BasePresenterProtocol {
    func getMemberIndex()
    func memberLogout()
}
