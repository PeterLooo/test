//
//  LCCSearchLocationPresenter.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/12.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation

class LCCSearchLocationPresenter: LCCSearchLocationPresenterProtocol {
    
    weak var delegate: LCCSearchLocationViewProtocol?
    
    convenience init(delegate: LCCSearchLocationViewProtocol) {
        self.init()
        self.delegate = delegate
    }
    
    func getSearchResult() {
        
        //抓資料抓資料抓資料
        
        self.delegate?.onBindSearchResult()
    }
}
