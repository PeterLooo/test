

import Foundation
import UIKit

let APITimeout: Double = 60.0

#if COLATOURB2B_DEV
let AUTH_WEB_HOST = "https://ntestWebAPICauth.colatour.com.tw"
let PORTAL_WEB_HOST = "https://ntestwebapicportal.colatour.com.tw"

#else
let AUTH_WEB_HOST = "https://webAPICauth.colatour.com.tw"
let PORTAL_WEB_HOST = "https://webAPICportal.colatour.com.tw"

#endif

enum APIUrl {
    case authApi(type: AuthApi)
    case portalApi(type: PortalApi)
    case bulletinApi(type: BulletinApi)
    
    func getUrl() -> String {
        switch self {
        case .authApi(let type):
            return type.url()
        case .portalApi(let type):
            return type.url()
        case .bulletinApi(let type):
            return type.url()
        }
    }
    
    enum AuthApi: String {
        case apiToken = "api-token"
        case memberToken = "member-token"
        case versionRule = "VersionRule"
        case paxToken = "pax-token"
        case logout = "logout"
        
        static func urlWith(type: AuthApi, append:String) -> String {
            let base =  AUTH_WEB_HOST + "/auth/"
            return "\(base)\(type.rawValue)\(append)"
        }
        
        func url () -> String {
            return APIUrl.AuthApi.urlWith(type: self, append: "")
        }
        
        func url(append:String) -> String {
            return APIUrl.AuthApi.urlWith(type: self, append: append)
        }
    }
    
    enum PortalApi: String {
        case homeAdList   = "Ticket/首頁1"
        case pushDevice   = "notice/push"
        
        static func urlWith(type: PortalApi, append: String) -> String {
            let base =  PORTAL_WEB_HOST + "/Portal/"
            return "\(base)\(type.rawValue)\(append)"
        }
        
        func url () -> String {
            return APIUrl.PortalApi.urlWith(type: self, append: "")
        }
        
        func url(append:String) -> String {
            return APIUrl.PortalApi.urlWith(type: self, append: append)
        }
    }
    
    enum BulletinApi: String{
        
        case bulletin = "AutoDispalyBulletin"
        case noticeBulletin = ""
        
        static func urlWith(type: BulletinApi, append: String) -> String {
            let base =  PORTAL_WEB_HOST + "/Bulletin/"
            return "\(base)\(type.rawValue)\(append)"
        }
        func url () -> String {
            return APIUrl.BulletinApi.urlWith(type: self, append: "")
        }
        
        func url(append:String) -> String {
            return APIUrl.BulletinApi.urlWith(type: self, append: append)
        }
    }
}

