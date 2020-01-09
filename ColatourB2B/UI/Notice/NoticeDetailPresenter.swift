//
//  NoticeDetailViewController.swift
//  ColatourB2B
//
//  Created by M6853 on 2020/1/8.
//  Copyright © 2020 Colatour. All rights reserved.
//

import RxSwift

class NoticeDetailPresenter: NSObject, NoticeDetailPresenterProtocol {
    let noticeRepository = NoticeDetailRepository.shared
    weak var delegate: NoticeDetailViewProtocol?
    fileprivate var disposeBag = DisposeBag()
    
    convenience init(delegate: NoticeDetailViewProtocol) {
        self.init()
        self.delegate = delegate
    }
    
    func getNoticeDetail(noticeNo: String) {
        self.delegate?.onStartLoadingHandle(handleType: .coverPlate)
        
        noticeRepository
            .getNoticeDetail(noticeNo: noticeNo)
            .subscribe(onSuccess: { model in
                self.delegate?.onBindNoticeDetail(noticeDetail: model)
                self.delegate?.onCompletedLoadingHandle()
            }, onError: { error in
                self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .coverPlate)
                self.delegate?.onCompletedLoadingHandle()
            }).disposed(by: disposeBag)
    }
}
