//
//  GroupTourSearchPresenter.swift
//  ColatourB2B
//
//  Created by M6853 on 2020/1/17.
//  Copyright © 2020 Colatour. All rights reserved.
//

import RxSwift

class GroupTourSearchPresenter: GroupTourSearchPresenterProtocol {
    weak var delegate: GroupTourSearchViewProtocol?
    
    fileprivate var dispose = DisposeBag()
    
    convenience init(delegate: GroupTourSearchViewProtocol){
        self.init()
        self.delegate = delegate
    }
    
    func getGroupTourSearchInit(departureCode: String?) {
        self.delegate?.onStartLoadingHandle(handleType: .coverPlate)
        GroupReponsitory.shared
            .getGroupTourSearchInit(departureCode: departureCode)
            .subscribe(onSuccess:{ (model) in
                self.delegate?.onBindGroupTourSearchInit(groupTourSearchInit: model)
                self.delegate?.onCompletedLoadingHandle()
            }, onError: { (error) in
                self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .coverPlate)
                self.delegate?.onCompletedLoadingHandle()
                
            }).disposed(by:dispose)
    }
    
    func getGroupTourSearchUrl(groupTourSearchRequest: GroupTourSearchRequest) {
        self.delegate?.onStartLoadingHandle(handleType: .coverPlate)
        GroupReponsitory.shared
            .getGroupTourSearchUrl(groupTourSearchRequest: groupTourSearchRequest)
            .subscribe(onSuccess:{ (model) in
                self.delegate?.onBindGroupTourSearchUrl(groupTourSearchUrl: model)
                self.delegate?.onCompletedLoadingHandle()
            }, onError: { (error) in
                self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .alert)
                self.delegate?.onCompletedLoadingHandle()
                
            }).disposed(by:dispose)
    }
    
    func getGroupTourSearchUrl(groupTourSearchKeywordAndTourCodeRequest: GroupTourSearchKeywordAndTourCodeRequest) {
        self.delegate?.onStartLoadingHandle(handleType: .coverPlate)
        GroupReponsitory.shared
            .getGroupTourSearchUrl(groupTourSearchKeywordAndTourCodeRequest: groupTourSearchKeywordAndTourCodeRequest)
            .subscribe(onSuccess:{ (model) in
                self.delegate?.onBindGroupTourSearchUrl(groupTourSearchUrl: model)
                self.delegate?.onCompletedLoadingHandle()
            }, onError: { (error) in
                self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .alert)
                self.delegate?.onCompletedLoadingHandle()
                
            }).disposed(by:dispose)
    }
}