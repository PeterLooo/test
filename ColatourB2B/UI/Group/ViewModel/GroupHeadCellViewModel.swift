//
//  GroupHeadCellViewModel.swift
//  ColatourB2B
//
//  Created by 吳思賢 on 2021/6/11.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation

class BannerImageViewModel {
    
    var changePageControlFocus: ((_ index: Int)->())?
    var onTouchImage: ((_ index: Int)->())?
    var updateImage: ((_ picUrl: [String],_ smallPicUrl: [String])->())?
    var picUrl: [String] = []
    var smallPicUrl: [String] = []
    
    var currentPage = 0
    var imageViewsURL: [String] = []
    var timer: Timer?
    var showImageIndex: Int = 1
    
    func getImageTagURL(index: Int , completion:@escaping (Int, String)->()){
        var url = ""
        var imageTag: Int?
        
        switch index {
        case 0:
            url = picUrl.last ?? ""
            imageTag = picUrl.count
            
        case (picUrl.count + 1):
            url = picUrl.first ?? ""
            imageTag = 1
            
        default:
            url = picUrl[index - 1]
            imageTag = index
        }
        completion(imageTag!,url)
    }
    
    func setImageWithUrl(picUrl: [String], smallPicUrl: [String]){
        
        self.picUrl = picUrl
        self.smallPicUrl = smallPicUrl
    }
    
    func setUpImage(){
        updateImage?(picUrl, smallPicUrl)
    }
    
    func autoScroll() {
        
        if showImageIndex == picUrl.count + 1 {
            
            showImageIndex = 2
        } else {
            
            showImageIndex += 1
        }
    }
}

class GroupIndexHeaderImageViewModel {
    
    var onTouchItem: ((_ item: IndexResponse.ModuleItem) -> ())?
    var bannerViewModel: BannerImageViewModel?
    
    private var urls:[String] = []
    private var smallUrls:[String] = []
    var itemList: [IndexResponse.ModuleItem] = []
    
    func setViewModle(list: [IndexResponse.ModuleItem]) {
        itemList = list
        
        urls = []
        smallUrls = []
        
        itemList.forEach({ (pic) in
            urls.append(pic.picUrl!)
        })
        
        itemList.forEach { (smallPic) in
            smallUrls.append(smallPic.smallPicUrl!)
        }
        
        let banner = BannerImageViewModel()
        
        banner.setImageWithUrl(picUrl: urls, smallPicUrl: smallUrls)
        banner.onTouchImage = { [weak self] index in
            self?.onTouchItem?(list[index])
        }
        self.bannerViewModel = banner
        
    }
    
    func getPageControlCount() -> Int {
        return itemList.count
    }
}
