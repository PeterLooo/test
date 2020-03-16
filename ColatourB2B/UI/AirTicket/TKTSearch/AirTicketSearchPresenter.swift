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
    
    private var tktSearchInit: AirTicketSearchResponse?
    private var sotoSearchInit: SotoTicketResponse?
    private var lccSearchInit: LccTicketResponse?
    
    convenience init(delegate: AirTicketSearchViewProtocol?){
        self.init()
        self.delegate = delegate
    }
    
    func getAirTicketSearchInit() {
        self.delegate?.onStartLoadingHandle(handleType: .coverPlate)
        repository.getAirSearchInit().subscribe(onSuccess: { (tktSearchInit) in
            
            self.tktSearchInit = tktSearchInit
            self.delegate?.onCompletedLoadingHandle()
        }, onError: { (error) in
            self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .custom)
            self.delegate?.onCompletedLoadingHandle()
        }).disposed(by: dispose)
        
        self.delegate?.onStartLoadingHandle(handleType: .coverPlate)
        repository.getSotoSearchInit().subscribe(onSuccess: { (sotoSearchInit) in
            
            self.sotoSearchInit = sotoSearchInit
            self.delegate?.onCompletedLoadingHandle()
        }, onError: { (error) in
            self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .custom)
            self.delegate?.onCompletedLoadingHandle()
        }).disposed(by: dispose)
        
        self.delegate?.onStartLoadingHandle(handleType: .coverPlate)
        repository.getLccSearchInit().subscribe(onSuccess: { (lccSearchInit) in
            
            self.lccSearchInit = lccSearchInit
            self.delegate?.onCompletedLoadingHandle()
        }, onError: { (error) in
            self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .custom)
            self.delegate?.onCompletedLoadingHandle()
        }).disposed(by: dispose)
        
        self.delegate?.onBindAirTicketSearchInit(tktSearchInit: tktSearchInit!, sotoSearchInit: sotoSearchInit!, lccSearchInit: lccSearchInit!)
    }
}
