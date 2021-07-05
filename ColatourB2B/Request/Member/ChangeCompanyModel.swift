//
//  ChangeCompanyModel.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/7/2.
//  Copyright © 2021 Colatour. All rights reserved.
//

import ObjectMapper

class ChangeCompanyModel: BaseModel {
    
    var memberId: String?
    var name: String?
    var exCompanyName: String?
    var newCompanyId: String?
    var newCompanyName: String?
    var email: String?
    var mobile: String?
    var phoneZone: String?
    var phoneNo: String?
    var phoneExtension: String?
    var errorInfo: ChangeCompanyErrorModel?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        memberId <- map["memberId"]
        name <- map["name"]
        exCompanyName <- map["exCompanyName"]
        newCompanyId <- map["newCompanyId"]
        email <- map["email"]
        mobile <- map["mobile"]
        phoneZone <- map["phoneZone"]
        phoneNo <- map["phoneNo"]
        phoneExtension <- map["phoneExtension"]
        errorInfo <- map["errorInfo"]
    }
    
    func getDictionary() -> [String:Any] {
        
        let params = ["會員帳號": memberId!,
                      "姓名": name!,
                      "原任職旅行社":exCompanyName!,
                      "新旅行社統編": newCompanyId!,
                      "電子信箱": email!,
                      "區碼": phoneZone!,
                      "公司電話": phoneNo!,
                      "行動電話": mobile!,
                      "分機": phoneExtension ?? ""] as [String : Any]
        
        return params
    }
}

class ChangeCompanyErrorModel: BaseModel {
    
    var newCompanyId: String?
    var newCompanyName: String?
    var email: String?
    var mobile: String?
    var phone: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        newCompanyId <- map["newCompanyId"]
        newCompanyName <- map["newCompanyName"]
        email <- map["email"]
        mobile <- map["mobile"]
        phone <- map["phone"]
    }
}
