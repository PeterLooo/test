//
//  ShareEnum.swift
//  colatour
//
//  Created by M6853 on 2018/11/21.
//  Copyright © 2018 Colatour. All rights reserved.
//

import UIKit

public enum LinkType: String {
    case web = "00"
    case getApiUrl = "003"
    case passwordReset = "031"
    case updateDate = "032"
    case openBrowser
    case unknown
}

public enum NotiType {
    case important
    case noti
    case news
    
}

public enum ToolBarType {
    case tour
    case tkt
    case other
    
    func getApiUrl() -> APIUrl {
        switch self {
        case .tour:
            return APIUrl.mainApi(type: .tour)
        case .tkt:
            return APIUrl.mainApi(type: .tkt)
        case .other:
            return APIUrl.mainApi(type: .other)
        }
    }
}
public enum TourType {
    case tour
    case taichung
    case kaohsiung
    
    func getApiUrl() -> APIUrl {
        switch self {
        case .tour:
            return APIUrl.portalApi(type: .groupTourIndex)
        case .taichung:
            return APIUrl.portalApi(type: .groupTaichungIndex)
        case .kaohsiung:
            return APIUrl.portalApi(type: .groupKaohsiungIndex)
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
