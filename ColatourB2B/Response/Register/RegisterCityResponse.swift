//
//  RegisterCityResponse.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/12/8.
//  Copyright © 2021 Colatour. All rights reserved.
//
import UIKit
import ObjectMapper

class RegisterCityResponse: BaseModel {
    
    var cityList: [CityListModel]?
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        cityList <- map["City_List"]
    }
    
    class CityListModel: BaseModel {
        
        var zoneName: String?
        var zoneCode: String?
        var zoneList: [RegisterZoneListModel]?
        
        override init() {
            super.init()
        }
        
        required init?(map: Map) {
            super.init(map: map)
        }
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            
            zoneName <- map["Zone_Name"]
            zoneCode <- map["Zone_Code"]
            zoneList <- map["Zone_List"]
        }
    }

    class RegisterZoneListModel: BaseModel {
        
        var zoneName: String?
        var zoneCode: String?
        
        override init() {
            super.init()
        }
        
        required init?(map: Map) {
            super.init(map: map)
        }
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            
            zoneName <- map["Zone_Name"]
            zoneCode <- map["Zone_Code"]
        }
    }
}
