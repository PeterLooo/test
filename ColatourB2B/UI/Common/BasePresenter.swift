//
//  BasePresenter.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/23.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit
import RxSwift

class BasePresenter: NSObject,BasePresenterProtocol {
    
    let dispose = DisposeBag()
    weak var delegate: BaseViewProtocol?
    
    override init(){
        super.init()
    }
    
    convenience init(delegate: BaseViewProtocol) {
        self.init()
        self.delegate = delegate
    }
    
    func getAccessToken(){
        AccountRepository.shared.getAccessToken(getLocalToken:false).subscribe(onSuccess: { (_) in
            self.delegate?.loadData()
            self.delegate?.onCompletedLoadingHandle()
        }, onError: { (error) in
            self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .coverPlate)
            self.delegate?.onCompletedLoadingHandle()
        }).disposed(by: dispose)
    }
}
