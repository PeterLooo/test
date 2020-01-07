//
//  GropeTourPresenter.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/23.
//  Copyright © 2019 Colatour. All rights reserved.
//

import RxSwift

class GropeTourPresenter: GropeTourPresenterProtocol {
    
    weak var delegate: GropeTourViewProtocol?
    fileprivate var dispose = DisposeBag()
    let accountRepositouy = AccountRepository.shared
    let groupReponsitory = GroupReponsitory.shared
    
    convenience init(delegate: GropeTourViewProtocol) {
        self.init()
        self.delegate = delegate
    }
    
    func getApiToken(){
        self.delegate?.onStartLoadingHandle(handleType: .ignore)
        accountRepositouy.apiToken.subscribe(onSuccess: { (model) in
            self.delegate?.onBindApiTokenComplete()
            self.delegate?.onCompletedLoadingHandle()
        }, onError: { (error) in
            self.delegate?.onBindApiTokenComplete()
            self.delegate?.onCompletedLoadingHandle()
        }).disposed(by: dispose)
    }
    
    func getVersionRule() {
        self.delegate?.onStartLoadingHandle(handleType: .ignore)
        
        accountRepositouy.getVersionRule().subscribe(onSuccess: { (model) in
            self.delegate?.onBindVersionRule(versionRule: model)
            self.delegate?.onCompletedLoadingHandle()
        }, onError: { (error) in
            self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .coverPlate)
            self.delegate?.onCompletedLoadingHandle()
        }).disposed(by: dispose)
    }
    
    func getGroupMenu(toolBarType: ToolBarType) {
        self.delegate?.onStartLoadingHandle(handleType: .ignore)
        
        groupReponsitory.getGroupMenu(toolBarType: toolBarType).subscribe(onSuccess: { (model) in
            self.delegate?.onBindGroupMenu(menu: model)
            self.delegate?.onCompletedLoadingHandle()
        }, onError: { (error) in
            self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .coverPlate)
            self.delegate?.onCompletedLoadingHandle()
        }).disposed(by: dispose)
    }
}
