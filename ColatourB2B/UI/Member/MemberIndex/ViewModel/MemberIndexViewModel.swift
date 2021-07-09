//
//  MemberIndexViewModel.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/7/7.
//  Copyright © 2021 Colatour. All rights reserved.
//

import RxSwift

class MemberIndexViewModel: BaseViewModel {
    
    var reloadTableView: (()->())?
    
    enum Section {
        
        case headerCell(MemberIndexHeaderCellViewModel)
        case serverCell([MemberIndexServiceCellViewModel])
        case versionCell
    }
    
    var sections: [Section] = []
    
    private let dispose = DisposeBag()
    private let accountRepository = AccountRepository.shared
    
    func getMemberIndex(){
        self.onStartLoadingHandle?( .ignore)
        accountRepository.getMemberIndex().subscribe(onSuccess: { [weak self] (model) in
            
            self?.onBindMemberIndex(model)
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            
            self?.onApiErrorHandle?(error as! APIError, .toast)
            self?.onCompletedLoadingHandle?()
            
        }).disposed(by:dispose)
    }
    
    func memberLogout(){
        let _ = accountRepository.memberLogout().subscribe()
        UserDefaultUtil.shared.accessToken = ""
        UserDefaultUtil.shared.refreshToken = ""
        NotificationCenter.default.post(name: Notification.Name("noticeLoadDate"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("getUnreadCount"), object: nil)
        getMemberIndex()
    }
    
    func onBindMemberIndex(_ response: MemberIndexResponse){
        sections = []
        sections.append(Section.headerCell(getHeaderViewModel(name: response.memeberName!)))
        sections.append(Section.serverCell(getServerViewModel(memberIndexList: response.memberIndexList)))
        sections.append(Section.versionCell)
        self.reloadTableView?()
    }
    
    func getHeaderViewModel(name: String) -> MemberIndexHeaderCellViewModel {
        let headerViewModel = MemberIndexHeaderCellViewModel(name: name)
        headerViewModel.onTouchLogout = {[weak self] in
            self?.memberLogout()
        }
        return headerViewModel
    }
    
    func getServerViewModel(memberIndexList: [ServerData]) -> [MemberIndexServiceCellViewModel] {
        let servers = memberIndexList.map({MemberIndexServiceCellViewModel(serverData: $0)})
        servers.forEach { (serverViewModel) in
            serverViewModel.onTouchServer = { [weak self] in
                guard let server = serverViewModel.serverData else {return}
                self?.handleLinkType?(server.linkType,server.linkValue,server.linkName,nil)
            }
        }
        return servers
    }
}
