//
//  AirTicketPresenter.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/6.
//  Copyright © 2020 Colatour. All rights reserved.
//

import RxSwift

class AirTicketPresenter: AirTicketPresenterProtocol {
    
    weak var delegate: AirTicketViewProtocol?
    fileprivate var dispose = DisposeBag()
    
    let groupReponsitory = GroupReponsitory.shared
    
    convenience init(delegate: AirTicketViewProtocol) {
        self.init()
        self.delegate = delegate
    }
    
    func getAirMenu(toolBarType: ToolBarType) {
        self.delegate?.onStartLoadingHandle(handleType: .coverPlate)
        
        groupReponsitory.getGroupMenu(toolBarType: toolBarType).subscribe(onSuccess: { (model) in
            self.delegate?.onBindAirMenu(menu: model)
            self.delegate?.onCompletedLoadingHandle()
        }, onError: { (error) in
            self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .coverPlate)
            self.delegate?.onCompletedLoadingHandle()
        }).disposed(by: dispose)
    }
    
    func getAirTicketIndex() {
        self.delegate?.onStartLoadingHandle(handleType: .coverPlate)
        
        groupReponsitory.getTourIndex(tourType: TourType.tkt).subscribe(onSuccess: { (model) in
            self.delegate?.onBindAirTicketIndex(moduleDataList: model.moduleDataList)
            self.delegate?.onCompletedLoadingHandle()
        }, onError: { (error) in
            self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .coverPlate)
            self.delegate?.onCompletedLoadingHandle()
        }).disposed(by: dispose)
    }

}
