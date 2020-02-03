//
//  SalesPresenter.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/14.
//  Copyright © 2020 Colatour. All rights reserved.
//

import RxSwift

class SalesPresenter: SalesPresenterProtocol {
    
    weak var delegate: SalesViewProtocol?
    private let dispose = DisposeBag()
    
    convenience init(delegate: SalesViewProtocol) {
        self.init()
        self.delegate = delegate
    }
    
    func getSalesList() {
        self.delegate?.onStartLoadingHandle(handleType: .coverPlate)
        MemberRepository.shared.getSalesList().subscribe(onSuccess: { (model) in
            self.delegate?.onBindSalesList(salesList: model.salseList)
            self.delegate?.onCompletedLoadingHandle()
        }) { (error) in
            self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .coverPlate)
            self.delegate?.onCompletedLoadingHandle()
        }.disposed(by: dispose)
    }
}
