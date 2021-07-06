//
//  AirTicketViewModel.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/7/2.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation
import RxSwift

class AirTicketViewModel: BaseViewModel {
    
    var menuList : GroupMenuResponse?
    var airIndexCellViewModels: [AirIndexCellViewModel] = []
    var airPopCityCellViewModels: [AirPopCityCellViewModel] = []
    var homeAd1CellViewModels: [HomeAd1CellViewModel] = []
    var homeAd2ViewModels: [HomeAd2ViewCellViewModel] = []
    
    var reloadData: (() -> ())?
    var endRefreshing: (() -> ())?
    var onTouchHotelAdItem: ((_ item: IndexResponse.ModuleItem) -> ())?
    
    private var itemList: [IndexResponse.MultiModule] = [] {
        didSet {
            indexList = itemList.filter{$0.groupName == "首頁1"}.flatMap{$0.moduleList}
            airPopCityList = itemList.filter{$0.groupName == "HomeAd1"}.flatMap{$0.moduleList}
            homeAd2List = itemList.filter{$0.groupName == "HomeAd2"}.flatMap{$0.moduleList}
            homeAd3List = itemList.filter{$0.groupName == "HomeAd3"}.flatMap{$0.moduleList}
            reloadData?()
        }
    }
    
    private var indexList: [IndexResponse.Module] = [] {
        didSet {
            airIndexCellViewModels = indexList.compactMap { item -> AirIndexCellViewModel in
                let viewModel = AirIndexCellViewModel()
                viewModel.setViewModel(item: item)
                viewModel.onTouchHotelAdItem = { [weak self] item in
                    self?.onTouchHotelAdItem?(item)
                }
                return viewModel
            }
        }
    }
    private var airPopCityList: [IndexResponse.Module] = [] {
        didSet {
            airPopCityCellViewModels = airPopCityList.compactMap { item -> AirPopCityCellViewModel in
                let viewModel = AirPopCityCellViewModel()
                viewModel.setViewModel(item: item)
                viewModel.onTouchHotelAdItem = {[weak self] item in
                    self?.onTouchHotelAdItem?(item)
                }
                return viewModel
            }
        }
    }
    private var homeAd2List: [IndexResponse.Module] = [] {
        didSet {
            homeAd1CellViewModels = homeAd2List.compactMap { item -> HomeAd1CellViewModel in
                let viewModel = HomeAd1CellViewModel()
                viewModel.setViewModel(item: item)
                viewModel.onTouchItem = { [weak self] item in
                    self?.onTouchHotelAdItem?(item)
                }
                return viewModel
            }
        }
    }
    private var homeAd3List: [IndexResponse.Module] = [] {
        didSet{
            homeAd2ViewModels = homeAd3List.compactMap({ (item) -> HomeAd2ViewCellViewModel in
                let viewModel = HomeAd2ViewCellViewModel()
                viewModel.setViewModel(item: item, isFirst: item == homeAd2List.first, needLogoImage: false)
                viewModel.onTouchHotelAdItem = { [weak self] item in
                    self?.onTouchHotelAdItem?(item)
                }
                return viewModel
            })
        }
    }
    
    fileprivate let groupReponsitory = GroupReponsitory.shared
    fileprivate var dispose = DisposeBag()
    
    func getAirMenu() {
        
        onStartLoadingHandle?(.coverPlate)
        groupReponsitory.getGroupMenu(toolBarType: .tkt).subscribe(onSuccess: { [weak self] (model) in
            self?.onBindAirMenu(menu: model)
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.onGetAirMenuError()
            self?.onApiErrorHandle?((error as! APIError), .custom)
            self?.onCompletedLoadingHandle?()
        }).disposed(by: dispose)
    }
    
    func getAirTicketIndex() {
        
        onStartLoadingHandle?(.coverPlate)
        groupReponsitory.getTourIndex(tourType: .tkt).subscribe(onSuccess: { [weak self] (model) in
            self?.onBindAirTicketIndex(moduleDataList: model.moduleDataList)
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.onBindAirTicketIndexError()
            self?.onApiErrorHandle?((error as! APIError), .coverPlate)
            self?.onCompletedLoadingHandle?()
        }).disposed(by: dispose)
    }
    
    func onBindAirMenu(menu: GroupMenuResponse) {
        self.menuList = menu
    }
    
    func onGetAirMenuError() {
        self.menuList = nil
    }
    
    func onBindAirTicketIndex(moduleDataList: [IndexResponse.MultiModule]) {
        self.itemList = moduleDataList
        endRefreshing?()
    }
    
    func onBindAirTicketIndexError(){
        self.itemList = []
        endRefreshing?()
    }
}
