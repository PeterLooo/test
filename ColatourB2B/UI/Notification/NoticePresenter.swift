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
    
    func getNoticeList(pageIndex: Int, handleType: APILoadingHandleType) {
        self.delegate?.onStartLoadingHandle(handleType: handleType)
        
        NoticeRepository.shared.getNoticeList(pageIndex: pageIndex).subscribe(onSuccess: { (model) in
            self.delegate?.onBindNoticeListComplete(noticeList: self.processNotificationResponse(model: model))
            self.delegate?.onCompletedLoadingHandle()
        }, onError: { (error) in
            self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .coverPlate)
            self.delegate?.onCompletedLoadingHandle()
        }).disposed(by: dispose)
    }
    
    func getNewsList(pageIndex: Int, handleType: APILoadingHandleType) {
        self.delegate?.onStartLoadingHandle(handleType: handleType)
        
        NoticeRepository.shared.getNewsList(pageIndex: pageIndex).subscribe(onSuccess: { (model) in
            self.delegate?.onBindNewsListComplete(newsList: self.processNewsResponse(model: model))
            self.delegate?.onCompletedLoadingHandle()
        }, onError: { (error) in
            self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .coverPlate)
            self.delegate?.onCompletedLoadingHandle()
        }).disposed(by: dispose)
    }
    
    func setNoticeRead(noticeIdList: [String]) {
        self.delegate?.onStartLoadingHandle(handleType: .ignore)
        
        NoticeRepository.shared.setNotiRead(notiId: noticeIdList).subscribe(onSuccess: { (_) in
            self.delegate?.onBindSetNotiRead()
            self.delegate?.onCompletedLoadingHandle()
        }, onError: { (error) in
            self.delegate?.onApiErrorHandle(apiError: error as! APIError, handleType: .alert)
            self.delegate?.onCompletedLoadingHandle()
        }).disposed(by: dispose)
    }

    private func processNotificationResponse(model:NoticeResponse) -> [NotiItem] {
        var items:[NotiItem] = []
        model.notification?.notiItemList.forEach({ (item) in
            items.append(NotiItem(notiTitle: item.pushTitle, notiContent: item.pushContent, notiId: item.notiId, notiDate: item.inputTime, unreadMark: item.unreadMark, linkType: item.linkType, linkValue: item.linkValue))
        })
        return items
    }
    private func processNewsResponse(model:NewsResponse) -> [NotiItem] {
        var items:[NotiItem] = []
        model.newsList.forEach({ (item) in
            
            items.append(NotiItem(notiTitle: item.eDMTitle, notiContent: item.publishDate , notiId: nil, notiDate: item.publishDate, unreadMark: item.unreadMark, linkType: item.linkType, linkValue: item.linkValue))
        })
        return items
    }
}
