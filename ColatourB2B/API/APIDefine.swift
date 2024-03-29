

import Foundation
import UIKit

let APITimeout: Double = 60.0

#if COLATOURB2B_DEV
let AUTH_WEB_HOST = "https://ntestWebAPIBauth.colatour.com.tw"
let PORTAL_WEB_HOST = "https://ntestwebAPIBportal.colatour.com.tw"
let MEMBER_WEB_HOST = "https://ntestWebAPIBmember.colatour.com.tw"
let MAIN_WEB_HOST = "https://ntestWebAPIBportal.colatour.com.tw/"
let TOUR_SALE_HOST = "https://ntestWebAPIBtoursale.colatour.com.tw"
#else
let AUTH_WEB_HOST = "https://WebAPIBauth.colatour.com.tw"
let PORTAL_WEB_HOST = "https://webAPIBportal.colatour.com.tw"
let MEMBER_WEB_HOST = "https://WebAPIBmember.colatour.com.tw"
let MAIN_WEB_HOST = "https://WebAPIBportal.colatour.com.tw/"
let TOUR_SALE_HOST = "https://WebAPIBtoursale.colatour.com.tw"
#endif

enum APIUrl {
    case authApi(type: AuthApi)
    case portalApi(type: PortalApi)
    case bulletinApi(type: BulletinApi)
    case memberApi(type: MemberApi)
    case mainApi(type: MainApi)
    case serviceApi(type: ServiceApi)
    case noticeApi(type: NoticeApi)
    case tourSaleApi(type: TourSaleApi)
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
        case .tourSaleApi(let type):
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
        case loginFirst = "LoginFirst"
        
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
        case tktIndex = "/Portal/TKT/首頁1"
        case serviceTourWindowList   = "/Service/Tour/WindowList"
        case tourShare = "/main/tour/itinerary/share"
        
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
        case changeCompany = "Company/Initial"
        case changeCompanyAction = "Company/Change"
        case chnegeMemberInfoInit = "Data/Initial"
        case chnegeMemberInfo = "Data/Modify"
        case correctEmailInit = "Email/MemberInfo/Initial"
        case correctEmailSend = "Email/Send"
        case correctEmailConfirm = "Email/Confirm"
        case agent = "Register/Agent"
        case account = "Register/Account"
        case accountInitial = "Register/Account/Initial"
        case register = "Register/AgentData"
        case basicRegister = "Register/AccountData"
        
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
        
        case toolbarTour = "ToolBar/Tour"
        case toolbarTKT = "ToolBar/TKT"
        case toolbarOther = "ToolBar/Other"
        case tourSearchInit = "Tour/Search/Initial"
        case tourSearch = "Tour/Search"
        case tourKeywordSearch = "Tour/Keyword/Search"
        case airTktSearchInit = "AirTicket/Search/Initial/Ticket"
        case sotoAirSearchInit = "AirTicket/Search/Initial/SOTO"
        case lccSearchInit = "Lcc/Search/Initial"
        case airTicketSearchUrl = "AirTicket/Search"
        case lccSearchUrl = "Lcc/Search"
        case airTktLocationKeywordSearch = "AirTicket/Search/Keyword?City_Name="
        case lccLocationKeywordSearch = "Lcc/Search/Keyword?City_Name="
        
        static func urlWith(type: MainApi, append: String) -> String {
            let base =  MAIN_WEB_HOST + "Main/"
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
        
        case messageSend = "Message/Send"
        case contactInformation = "ContactInformation"

        static func urlWith(type: ServiceApi, append: String) -> String {
            let base =  MAIN_WEB_HOST + "Service/"
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
        case notice = "/Notification?"
        case groupNews = "/eDM/TOUR?"
        case airNews = "/eDM/TKT?"
        case important = "/Notification/important?"
        case unreadCount = "/Notification/Unread"
        case setNotiRead = "/Notification/Modify/Status"
        case city = "/Basis/City"
        
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
    
    enum TourSaleApi: String {
        case tourSearchInit = "Tour/Search/Initial"
        
        static func urlWith(type: TourSaleApi, append: String) -> String {
            let base =  TOUR_SALE_HOST + "/Common/"
            return "\(base)\(type.rawValue)\(append)"
        }
        
        func url () -> String {
            return APIUrl.TourSaleApi.urlWith(type: self, append: "")
        }
        
        func url(append:String) -> String {
            return APIUrl.TourSaleApi.urlWith(type: self, append: append)
        }
    }
}

