//
//  GroupTableViewViewModel.swift
//  ColatourB2B
//
//  Created by 吳思賢 on 2021/6/1.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation

class GroupTableViewViewModel {
    
    enum Section : Int, CaseIterable {
        case BANNER = 0
        case HOMEAD1
        case HOMEAD2
    }
    
    var itemList: [IndexResponse.MultiModule] = [] {
        didSet {
            indexList = itemList.filter{$0.groupName == "首頁1"}.flatMap{$0.moduleList}
            homeAd1List = itemList.filter{$0.groupName == "HomeAd1"}.flatMap{$0.moduleList}
            homeAd2List = itemList.filter{$0.groupName == "HomeAd2"}.flatMap{$0.moduleList}
        }
    }
    
    var numOfSection: Int {
        Section.allCases.count
    }
    
    var tableViewReload: (()->())?
    var onPullToRefresh: (()->())?
    var onTouchItem: ((_ item: IndexResponse.ModuleItem)->())?
    var apiError: ((_ apiError: APIError)->())?
    var groupHeaderViewModel: GroupIndexHeaderImageViewModel?
    var homeAd1ViewModels: [HomeAd1CellViewModel] = []
    var homeAd2ViewModels: [HomeAd2ViewCellViewModel] = []
    
    private var indexList: [IndexResponse.Module] = [] {
        didSet{
            groupHeaderViewModel = GroupIndexHeaderImageViewModel()
            groupHeaderViewModel?.setViewModle(list: indexList.first?.moduleItemList ?? [])
            groupHeaderViewModel?.onTouchItem = { [weak self] item in
                self?.onTouchItem?(item)
            }
        }
    }
    
    private var homeAd1List: [IndexResponse.Module] = [] {
        didSet {
            homeAd1ViewModels = homeAd1List.compactMap { item -> HomeAd1CellViewModel in
                let viewModel = HomeAd1CellViewModel()
                viewModel.setViewModel(item: item)
                viewModel.onTouchItem = { [weak self] item in
                    self?.onTouchItem?(item)
                }
                return viewModel
            }
        }
    }
    
    private var homeAd2List: [IndexResponse.Module] = [] {
        didSet{
            homeAd2ViewModels = homeAd2List.compactMap({ (item) -> HomeAd2ViewCellViewModel in
                let viewModel = HomeAd2ViewCellViewModel()
                viewModel.setViewModel(item: item, isFirst: item == homeAd2List.first, needLogoImage: false)
                viewModel.onTouchHotelAdItem = { [weak self] item in
                    self?.onTouchItem?(item)
                }
                return viewModel
            })
        }
    }
    
    var tourType: TourType?
    
    init(_ type: TourType) {
        self.tourType = type
    }
    
    func setViewModel(list: [IndexResponse.MultiModule]){
        
        self.itemList = list
        self.tableViewReload?()
    }
    
    func onPullToRefreshAction() {
        onPullToRefresh?()
    }
}
