//
//  GroupTourViewModel.swift
//  ColatourB2B
//
//  Created by 吳思賢 on 2021/5/28.
//  Copyright © 2021 Colatour. All rights reserved.
//

import RxSwift

class GroupTourViewModel: BaseViewModel {
    
    var onBindTourIndex: ((_ moduleDataList: [IndexResponse.MultiModule],_ tourType: TourType)->())?
    var onBindGroupMenu: ((_ menu: GroupMenuResponse) ->())?
    var setTableViews:((_ viewModel: GroupTableViewViewModel)->())?
    var onGetGroupMenuError: (() -> ())?
    var presentVersionVC: ((_ vc: UIViewController) -> ())?
    var presentBullentinVC: ((_ vc: UIViewController) -> ())?
    
    let accountRepositouy = AccountRepository.shared
    let groupReponsitory = GroupReponsitory.shared
    let tableViewModles = [GroupTableViewViewModel(.tour),
                           GroupTableViewViewModel(.kaohsiung),
                           GroupTableViewViewModel(.taichung)]
    var focusOnType: TourType?
    var focusOnView: ((_ type: TourType)->())?
    
    fileprivate var dispose = DisposeBag()
    
// MARK: Api
    
    func getApiToken(){
        
        self.onStartLoadingHandle?(.coverPlate)
        accountRepositouy.apiToken.subscribe(onSuccess: { [weak self] (_) in
            self?.getAccessToken()
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.getAccessToken()
            self?.onCompletedLoadingHandle?()
        }).disposed(by: dispose)
    }
    
    func getAccessToken() {
        self.onStartLoadingHandle?(.ignore)
        accountRepositouy.getAccessToken().subscribe(onSuccess: { [weak self] (_) in
            self?.getVersionRule()
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.onApiErrorHandle?( error as! APIError, .coverPlate)
            self?.onCompletedLoadingHandle?()
        }).disposed(by: dispose)
    }
    
    func getVersionRule() {
        
        accountRepositouy.getVersionRule().subscribe(onSuccess: { [weak self] (model) in
            self?.onBindVersionRule(versionRule: model)
            
        }, onError: { [weak self] (error) in
            self?.getBulletin()
            self?.getAllMenu()
            self?.onApiErrorHandle?( error as! APIError, .custom)
            
        }).disposed(by: dispose)
    }
    
    func getBulletin() {
        
        accountRepositouy.getBulletin().subscribe(onSuccess: { [weak self] (model) in
            self?.onBindBulletin(bulletin: model)
            
        }, onError: { [weak self] (error) in
            self?.onApiErrorHandle?( error as! APIError, .custom)
            
        }).disposed(by: dispose)
    }
    
    func getTourIndex(tourType: TourType) {
        self.onStartLoadingHandle?(.coverPlate)
        
        groupReponsitory.getTourIndex(tourType: tourType).subscribe(onSuccess: { [weak self] (model) in
            self?.onBindTourIndex(moduleDataList: model.moduleDataList, tourType: tourType)
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.tableViewModles.forEach({ tableViewModel in
                if tableViewModel.tourType == tourType {
                    self?.setTableViews?(tableViewModel)
                    tableViewModel.apiError?(error as! APIError)
                }
            })
            
            self?.onApiErrorHandle?(error as! APIError, .custom)
            self?.onCompletedLoadingHandle?()
        }).disposed(by: dispose)
    }
    
    func onBindTourIndex (moduleDataList: [IndexResponse.MultiModule], tourType: TourType) {
        tableViewModles.forEach({
            
            if $0.tourType == tourType {
                self.setTableViews?($0)
                $0.setViewModel(list: moduleDataList)
            }
        })
    }
    
    func getGroupMenu(toolBarType: ToolBarType) {
        self.onStartLoadingHandle?( .ignore)
        
        groupReponsitory.getGroupMenu(toolBarType: toolBarType).subscribe(onSuccess: { [weak self] (model) in
            self?.onBindGroupMenu?( model)
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.onGetGroupMenuError?()
            self?.onApiErrorHandle?(error as! APIError, .custom)
            self?.onCompletedLoadingHandle?()
        }).disposed(by: dispose)
    }
    
    func getAllMenu() {
        self.getGroupMenu(toolBarType: .tour)
        self.getTourIndex(tourType: .tour)
        self.getTourIndex(tourType: .taichung)
        self.getTourIndex(tourType: .kaohsiung)
    }
    
    func onBindVersionRule(versionRule: VersionRuleReponse.Update?) {
        if versionRule == nil {
            getBulletin()
            getAllMenu()
            NotificationCenter.default.post(name: Notification.Name("getUnreadCount"), object: nil)
            return
        }
        
        if let updateNo = UserDefaultUtil.shared.updateNo, updateNo >= versionRule!.updateNo! {
            getBulletin()
            getAllMenu()
            NotificationCenter.default.post(name: Notification.Name("getUnreadCount"), object: nil)
            return
        }
        
        let sb = UIStoryboard(name: "VersionRule", bundle:nil)
        let vca = sb.instantiateViewController(withIdentifier: "VersionRuleViewController") as! VersionRuleViewController
        vca.modalPresentationStyle = .overFullScreen
        vca.setVersionRule(versionRule: versionRule!)
        vca.onDismissVersionRuleViewControllerCompletion = { [weak self] in
            self?.getBulletin()
            self?.getAllMenu()
            NotificationCenter.default.post(name: Notification.Name("getUnreadCount"), object: nil)
        }
        self.presentVersionVC?(vca)
    }
    
    func onBindBulletin(bulletin: BulletinResponse.Bulletin?) {
        if bulletin == nil {
            return
        }
        
        if let bulletinNo = UserDefaultUtil.shared.bulletinNo, bulletinNo >= bulletin!.bulletinNo! {
            return
        }
        
        let sb = UIStoryboard(name: "Bulletin", bundle:nil)
        let vca = sb.instantiateViewController(withIdentifier: "BulletinViewController") as! BulletinViewController
        vca.modalPresentationStyle = .overFullScreen
        vca.onTouchBulletinLink = { [weak self] linkType, linkValue, linkText in
            self?.handleLinkType?(linkType,linkValue,linkText, nil)
        }
        vca.setVCWith(bulletin: bulletin!)
        presentBullentinVC?(vca)
        UserDefaultUtil.shared.bulletinNo = bulletin!.bulletinNo ?? 0
    }
    
    func switchPageButton(sliderLeading: CGFloat){
        switch sliderLeading {
        case (screenWidth / 3 * 0):
            focusOnType = .tour

        case (screenWidth / 3 * 1):
            focusOnType = .taichung
            
        case (screenWidth / 3 * 2):
            focusOnType = .kaohsiung
            
        default:
            ()
        }
        focusOnView?(focusOnType ?? .tour)
    }
}
