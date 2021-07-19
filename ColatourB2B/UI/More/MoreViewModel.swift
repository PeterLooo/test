//
//  MoreViewModel.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/7/7.
//  Copyright © 2021 Colatour. All rights reserved.
//

import RxSwift

class MoreViewModel: BaseViewModel {
    
    var reloadTableView: (()->())?
    
    private let groupRepository = GroupReponsitory.shared
    private let disposeBag = DisposeBag()
    
    var serverCellViewModel: [MemberIndexServiceCellViewModel] = []
    
    func getOtherToolBarList() {
        self.onStartLoadingHandle?(.coverPlateAlpha)
        groupRepository
            .getGroupMenu(toolBarType: .other)
            .subscribe(onSuccess: { [weak self] model in
                let serverList = model.serverList.flatMap{($0)}
                self?.onBindOtherToolBarList(serverList: serverList)
                self?.onCompletedLoadingHandle?()
            }, onError: { [weak self] error in
                self?.onApiErrorHandle?(error as! APIError, .coverPlate)
                self?.onCompletedLoadingHandle?()
            }).disposed(by: disposeBag)
    }
    
    func onBindOtherToolBarList(serverList: [ServerData]) {
        serverCellViewModel = []
        serverCellViewModel = serverList.compactMap({MemberIndexServiceCellViewModel(serverData: $0)})
        serverCellViewModel.forEach { (serverViewModel) in
            serverViewModel.onTouchServer = { [weak self] in
                guard let server = serverViewModel.serverData else {return}
                self?.handleLinkType?(server.linkType,server.linkValue,server.linkName,nil)
            }
        }
        reloadTableView?()
    }
}
