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
    
    func getAirTktSearchResult(keyword: String) {
        
        self.delegate?.onStartLoadingHandle(handleType: .coverPlate)
        
        repository.getAirTktLocationKeywordSearchResult(keyword: keyword).subscribe(
            onSuccess: { (model) in
                self.delegate?.onBindSearchResult(result: model.keywordResultData?.cityList ?? [])
                self.delegate?.onCompletedLoadingHandle()
        }, onError: { (error) in
            self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .custom)
                self.delegate?.onCompletedLoadingHandle()
        }).disposed(by: dispose)
    }
    
    func getLccSearchResult(keyword: String) {
        
        self.delegate?.onStartLoadingHandle(handleType: .coverPlate)
        
        repository.getLccLocationKeywordSearchResult(keyword: keyword).subscribe(
            onSuccess: { (model) in
                self.delegate?.onBindSearchResult(result: model.keywordResultData?.cityList ?? [])
                self.delegate?.onCompletedLoadingHandle()
        }, onError: { (error) in
                self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .custom)
                self.delegate?.onCompletedLoadingHandle()
        }).disposed(by: dispose)
    }
}
