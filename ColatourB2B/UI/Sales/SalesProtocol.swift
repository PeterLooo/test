//
//  SalesProtocol.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/14.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation
protocol SalesViewProtocol: BaseViewProtocol {
    
    func onBindSalesList(salesList: [SalesResponse.Sales])
}

protocol SalesPresenterProtocol: BasePresenterProtocol {
    
    func getSalesList()
}
