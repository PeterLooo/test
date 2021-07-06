//
//  AirPopCityCellViewModel.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/7/2.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation
class AirPopCityCellViewModel {
    
    var moduleTitle: String?
    var subViewViewModels: [AirPopCityViewModel] = []
    var onTouchHotelAdItem:((_ item: IndexResponse.ModuleItem) -> ())?
    
    func setViewModel(item: IndexResponse.Module) {
        
        self.moduleTitle = item.moduleText
        
        item.moduleItemList.forEach { module in
            let moduleIndex = item.moduleItemList.firstIndex(of: module)!
            if moduleIndex % 2 == 0 {
                let subViewModel = AirPopCityViewModel()
                subViewModel.setViewModel(item: module, isFirst: item.moduleItemList.first == module, isLast:  item.moduleItemList.last == module)
                subViewViewModels.append(subViewModel)
            } else {
                subViewViewModels.last?.setSecViewModel(item: module)
            }
        }
        
        subViewViewModels.forEach { subViewModel in
            subViewModel.onTouchHotelAdItem = {[weak self] item in
                self?.onTouchHotelAdItem?(item)
            }
        }
    }
}
