//
//  FirebaseAnalyticsManager.swift
//  colatour
//
//  Created by M7268 on 2019/4/10.
//  Copyright © 2019 Colatour. All rights reserved.
//

import Foundation
import FirebaseAnalytics

class FirebaseAnalyticsManager: NSObject {
    static func setUp(){
        #if DEBUG
        Analytics.setAnalyticsCollectionEnabled(false)
        #else
        Analytics.setAnalyticsCollectionEnabled(true)
        #endif
    }

    /*static func setEvent(_ event: Event, parameters: [EventParameter: Any] = [:], value: Any? = nil) {
        #if DEBUG

        #else
        var parameters: [String: Any] = Dictionary(uniqueKeysWithValues:
            parameters
            .map{ (key: EventParameter, value: Any) in
               ( key.rawValue, value )
        })
        
        if let value = value {
            parameters[AnalyticsParameterValue] = value
        }

        let event = event.rawValue
        Analytics.logEvent(event, parameters: parameters)
        
        #endif
    }
    
    static func setUserProperty(value: String, forName: String){
        #if DEBUG

        #else
        Analytics.setUserProperty(value, forName: forName)
        #endif
    }*/
}
