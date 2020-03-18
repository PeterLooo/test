//
//  ChooseLocationPresenter.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/12.
//  Copyright © 2020 Colatour. All rights reserved.
//

import Foundation
import RxSwift

class ChooseLocationPresenter: ChooseLocationPresenterProtocol {
    
    weak var delegate: ChooseLocationViewProtocol?
    private let repository = TKTRepository.shared
    fileprivate var dispose = DisposeBag()
    
    convenience init(delegate: ChooseLocationViewProtocol) {
        self.init()
        self.delegate = delegate
    }
    
    func getSearchResult(keyword: String) {

        self.delegate?.onStartLoadingHandle(handleType: .coverPlate)
        
        repository.getLocationKeywordSearchResult(keyword: keyword).subscribe(
            onSuccess: { (model) in
                self.delegate?.onBindSearchResult(result: model)
            self.delegate?.onCompletedLoadingHandle()
        }, onError: { (error) in
            self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .coverPlate)
            self.delegate?.onCompletedLoadingHandle()
        }).disposed(by: dispose)
    }
}
