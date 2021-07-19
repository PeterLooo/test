//
//  NoticeViewModel.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/7/5.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation
import RxSwift

class NoticeViewModel: BaseViewModel {
    
    var onBindTableViewModel: ((NoticeTableViewModel)->())?
    var onGetNotiListError: ((_ notiType: NotiType, _ apiError: APIError) -> ())?
    var toNoticeDetail:((_ item: NotiItemViewModel)->())?
    var setTopPageSheetStatus: ((_ notiType: NotiType, _ status: Bool)->())?
    
    var needReloadData = true
    
    private var pageSize = 30
    private var isImportantLastPage = false
    private var isNotiLastPage = false
    private var isGroupNewsLastPage = false
    private var isAirNewsLastPage = false
    
    private let dispose = DisposeBag()
    private let tableViewModels = [NoticeTableViewModel(.important),
                                   NoticeTableViewModel(.noti),
                                   NoticeTableViewModel(.groupNews),
                                   NoticeTableViewModel(.airNews)]
    
    override init() {
        super.init()
        tableViewModels.forEach({$0.itemList = []})
        tableViewModels.forEach { [weak self] viewModel in
            viewModel.pullRefresh = {[weak self] notiType in
                switch notiType {
                case .important:

                    self?.getImportantList(pageIndex: 1, handleType: .coverPlateAlpha)
                case .noti:

                    self?.getNoticeList(pageIndex: 1, handleType: .coverPlateAlpha)
                case .groupNews:

                    self?.getGroupNewsList(pageIndex: 1, handleType: .coverPlateAlpha)
                case .airNews:

                    self?.getAirNewsList(pageIndex: 1, handleType: .coverPlateAlpha)
                }
            }
        }
        
        tableViewModels.forEach { [weak self] viewModel in
            viewModel.onStartLoading = {[weak self] notiType in
                switch notiType {
                case .important:
                    if self?.isImportantLastPage == true {return}
                    if (self?.tableViewModels[0].itemList.count)! % self!.pageSize == 0 {
                        self?.getImportantList(pageIndex: ((self?.tableViewModels[0].itemList.count)! / 10) + 1, handleType: .ignore)
                    }
                case .noti:
                    if self?.isNotiLastPage == true {return}
                    if (self?.tableViewModels[1].itemList.count)! % self!.pageSize == 0 {
                        self?.getNoticeList(pageIndex: ((self?.tableViewModels[1].itemList.count)! / 10) + 1, handleType: .ignore)
                    }
                case .groupNews:
                    if self?.isGroupNewsLastPage == true {return}
                    if (self?.tableViewModels[2].itemList.count)! % self!.pageSize == 0 {
                        self?.getGroupNewsList(pageIndex: ((self?.tableViewModels[2].itemList.count)! / 10) + 1, handleType: .ignore)
                    }
                case .airNews:
                    if self?.isAirNewsLastPage == true {return}
                    if (self?.tableViewModels[3].itemList.count)! % self!.pageSize == 0 {
                        self?.getAirNewsList(pageIndex: ((self?.tableViewModels[3].itemList.count)! / 10) + 1, handleType: .ignore)
                    }
                }
            }
        }
        
        tableViewModels.forEach { [weak self] viewModel in
            viewModel.onTouchNoti = { [weak self] item, type in
                if item.unreadMark == true {
                    self?.setNoticeRead(noticeIdList: [item.notiId!])
                    item.unreadMark = false
                    FirebaseAnalyticsManager.setEvent(.iOS_NOTICE_OPEN, parameters: [.item_name : item.notiTitle ?? ""])
                }
                self?.setTopPageSheetStatus(notiType: type)
                if item.apiNotiType == "Message" {
                    self?.toNoticeDetail?(item)
                } else {
                    self?.handleLinkType?( item.linkType!,  item.linkValue,  nil, nil)
                }
            }
        }
    }
    
    func getList() {
        if needReloadData {
            tableViewModels.forEach({$0.itemList = []})
            isImportantLastPage = false
            isNotiLastPage = false
            isGroupNewsLastPage = false
            isAirNewsLastPage = false
            NotificationCenter.default.post(name: Notification.Name("getUnreadCount"), object: nil)
            getImportantList(pageIndex: 1, handleType: .coverPlate)
            getNoticeList(pageIndex: 1, handleType: .coverPlate)
            getGroupNewsList(pageIndex: 1, handleType: .coverPlate)
            getAirNewsList(pageIndex: 1, handleType: .coverPlate)
            needReloadData = false
        }
    }
    
    func getImportantList(pageIndex: Int, handleType: APILoadingHandleType) {

        self.onStartLoadingHandle?(handleType)
        
        NoticeRepository.shared.getImportantList(pageIndex: pageIndex).subscribe(onSuccess: { [weak self] (model) in
            
            self?.onBindModelComplete((self?.processNotificationResponse(model: model))!, pageIndex: pageIndex, index: 0)
            
            self?.onCompletedLoadingHandle?()
            
        }, onError: { [weak self] (error) in
            self?.onGetNotiListError?(.important,error as! APIError)
            self?.onApiErrorHandle?( error as! APIError, .custom)
            self?.onCompletedLoadingHandle?()
        }).disposed(by: dispose)
    }
    
    func getNoticeList(pageIndex: Int, handleType: APILoadingHandleType) {
        
        self.onStartLoadingHandle?(handleType)
        
        NoticeRepository.shared.getNoticeList(pageIndex: pageIndex).subscribe(onSuccess: { [weak self] (model) in
            self?.onBindModelComplete((self?.processNotificationResponse(model: model))!, pageIndex: pageIndex, index: 1)
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.onGetNotiListError?( .noti, error as! APIError)
            self?.onApiErrorHandle?( error as! APIError, .custom)
            self?.onCompletedLoadingHandle?()
        }).disposed(by: dispose)
    }
    
    func getGroupNewsList(pageIndex: Int, handleType: APILoadingHandleType) {
        
        self.onStartLoadingHandle?(handleType)
        
        NoticeRepository.shared.getGroupNewsList(pageIndex: pageIndex).subscribe(onSuccess: { [weak self] (model) in
            self?.onBindModelComplete((self?.processNewsResponse(model: model))!, pageIndex: pageIndex, index: 2)
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.onGetNotiListError?(.groupNews, error as! APIError)
            self?.onApiErrorHandle?( error as! APIError, .custom)
            self?.onCompletedLoadingHandle?()
        }).disposed(by: dispose)
    }
    
    func getAirNewsList(pageIndex: Int, handleType: APILoadingHandleType) {
        
        self.onStartLoadingHandle?(handleType)
        
        NoticeRepository.shared.getAirNewsList(pageIndex: pageIndex).subscribe(onSuccess: { [weak self] (model) in
            self?.onBindModelComplete((self?.processNewsResponse(model: model))!, pageIndex: pageIndex, index: 3)
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.onGetNotiListError?(.airNews, error as! APIError)
            self?.onApiErrorHandle?( error as! APIError, .custom)
            self?.onCompletedLoadingHandle?()
            }).disposed(by: dispose)
      }
    
    func setNoticeRead(noticeIdList: [String]) {
        self.onStartLoadingHandle?(.ignore)
        
        NoticeRepository.shared.setNotiRead(notiId: noticeIdList).subscribe(onSuccess: { [weak self] (_) in
            NotificationCenter.default.post(name: Notification.Name("getUnreadCount"), object: nil)
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.onApiErrorHandle?( error as! APIError, .alert)
            self?.onCompletedLoadingHandle?()
        }).disposed(by: dispose)
    }

    private func processNotificationResponse(model: NoticeResponse) -> [NotiItemViewModel] {
        
        var items:[NotiItemViewModel] = []
        
        model.notification?.notiItemList.forEach({ (item) in
            let itemViewModel = NotiItemViewModel(notiTitle: item.pushTitle, notiContent: item.pushContent, notiId: item.notiId, notiDate: item.inputTime, unreadMark: item.unreadMark, linkType: item.linkType, linkValue: item.linkValue, apiNotiType: item.notiType)
            items.append(itemViewModel)
        })
        return items
    }
    
    private func processNewsResponse(model: NewsResponse) -> [NotiItemViewModel] {
        
        var items:[NotiItemViewModel] = []
        
        model.newsList.forEach({ (item) in
            let itemViewModel = NotiItemViewModel(notiTitle: item.eDMSource, notiContent: item.eDMTitle , notiId: nil, notiDate: item.publishDate, unreadMark: item.unreadMark, linkType: item.linkType, linkValue: item.linkValue, apiNotiType: nil)
            items.append(itemViewModel)
        })
        return items
    }
    
    func onBindModelComplete(_ importantList: [NotiItemViewModel], pageIndex: Int , index: Int) {
        if pageIndex == 1 {
            self.tableViewModels[index].itemList = importantList
        }else{
            self.tableViewModels[index].itemList += importantList
        }
        isImportantLastPage = self.tableViewModels[index].itemList.count < pageSize
        
        onBindTableViewModel?(self.tableViewModels[index])
        setTopPageSheetStatus(notiType: self.tableViewModels[index].notiType)
    }
    
    private func setTopPageSheetStatus(notiType: NotiType) {
        var result = true
        switch notiType {
        case .important:
            
            if let _ = tableViewModels[0].itemList.filter({$0.unreadMark == true}).first {
                result = false
            }
        case .noti:
            
            if let _ = tableViewModels[1].itemList.filter({$0.unreadMark == true}).first {
                result = false
            }
        case .groupNews:
            
            if let _ = tableViewModels[2].itemList.filter({$0.unreadMark == true}).first {
                result = false
            }
        case .airNews:
            
            if let _ = tableViewModels[3].itemList.filter({$0.unreadMark == true}).first {
                result = false
            }
        }
        self.setTopPageSheetStatus?(notiType,result)
    }
}
