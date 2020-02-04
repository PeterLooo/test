

import Foundation
import UIKit

let APITimeout: Double = 60.0

#if COLATOURB2B_DEV
let AUTH_WEB_HOST = "https://ntestWebAPIBauth.colatour.com.tw"
let PORTAL_WEB_HOST = "https://ntestwebapibportal.colatour.com.tw"
let MEMBER_WEB_HOST = "https://ntestWebAPIBmember.colatour.com.tw/"
let MAIN_WEB_HOST = "https://ntestWebAPIBportal.colatour.com.tw/"
#else
let AUTH_WEB_HOST = "https://WebAPIBauth.colatour.com.tw"
let PORTAL_WEB_HOST = "https://webapicportal.colatour.com.tw"
let MEMBER_WEB_HOST = "https://WebAPIBmember.colatour.com.tw/"
let MAIN_WEB_HOST = "https://WebAPIBportal.colatour.com.tw/"
#endif

enum APIUrl {
    case authApi(type: AuthApi)
    case portalApi(type: PortalApi)
    case bulletinApi(type: BulletinApi)
    case memberApi(type: MemberApi)
    case mainApi(type: MainApi)
    case serviceApi(type: ServiceApi)
    case noticeApi(type: NoticeApi)
    func getUrl() -> String {
        switch self {
        case .authApi(let type):
            return type.url()
        case .portalApi(let type):
            return type.url()
        case .bulletinApi(let type):
            return type.url()
        case .memberApi(let type):
            return type.url()
        case .mainApi(let type):
            return type.url()
        case .serviceApi(let type):
            return type.url()
        case .noticeApi(let type):
            return type.url()
        }
    }
    
    enum AuthApi: String {
        case apiToken = "api-token"
        case refreshToken = "refresh-token"
        case accessToken = "access-token"
        case pushDevice   = "PushDevice"
        case versionRule = "VersionRule"
        case logout = "logout"
        case accessWeb = "AccessWeb"
        
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

        case groupTourIndex   = "/Portal/Tour/首頁1"
        case groupTaichungIndex   = "/Portal/Taichung/首頁1"
        case groupKaohsiungIndex   = "/Portal/Kaohsiung/首頁1"
        case serviceTourWindowList   = "/Service/Tour/WindowList"

        static func urlWith(type: PortalApi, append: String) -> String {
            let base =  PORTAL_WEB_HOST
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
            let base = PORTAL_WEB_HOST + "/Bulletin/"
            return "\(base)\(type.rawValue)\(append)"
        }
        func url () -> String {
            return APIUrl.BulletinApi.urlWith(type: self, append: "")
        }
        
        func url(append:String) -> String {
            return APIUrl.BulletinApi.urlWith(type: self, append: append)
        }
    }
    
    enum MemberApi: String {
        
        case memberIndex = "Index"
        case passwordModify = "Password/Modify"
        case noticeDetail = "noticeDetail"
        
        static func urlWith(type: MemberApi, append:String) -> String {
            let base =  MEMBER_WEB_HOST + "/Member/"
            return "\(base)\(type.rawValue)\(append)"
        }
        
        func url () -> String {
            return APIUrl.MemberApi.urlWith(type: self, append: "")
        }
        
        func url(append:String) -> String {
            return APIUrl.MemberApi.urlWith(type: self, append: append)
        }
    }
    
    enum MainApi: String{
        
        case tour = "Tour"
        case tkt = "TKT"
        case other = "Other"
        
        static func urlWith(type: MainApi, append: String) -> String {
            let base =  MAIN_WEB_HOST + "Main/ToolBar/"
            return "\(base)\(type.rawValue)\(append)"
        }
        func url () -> String {
            return APIUrl.MainApi.urlWith(type: self, append: "")
        }
        
        func url(append:String) -> String {
            return APIUrl.MainApi.urlWith(type: self, append: append)
        }
    }
    
    enum ServiceApi: String {
        
        case messageSend = "Send"

        static func urlWith(type: ServiceApi, append: String) -> String {
            let base =  MAIN_WEB_HOST + "Service/Message/"
            return "\(base)\(type.rawValue)\(append)"
        }
        
        func url() -> String {
            return APIUrl.ServiceApi.urlWith(type: self, append: "")
        }
        
        func url(append: String) -> String {
            return APIUrl.ServiceApi.urlWith(type: self, append: append)
        }
    }
    
    enum NoticeApi: String {
        case notice = "Notification?"
        case news = "eDM/Tour?"
        case important = "Notification/important?"
        case unreadCount = "/Notification/Unread"
        case setNotiRead = "/Notification/Modify/Status"
        
        static func urlWith(type: NoticeApi, append: String) -> String {
            let base =  MEMBER_WEB_HOST
            return "\(base)\(type.rawValue)\(append)"
        }
        
        func url () -> String {
            return APIUrl.NoticeApi.urlWith(type: self, append: "")
        }
        
        func url(append:String) -> String {
            return APIUrl.NoticeApi.urlWith(type: self, append: append)
        }
    }
}

