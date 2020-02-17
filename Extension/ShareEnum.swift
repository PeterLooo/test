//
//  ShareEnum.swift
//  colatour
//
//  Created by M6853 on 2018/11/21.
//  Copyright © 2018 Colatour. All rights reserved.
//

import UIKit

public enum LinkType: String {
    case openAppWebView = "001"
    case openBrowser = "002"
    case getApiUrlThenOpenAppWebView = "003"
    case getApiUrlThenOpenBrowser = "004"
    case salesPage = "011"
    case passwordModify = "031"
    case updateDate = "032"
    case unknown
}

public enum OpenBrowserOrAppWebView {
    case openBrowser
    case openAppWebView
}

public enum NotiType {
    case important
    case noti
    case groupNews
    case airNews
}

public enum ToolBarType {
    case tour
    case tkt
    case other
    
    func getApiUrl() -> APIUrl {
        switch self {
        case .tour:
            return APIUrl.mainApi(type: .toolbarTour)
        case .tkt:
            return APIUrl.mainApi(type: .toolbarTKT)
        case .other:
            return APIUrl.mainApi(type: .toolbarOther)
        }
    }
}

public enum TabBarLinkType: String {
    case tour = "012"
    case ticket = "051"
    case notification = "005"
    case unknown
}

public enum TourType {
    case tour
    case taichung
    case kaohsiung
    case tkt
    
    func getApiUrl() -> APIUrl {
        switch self {
        case .tour:
            return APIUrl.portalApi(type: .groupTourIndex)
        case .taichung:
            return APIUrl.portalApi(type: .groupTaichungIndex)
        case .kaohsiung:
            return APIUrl.portalApi(type: .groupKaohsiungIndex)
        case .tkt:
            return APIUrl.portalApi(type: .tktIndex)
        }
    }
}
    
public class ShareOption {
    var optionKey: String!
    var optionValue: String!
    
    convenience init(optionKey: String, optionValue: String){
        self.init()
        
        self.optionKey = optionKey
        self.optionValue = optionValue
    }
}

//Note: Sswift calendar 星期一到星期日(2,3,4,5,6,7,1)
enum DayOfTheWeek: String {
    case MON = "2"
    case TUE = "3"
    case WED = "4"
    case THU = "5"
    case FRI = "6"
    case SAT = "7"
    case SUN = "1"
    
    func getChinese() -> String {
        switch self {
        case .MON : return "一"
        case .TUE : return "二"
        case .WED : return "三"
        case .THU : return "四"
        case .FRI : return "五"
        case .SAT : return "六"
        case .SUN : return "日"
        }
    }
}
