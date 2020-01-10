//
//  NoticePresenter.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/9.
//  Copyright © 2020 Colatour. All rights reserved.
//

import RxSwift

class NoticePresenter: NoticePresenterProtocol {
    
    weak var delegate : NoticeViewProtocol?
    let dispose = DisposeBag()
    
    convenience init(delegate: NoticeViewProtocol) {
        self.init()
        self.delegate = delegate
    }
    
    func getNoticeList() {
        self.delegate?.onStartLoadingHandle(handleType: .coverPlate)
        
        NoticeRepository.shared.getNoticeList().subscribe(onSuccess: { (model) in
            self.delegate?.onBindNoticeListComplete(noticeList: model)
            self.delegate?.onCompletedLoadingHandle()
        }, onError: { (error) in
            self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .coverPlate)
            self.delegate?.onCompletedLoadingHandle()
        }).disposed(by: dispose)
    }

}
