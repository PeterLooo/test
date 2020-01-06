//
//  MoreProtocol.swift
//  ColatourB2B
//
//  Created by M6853 on 2020/1/3.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

protocol MoreViewProtocol: BaseViewProtocol {
    func onBindOtherToolBarList(toolBarList: [ServerData])
}

protocol MorePresenterProtocol: BasePresenterProtocol {
    func getOtherToolBarList()
}

