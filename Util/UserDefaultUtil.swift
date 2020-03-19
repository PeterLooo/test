//
//  UserDefaultUtil.swift
//  colatour
//
//  Created by AppDemo on 2018/1/9.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit

enum UserDefaultKey: String {
    case uuid = "UUID"
    case apiToken = "API_TOKEN"
    case refreshToken = "REFRESH_TOLEN"
    case accessToken = "ACCESS_TOKEN"
    case employeeMark = "EMPLOYEE_MARK"
    case allowTour = "ALLOW_TOUR"
    case allowTkt = "ALLOW_TKT"
    case tabBarLinkType = "TAB_BAR_LINK_TYPE"
    case leaveAppTicketIndexTime = "LEAVE_APP_TICKET_INDEX_TIME"
    case leaveAppColatourIndexTime = "LEAVE_APP_CALATOUR_INDEX_TIME"
    case traceLastReceiveTime = "TRACE_LAST_RECEIVE_TIME"
    case firebaseToken = "FIREBASE_TOKEN"
    case updateNo = "UPDATE_NO"
    case bulletinNo = "BULLETIN_NO"
    case lastestIntroductionVersion = "LASTEST_INTRODUCTION_VERSION"
    
}

class UserDefaultUtil: NSObject {
    static var shared = UserDefaultUtil()
    
    var uuid: String? {
        get {
            return getObject(classType: String(), key: .uuid)
        }
        set(uuid){
            update(object: uuid, key: .uuid)
        }
    }
    
    var apiToken: String? {
        get{
            return getObject(classType: String(), key: .apiToken)
        }
        set(apiToken){
            update(object: apiToken, key: .apiToken)
        }
    }
    
    var refreshToken: String? {
        get{
            return getObject(classType: String(), key: .refreshToken)
        }
        set(memberNo){
            update(object: memberNo, key: .refreshToken)
        }
    }
    
    var accessToken: String? {
        get{
            return getObject(classType: String(), key: .accessToken)
        }
        set(memberToken){
            update(object: memberToken, key: .accessToken)
        }
    }
    
    var employeeMark: Bool? {
        get {
            return getObject(classType: Bool(), key: .employeeMark)
        }
        set(employeeMark) {
            update(object: employeeMark, key: .employeeMark)
            NotificationCenter.default.post(name: Notification.Name("getEmployeeMark"), object: nil)
        }
    }
    
    var allowTour: Bool? {
        get {
            return getObject(classType: Bool(), key: .allowTour)
        }
        set(allowTour) {
            update(object: allowTour, key: .allowTour)
        }
    }
    
    var allowTkt: Bool? {
        get {
            return getObject(classType: Bool(), key: .allowTkt)
        }
        set(allowTkt) {
            update(object: allowTkt, key: .allowTkt)
        }
    }
    
    var tabBarLinkType: String? {
        get {
            return getObject(classType: String(), key: .tabBarLinkType)
        }
        set(tabBarLinkType) {
            update(object: tabBarLinkType, key: .tabBarLinkType)
        }
    }
    
    var leaveAppTicketIndexTime: Date? {
        get{
            return getObject(classType: Date(), key: .leaveAppTicketIndexTime)
        }
        set(leaveAppTime){
            update(object: leaveAppTime, key: .leaveAppTicketIndexTime)
        }
    }
    
    var leaveAppColatourIndexTime: Date? {
        get{
            return getObject(classType: Date(), key: .leaveAppColatourIndexTime)
        }
        set(leaveAppTime){
            update(object: leaveAppTime, key: .leaveAppColatourIndexTime)
        }
    }
    
    var traceLastReceiveTime: Date? {
        get{
            return getObject(classType: Date(), key: .traceLastReceiveTime)
        }
        set(traceLastReceiveTime){
            update(object: traceLastReceiveTime, key: .traceLastReceiveTime)
        }
    }
    
    var firebaseToken: String? {
        get{
            return getObject(classType: String(), key: .firebaseToken)
        }
        set(firebaseToken){
            update(object: firebaseToken, key: .firebaseToken)
        }
    }
    
    var updateNo: Int? {
        get{
            return getObject(classType: Int(), key: .updateNo)
        }
        set(updateNo){
            update(object: updateNo, key: .updateNo)
        }
    }
    
    var bulletinNo: Int? {
        get{
            return getObject(classType: Int(), key: .bulletinNo)
        }
        set(bulletinNo){
            update(object: bulletinNo, key: .bulletinNo)
        }
    }
    
    private func update(object: Any?, key: UserDefaultKey) {
        let userDefaults = UserDefaults.standard
        if let object = object {
            userDefaults.set(object, forKey: key.rawValue)
        } else {
            userDefaults.removeObject(forKey: key.rawValue)
        }
        userDefaults.synchronize()
    }
    
    private func getObject<T>(classType: T, key: UserDefaultKey) -> T? {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: key.rawValue) as? T
    }
}
