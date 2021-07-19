//
//  AirPopCityViewModel.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/7/2.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation

class AirPopCityViewModel {
    
    var adItem: IndexResponse.ModuleItem?
    var adSecItem: IndexResponse.ModuleItem?
    var isFirst: Bool?
    var isLast: Bool?
    
    var onTouchHotelAdItem:((_ item: IndexResponse.ModuleItem) -> ())?
    
    func setViewModel(item: IndexResponse.ModuleItem, isFirst: Bool, isLast: Bool) {
        
        self.adItem = item
        self.isFirst = isFirst
        self.isLast = isLast
    }
    
    func setSecViewModel(item: IndexResponse.ModuleItem) {
        
        self.adSecItem = item
    }
    
    func onTouchAdView() {
        
        onTouchHotelAdItem?(adItem!)
    }
    
    func onTouchSecAdView() {
        
        onTouchHotelAdItem?(adSecItem!)
    }
}
