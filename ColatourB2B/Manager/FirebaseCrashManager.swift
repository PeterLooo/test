//
//  FirebaseAnalyticsManager.swift
//  colatour
//
//  Created by M7268 on 2019/4/10.
//  Copyright © 2019 Colatour. All rights reserved.
//

import Foundation
import FirebaseCrashlytics
import Alamofire

class FirebaseCrashManager: NSObject {

    static func setUp(){
//        #if DEBUG
//
//        #else
//

        FirebaseCrashManager.setUserIdentifier(AccountRepository.shared.osUUID)
//        #endif
    }
    
    static func recordError(_ err: APIError, api: APIUrl, method: HTTPMethod){
//        #if DEBUG
//
//        #else
        Crashlytics.crashlytics().record(error: err)
        FirebaseCrashManager.setUserName("ErrorType", value: err.type)
        FirebaseCrashManager.setUserName("Api", value: api.getUrl())
        FirebaseCrashManager.setUserName("Method", value: method)
//        #endif
    }
    
    static func setUserName(_ key: String, value: Any){
//        #if DEBUG
//
//        #else
        Crashlytics.crashlytics().setCustomValue(value, forKey: key)
//        #endif
    }
    
    static func setUserIdentifier(_ userId: String){
//        #if DEBUG
//
//        #else
        Crashlytics.crashlytics().setUserID(userId)
//        #endif
    }
}
