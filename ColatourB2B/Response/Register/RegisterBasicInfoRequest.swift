//
//  RegisterBasicInfoRequest.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/12/16.
//  Copyright © 2021 Colatour. All rights reserved.
//
import Foundation

class RegisterBasicInfoRequest {
    
    var companyIdno: String?
    var memberIdno: String?
    var memberPassword: String?
    var passwordIdentify: String?
    var passwordReminder: String?
    var memberName: String?
    var memberGender: String?
    var memberBirthday: String?
    var memberEmail: String?
    var companyPhoneZone: String?
    var companyPhoneNo: String?
    var companyPhoneExt: String?
    var mobilePhone: String?
    var mainBiz: String?
    var channelType: String?
    var mediaIdno: String?
    var mediaName: String?
    
    init(companyIdno: String, memberIdno: String, memberPassword: String, passwordIdentify: String, passwordReminder: String, memberName: String, memberGender: String, memberBirthday: String, memberEmail: String, companyPhoneZone: String, companyPhoneNo: String, companyPhoneExt: String, mobilePhone: String, mainBiz: String, channelType: String, mediaIdno: String, mediaName: String) {
        self.companyIdno = companyIdno
        self.memberIdno = memberIdno
        self.memberPassword = memberPassword
        self.passwordIdentify = passwordIdentify
        self.passwordReminder = passwordReminder
        self.memberName = memberName
        self.memberGender = memberGender
        self.memberBirthday = memberBirthday
        self.memberEmail = memberEmail
        self.companyPhoneZone = companyPhoneZone
        self.companyPhoneNo = companyPhoneNo
        self.companyPhoneExt = companyPhoneExt
        self.mobilePhone = mobilePhone
        self.mainBiz = mainBiz
        self.channelType = channelType
        self.mediaIdno = mediaIdno
        self.mediaName = mediaName
    }
    
    func getDic() -> [String:Any] {
        var dic: [String: Any] = [:]
        dic = ["Company_Idno": companyIdno!,
               "Member_Idno": memberIdno!,
               "Member_Password": memberPassword!,
               "Password_Identify": passwordIdentify!,
               "Password_Reminder": passwordReminder!,
               "Member_Name": memberName!,
               "Member_Gender": memberGender!,
               "Member_Birthday": memberBirthday!,
               "Member_Email": memberEmail!,
               "Company_Phone_Zone": companyPhoneZone!,
               "Company_Phone_No": companyPhoneNo!,
               "Company_Phone_Ext": companyPhoneExt!,
               "Mobile_Phone": mobilePhone!,
               "Main_Biz": mainBiz!,
               "Channel_Type": channelType!,
               "Media_Idno": mediaIdno!,
               "Media_Name": mediaName!
        ]
        return dic
    }
}

