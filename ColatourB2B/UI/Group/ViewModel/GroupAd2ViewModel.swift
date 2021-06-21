//
//  GroupAd2ViewModel.swift
//  ColatourB2B
//
//  Created by 吳思賢 on 2021/6/11.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation
import UIKit

class HomeAd2SubViewModel {
    
    var onTouchHotelAdItem: (()->())?
    
    var itemText: String?
    var itemPromotion: String?
    var itemPrice: String?
    
    private var needLogoImage: Bool?
    private var picUrl: String?
    
    func setViewModle(item: IndexResponse.ModuleItem, needLogoImage: Bool) {

        self.itemText = item.itemText
        self.itemPromotion = item.itemPromotion.isNilOrEmpty == false ? "  \(item.itemPromotion ?? "")  ":""
        
        let priceFormat = FormatUtil.priceFormat(price: item.itemPrice)
        self.itemPrice = item.itemPrice != 0 ? "同業 \(priceFormat)起":""
        self.needLogoImage = needLogoImage
        self.picUrl = item.picUrl
    }
    
    func setImage(completed: @escaping (String?, CGFloat) ->()) {
        if needLogoImage == true && picUrl.isNilOrEmpty == false {
            completed(picUrl,20)
        }else{
            completed(nil,0)
        }
    }
}

class HomeAd2ViewCellViewModel {
    
    var onTouchHotelAdItem: ((_ adItem: IndexResponse.ModuleItem)->())?
    
    var moduleText: String?
    var topConstant: CGFloat?
    
    var subViewModels: [HomeAd2SubViewModel] = []
    
    func setViewModel(item:IndexResponse.Module, isFirst: Bool, needLogoImage: Bool){
        moduleText = item.moduleText
        topConstant = isFirst ? 40 : 0
        item.moduleItemList.forEach { [weak self] (module) in
            let subViewModel = HomeAd2SubViewModel()
            subViewModel.setViewModle(item: module, needLogoImage: needLogoImage)
            subViewModel.onTouchHotelAdItem = { [weak self] in
                self?.onTouchHotelAdItem?(module)
            }
            self?.subViewModels.append(subViewModel)
        }
    }
}
