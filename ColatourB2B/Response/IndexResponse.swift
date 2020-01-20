//
//  IndexResponse.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/20.
//  Copyright © 2020 Colatour. All rights reserved.
//

import ObjectMapper

class IndexResponse: BaseModel {
    
    var moduleDataList : [MultiModule] = []
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        moduleDataList <- map["ModuleData_List"]
    }
    
    class MultiModule : BaseModel {
        
        var moduleList : [Module] = []
        var groupName : String?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            groupName <- map["Group_Name"]
            moduleList <- map["Module_List"]
        }
    }
    
    class Module : BaseModel {
        
        var indexMax : Int?
        var moduleItemList : [ModuleItem] = [] {
            didSet{
                moduleItemList.forEach({$0.moduleText = moduleText})
            }
        }
        var moduleRemark : String?
        var moduleText : String?
        var otherMax : Int?
        
        var isSkeleton: Bool = false
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            
            indexMax <- map["Index_Max"]
            moduleItemList <- map["ModuleItem_List"]
            moduleRemark <- map["Module_Remark"]
            moduleText <- map["Module_Text"]
            otherMax <- map["Other_Max"]
            
            isSkeleton = false
        }
        
        convenience init(indexMax : Int?,
                         moduleItemList : [ModuleItem],
                         moduleRemark : String?,
                         moduleText : String?,
                         otherMax : Int?,
                         isSkeleton: Bool)
        {
            self.init()
            
            self.indexMax = indexMax
            self.moduleItemList = moduleItemList
            self.moduleRemark = moduleRemark
            self.moduleText = moduleText
            self.otherMax = otherMax
            self.isSkeleton = isSkeleton
        }
        
        static func getSkeleton(moduleItemListCount: Int) -> Module {
            let moduleItemList = [ModuleItem](repeating: ModuleItem.skeleton, count: moduleItemListCount)
            return Module(indexMax: nil,
                          moduleItemList: moduleItemList,
                          moduleRemark: nil,
                          moduleText: nil,
                          otherMax: nil,
                          isSkeleton: true)
        }
        
        func isTheSameWith(module: IndexResponse.Module) -> Bool {
            if self.indexMax != indexMax { return false }
            if self.moduleRemark != moduleRemark { return false }
            if self.moduleText != moduleText {  return false }
            if self.otherMax != otherMax { return false }
            if self.isSkeleton != isSkeleton { return false }
            
            if self.moduleItemList.count != module.moduleItemList.count { return false }
            
            var isModuleItemListTheSame = true
            for (index, value) in self.moduleItemList.enumerated() {
                if module.moduleItemList[index].isTheSameWith(moduleItem: value) == false {
                    isModuleItemListTheSame = false
                }
            }
            if isModuleItemListTheSame == false { return false }
            
            return true
        }
    }
    
    class ModuleItem : BaseModel {
        
        var itemPrice : Int?
        var itemPromotion : String?
        var itemRemark : String?
        var itemText : String?
        var linkParams : String?
        var linkType : LinkType!
        var picUrl : String?
        var smallPicUrl : String?
        var moduleText : String?
        //Note: 如果需要記住是否載入過圖片使用，平常忽略
        var isImageDownloaded: Bool = false
        var isSmallPicUrlDownloaded: Bool = false
        
        var isSkeleton: Bool = false
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            
            itemPrice <- map["Item_Price"]
            itemPromotion <- map["Item_Promotion"]
            itemRemark <- map["Item_Remark"]
            itemText <- map["Item_Text"]
            linkParams <- map["Link_Params"]
            var type = ""
            type <- map["Link_Type"]
            linkType = LinkType(rawValue: type)
            if (linkType == nil) { linkType = .unknown }
            picUrl <- map["Pic_Url"]
            smallPicUrl <- map["Small_Pic_Url"]
            
            isSkeleton = false
        }
        
        convenience init(
            itemPrice : Int?,
            itemPromotion : String?,
            itemRemark : String?,
            itemText : String?,
            linkParams : String?,
            linkType : LinkType!,
            picUrl : String?,
            smallPicUrl : String?,
            isSkeleton: Bool)
        {
            self.init()
            
            self.itemPrice = itemPrice
            self.itemPromotion = itemPromotion
            self.itemRemark = itemRemark
            self.itemText = itemText
            self.linkParams = linkParams
            self.linkType = linkType
            self.picUrl = picUrl
            self.smallPicUrl = smallPicUrl
            self.isSkeleton = isSkeleton
        }
        
        static var skeleton: ModuleItem {
            return ModuleItem(itemPrice: nil,
                              itemPromotion: nil,
                              itemRemark: nil,
                              itemText: nil,
                              linkParams: nil,
                              linkType: nil,
                              picUrl: nil,
                              smallPicUrl: nil,
                              isSkeleton: true)
        }
        
        func isTheSameWith(moduleItem: IndexResponse.ModuleItem) -> Bool {
            if self.itemPrice != moduleItem.itemPrice { return false }
            if self.itemPromotion != moduleItem.itemPromotion { return false }
            if self.itemRemark != moduleItem.itemRemark { return false }
            if self.itemText != moduleItem.itemText { return false }
            if self.linkParams != moduleItem.linkParams { return false }
            if self.linkType != moduleItem.linkType { return false }
            if self.picUrl != moduleItem.picUrl { return false }
            if self.smallPicUrl != moduleItem.smallPicUrl { return false }
            if self.isSkeleton != moduleItem.isSkeleton { return false }
            return true
        }
    }
}
