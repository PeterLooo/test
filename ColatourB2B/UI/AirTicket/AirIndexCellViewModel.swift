//
//  AirIndexCellViewModel.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/7/2.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation

class AirIndexCellViewModel {
    
    var subViewViewModels: [AirIndexViewModel] = []
    var onTouchHotelAdItem: ((_ item: IndexResponse.ModuleItem) -> ())?
    
    func setViewModel(item: IndexResponse.Module) {
        
        item.moduleItemList.forEach { module in
            let moduleInde = item.moduleItemList.firstIndex(of: module)!
            
            if moduleInde % 3 == 0 {
                let subViewModel = AirIndexViewModel()
                subViewModel.setViewModel(item: module, moduleIndex: 0)
                subViewViewModels.append(subViewModel)
            }else {
                switch moduleInde % 3 {
                case 1,2:
                    subViewViewModels.last?.setViewModel(item: module, moduleIndex:  moduleInde % 3)
                default:
                    ()
                }
            }
        }
        
        subViewViewModels.forEach { [weak self] subViewModel in
            subViewModel.onTouchHotelAdItem = {[weak self] item in
                self?.onTouchHotelAdItem?(item)
            }
        }
    }
}
