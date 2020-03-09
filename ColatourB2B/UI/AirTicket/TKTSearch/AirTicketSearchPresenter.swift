//
//  AirTicketSearchPresenter.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2020/3/9.
//  Copyright © 2020 Colatour. All rights reserved.
//

import RxSwift

class AirTicketSearchPresenter:AirTicketSearchPresenterProtocol {
    
    weak var delegate: AirTicketSearchViewProtocol?
    private let response = TKTRepository.shared
    fileprivate var dispose = DisposeBag()
    
    convenience init(delegate: AirTicketSearchViewProtocol?){
        self.init()
        self.delegate = delegate
    }
    
    func getAirTicketSearchInit() {
        self.delegate?.onStartLoadingHandle(handleType: .coverPlate)
        response.getSearchInit().subscribe(onSuccess: { (model) in
            self.delegate?.onBindAirTicketSearchInit(groupTourSearchInit: model)
            self.delegate?.onCompletedLoadingHandle()
        }, onError: { (error) in
            
            self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .custom)
            self.delegate?.onCompletedLoadingHandle()
        }).disposed(by: dispose)
    }
    
}
