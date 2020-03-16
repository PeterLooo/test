//
//  AirTicketSearchPresenter.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2020/3/9.
//  Copyright © 2020 Colatour. All rights reserved.
//

import RxSwift

class AirTicketSearchPresenter: AirTicketSearchPresenterProtocol {
    
    weak var delegate: AirTicketSearchViewProtocol?
    private let repository = TKTRepository.shared
    fileprivate var dispose = DisposeBag()
    
    convenience init(delegate: AirTicketSearchViewProtocol?){
        self.init()
        self.delegate = delegate
    }
    
    func getAirTicketSearchInit() {
        self.delegate?.onStartLoadingHandle(handleType: .coverPlate)
        
        repository.getAirSearchInit().subscribe(onSuccess: { (model) in
            self.delegate?.onBindAirTicketSearchInit(tktSearchInit: model)
            self.delegate?.onCompletedLoadingHandle()
        }, onError: { (error) in
            self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .custom)
            self.delegate?.onCompletedLoadingHandle()
        }).disposed(by: dispose)
    }
    
    func getSotoAirSearchInit() {
         self.delegate?.onStartLoadingHandle(handleType: .coverPlate)
        
        repository.getSotoSearchInit().subscribe(onSuccess: { (model) in
            self.delegate?.onBindSotoAirSearchInit(sotoSearchInit: model)
            self.delegate?.onCompletedLoadingHandle()
        }, onError: { (error) in
            self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .custom)
            self.delegate?.onCompletedLoadingHandle()
        }).disposed(by: dispose)
    }
    
    func postAirTicketSearch(request: TKTSearchRequest) {
        self.delegate?.onStartLoadingHandle(handleType: .coverPlate)
        repository.postAirTicketSearch(request: request).subscribe(onSuccess: { (model) in
            self.delegate?.onBindSearchUrlResult(result: model)
            self.delegate?.onCompletedLoadingHandle()
        }, onError: { (error) in
            self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .custom)
            self.delegate?.onCompletedLoadingHandle()
        }).disposed(by: dispose)
    }
    
    func postSotoTicketSearch(request: SotoTicketRequest) {
        self.delegate?.onStartLoadingHandle(handleType: .coverPlate)
        repository.postSotoTicketSearch(request: request).subscribe(onSuccess: { (model) in
            self.delegate?.onBindSearchUrlResult(result: model)
            self.delegate?.onCompletedLoadingHandle()
        }, onError: { (error) in
            self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .custom)
            self.delegate?.onCompletedLoadingHandle()
        }).disposed(by: dispose)
    }
    
//    func getLccAirSearchInit() {
//        self.delegate?.onStartLoadingHandle(handleType: .coverPlate)
//
//        repository.getLccSearchInit().subscribe(onSuccess: { (model) in
//
//            self.delegate?.onBindLccAirSearchInit(lccSearchInit: model)
//            self.delegate?.onCompletedLoadingHandle()
//        }, onError: { (error) in
//            self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .custom)
//            self.delegate?.onCompletedLoadingHandle()
//        }).disposed(by: dispose)
//    }
}
