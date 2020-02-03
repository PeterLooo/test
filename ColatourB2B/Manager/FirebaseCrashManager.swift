//
//  FirebaseAnalyticsManager.swift
//  colatour
//
//  Created by M7268 on 2019/4/10.
//  Copyright © 2019 Colatour. All rights reserved.
//

import Foundation
import Fabric
import Crashlytics
import Alamofire

class FirebaseCrashManager: NSObject {

    static func setUp(){
        #if DEBUG
        
        #else
        Fabric.with([Crashlytics()])
        FirebaseCrashManager.setUserIdentifier(AccountRepository.shared.osUUID)
        #endif
    }
    
    static func recordError(_ err: APIError, api: APIUrl, method: HTTPMethod){
        #if DEBUG
        
        #else
        Crashlytics.sharedInstance().recordError(err, withAdditionalUserInfo: [
            "ErrorType": err.type,
            "Api": api.getUrl(),
            "Method": method
            ])
        #endif
    }
    
    static func setUserName(_ name: String){
        #if DEBUG
        
        #else
        Crashlytics.sharedInstance().setUserName(name)
        #endif
    }
    
    static func setUserIdentifier(_ userId: String){
        #if DEBUG
        
        #else
        Crashlytics.sharedInstance().setUserIdentifier(userId)
        #endif
    }
}
