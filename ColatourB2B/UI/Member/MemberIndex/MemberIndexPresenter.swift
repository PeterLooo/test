//
//  MemberIndexPresenter.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/31.
//  Copyright © 2019 Colatour. All rights reserved.
//

import RxSwift

class MemberIndexPresenter: MemberIndexPresenterProtocol {
    
    weak var delegate: MemberIndexViewProtocol?
    let dispose = DisposeBag()
    let accountRepository = AccountRepository.shared
    
    convenience init(delegate:MemberIndexViewProtocol) {
        self.init()
        self.delegate = delegate
    }
    
    func getMemberIndex() {
        self.delegate?.onStartLoadingHandle(handleType: .ignore)
        accountRepository.getMemberIndex().subscribe(onSuccess: { (model) in
            self.delegate?.onBindMemberIndex(result: model)
            self.delegate?.onCompletedLoadingHandle()
        }, onError: { (error) in
            
            self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .toast)
            self.delegate?.onCompletedLoadingHandle()
            
        }).disposed(by:dispose)
    }
    
}
