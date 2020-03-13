//
//  ChooseLocationPresenter.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/12.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation

class ChooseLocationPresenter: ChooseLocationPresenterProtocol {
    
    weak var delegate: ChooseLocationViewProtocol?
    
    convenience init(delegate: ChooseLocationViewProtocol) {
        self.init()
        self.delegate = delegate
    }
    
    func getSearchResult() {
        
        //抓資料抓資料抓資料
        
        self.delegate?.onBindSearchResult()
    }
}
