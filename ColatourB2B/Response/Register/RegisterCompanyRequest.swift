//
//  RegisterCompanyRequest.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/12/13.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation

class RegisterCompanyRequest {
    
    var senderName: String?
    var companyIdno: String?
    var bossName: String?
    var companyName: String?
    var businessType: String?
    var zoneCode: String?
    var companyAddress: String?
    var companyPhoneZone: String?
    var companyPhoneNo: String?
    var companyFaxZone: String?
    var companyFaxNo: String?
    
    init(senderName: String, companyIdno: String, bossName: String, companyName: String, businessType: String, zoneCode: String,
         companyAddress: String, companyPhoneZone: String, companyPhoneNo: String, companyFaxZone: String, companyFaxNo: String) {
        self.senderName = senderName
        self.companyIdno = companyIdno
        self.bossName = bossName
        self.companyName = companyName
        self.businessType = businessType
        self.zoneCode = zoneCode
        self.companyAddress = companyAddress
        self.companyPhoneZone = companyPhoneZone
        self.companyPhoneNo = companyPhoneNo
        self.companyFaxZone = companyFaxZone
        self.companyFaxNo = companyFaxNo
    }
    
    func getDic() -> [String:Any] {
        var dic: [String: Any] = [:]
        dic = ["Sender_Name": senderName!,
               "Company_Idno": companyIdno!,
               "Boss_Name":bossName!,
               "Company_Name":companyName!,
               "Business_Type":businessType!,
               "Zone_Code":zoneCode!,
               "Company_Address":companyAddress!,
               "Company_Phone_Zone":companyPhoneZone!,
               "Company_Phone_No":companyPhoneNo!,
               "Company_Fax_Zone":companyFaxZone!,
               "Company_Fax_No":companyFaxNo!
        ]
        return dic
    }
}

