//
//  WebViewTourShareResponse.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2020/2/26.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
import ObjectMapper

class WebViewTourShareResponse: BaseModel {
    
    var itineraryShareData : ItineraryShareData?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        itineraryShareData <- map["ItineraryShare_Data"]
        
    }
    
    class ItineraryShareData : BaseModel {
        
        var bookingUrl : String?
        var forwardUrl : String?
        var shareInfo : String?
        var shareUrl : String?
        var wordUrl : String?
        var contactInfo : String?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            bookingUrl <- map["Booking_Url"]
            forwardUrl <- map["Forward_Url"]
            shareInfo <- map["Share_Info"]
            shareUrl <- map["Share_Url"]
            wordUrl <- map["Word_Url"]
            contactInfo <- map["Contact_Info"]
            
        }
    }
}
