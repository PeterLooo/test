//
//  GroupAd1ViewModel.swift
//  ColatourB2B
//
//  Created by 吳思賢 on 2021/6/11.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation
import SDWebImage

class HomeAd1CellViewModel {
    
    var onTouchItem: ((_ adItem: IndexResponse.ModuleItem)->())?
    var subViewViewModels: [HomeAd1ViewModel] = []
    var moduleTitle: String?
    
    func setViewModel(item: IndexResponse.Module){
        moduleTitle = item.moduleText
        item.moduleItemList.forEach { (module) in
            let subViewModel = HomeAd1ViewModel()
            subViewModel.setViewModel(item: module, isFirst: item.moduleItemList.first == module, isLast: item.moduleItemList.last == module)
            subViewModel.onTouchHotelAdItem = { [weak self] in
                self?.onTouchItem?(module)
            }
            subViewViewModels.append(subViewModel)
        }
    }
}

class HomeAd1ViewModel {
    
    var onTouchHotelAdItem:(()->())?
    
    var viewLeading: CGFloat?
    var viewTrailing: CGFloat?
    
    var itemContent: String?
    var itemPrice: String?
    private var picUrl: String?
    
    func setViewModel(item: IndexResponse.ModuleItem, isFirst: Bool, isLast: Bool){
        viewLeading = isFirst ? 16:0
        viewTrailing = isLast ? 16:0
        picUrl = item.picUrl
        itemContent = item.itemText
        let priceFormat = FormatUtil.priceFormat(price: item.itemPrice)
        itemPrice = item.itemPrice == 0 ? "" : "\(priceFormat)起"
    }
    
    func downImage(complition: @escaping (UIImage?)->()) {
        SDWebImageManager.shared.loadImage(with: URL(string: picUrl!), options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (image, data, error, cacheType, bool, imageURL) in
            complition(image)
        })
    }
}
