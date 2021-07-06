//
//  AirIndexViewModel.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/7/2.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation

class  AirIndexViewModel {
    
    var adItem: IndexResponse.ModuleItem?
    var adSecItem: IndexResponse.ModuleItem?
    var adThrItem: IndexResponse.ModuleItem?
    
    var onTouchHotelAdItem: ((_ item: IndexResponse.ModuleItem) -> ())?
    
    func setViewModel(item: IndexResponse.ModuleItem, moduleIndex: Int) {
        
        switch moduleIndex {
        
        case 0:
            self.adItem = item
            
        case 1:
            self.adSecItem = item
            
        case 2:
            self.adThrItem = item
            
        default:
            ()
        }
    }
    func onTouchItem(tag: Int) {
        
        switch tag {
        case 0:
            onTouchHotelAdItem?(adItem ?? IndexResponse.ModuleItem())
        case 1:
            onTouchHotelAdItem?(adSecItem ?? IndexResponse.ModuleItem())
        case 2:
            onTouchHotelAdItem?(adThrItem ?? IndexResponse.ModuleItem())
        default:
            ()
        }
    }
}
