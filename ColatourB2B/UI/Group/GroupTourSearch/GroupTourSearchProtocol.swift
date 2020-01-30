
//
//  GroupTourSearchProtocol.swift
//  ColatourB2B
//
//  Created by M6853 on 2020/1/17.
//  Copyright © 2020 Colatour. All rights reserved.
//

protocol GroupTourSearchViewProtocol: BaseViewProtocol {
    func onBindGroupTourSearchInit(groupTourSearchInit: GroupTourSearchInitResponse.GroupTourSearchInit)
    func onBindGroupTourSearchUrl(groupTourSearchUrl: GroupTourSearchUrlResponse.GroupTourSearchUrl)
}
protocol GroupTourSearchPresenterProtocol : BasePresenterProtocol {
    func getGroupTourSearchInit(departureCode: String?)
    func getGroupTourSearchUrl(groupTourSearchRequest: GroupTourSearchRequest)
}
