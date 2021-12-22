//
//  ChangeMemberInfo.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/12/8.
//  Copyright © 2021 Colatour. All rights reserved.
//

import ObjectMapper
import RxCocoa
import RxSwift
class MemberData: BaseModel {
    
    var memberInfo: ChangeMemberInfo?
    var errorList: [ErrorInfo] = []
    var emailError: Bool?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        memberInfo <- map["MemberData"]
        errorList <- map["ErrorMsg_List"]
        emailError <- map["Error_Mail"]
        memberInfo?.errorList = errorList
    }
}
class ChangeMemberInfo: BaseModel {
    
    var memberId: String?
    var name: String?
    var companyName: String?
    var companyIdno: String?
    var mainJob: String?
    var birthday: String?
    var email: String?
    var mobile: String?
    var phoneZone: String?
    var phoneNo: String?
    var phoneExtension: String?
    var gender: String?
    var errorList: [ErrorInfo] = []
    
    var unSubscribeNewsletter: Bool = false {
        didSet{
            checkImage = unSubscribeNewsletter ? #imageLiteral(resourceName: "check") : #imageLiteral(resourceName: "check_hover")
            changeImage?()
        }
    }
    
    var checkImage: UIImage!
    var changeImage: (()->())?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        companyName <- map["Company_Name"]
        companyIdno <- map["Company_Idno"]
        memberId <- map["Member_Idno"]
        name <- map["Member_Name"]
        email <- map["Member_Email"]
        mobile <- map["Mobile_Phone"]
        phoneZone <- map["Company_Phone_Zone"]
        phoneNo <- map["Company_Phone_No"]
        phoneExtension <- map["Company_Phone_Ext"]
        mainJob <- map["Main_Biz"]
        birthday <- map["Member_Birthday"]
        unSubscribeNewsletter <- map["No_SMS_Mark"]
        gender <- map["Member_Gender"]
    }
    
    func getDictionary() -> [String:Any] {
       
        let params = [
                      "Main_Biz": mainJob!,
                      "No_Sms_Mark": unSubscribeNewsletter,
                      "Member_Birthday": birthday!,
                      "Member_Email": email!,
                      "Company_Phone_Zone": phoneZone!,
                      "Company_Phone_No": phoneNo!,
                      "Company_Phone_Ext": phoneExtension ?? "",
                      "Mobile_Phone": mobile!] as [String : Any]
        
        return params
    }
}

class ErrorInfo: BaseModel {
    
    var columnName: String?
    var errorMessage: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        columnName <- map["Column_Name"]
        errorMessage <- map["Error_Message"]
        
    }
}
