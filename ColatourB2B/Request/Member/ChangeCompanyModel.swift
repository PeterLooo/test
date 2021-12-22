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
    var errorInfo: [ErrorInfo] = []
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        memberId <- map["Member_Idno"]
        name <- map["Member_Name"]
        newCompanyId <- map["newCompanyId"]
        email <- map["Member_Email"]
        mobile <- map["Mobile_Phone"]
        phoneZone <- map["Company_Phone_Zone"]
        phoneNo <- map["Company_Phone_No"]
        phoneExtension <- map["Company_Phone_Ext"]
        errorInfo <- map["ErrorMsg_List"]
        
        var exCompanyName = ""
        exCompanyName <- map["Company_Name"]
        var exCompanyId = ""
        exCompanyId <- map["Company_Idno"]
        self.exCompanyName = "\(exCompanyId) \(exCompanyName)"
    }
    
    func getDictionary() -> [String:Any] {
        
        let params = [
                      "New_Company_Idno": newCompanyId!,
                      "New_Company_Name": newCompanyName ?? "",
                      "Member_Email": email!,
                      "Company_Phone_Zone": phoneZone!,
                      "Company_Phone_No": phoneNo!,
                      "Mobile_Phone": mobile!,
                      "Company_Phone_Ext": phoneExtension ?? ""] as [String : Any]
        
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
