//
//  GroupIndexHeaderImageCell.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/20.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

protocol GroupIndexHeaderImageCellProtocol : NSObjectProtocol{
    func onTouchItem(item: IndexResponse.ModuleItem)
}

class GroupIndexHeaderImageCell: UITableViewCell {

    @IBOutlet weak var bannerImageView: BannerImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    weak var delegate: GroupIndexHeaderImageCellProtocol?
    
    private var urls:[String] = []
    private var smallUrls:[String] = []
    private var itemList: [IndexResponse.ModuleItem] = []
    
    func setCell(itemList: [IndexResponse.ModuleItem], needUpdateBannerImage:Bool){
        
        self.itemList = itemList
        urls = []
        smallUrls = []
        pageControl.numberOfPages = itemList.count
        
        itemList.forEach({ (pic) in
            urls.append(pic.picUrl!)
        })
        
        itemList.forEach { (smallPic) in
            smallUrls.append(smallPic.smallPicUrl!)
        }
        
        bannerImageView.imageViewsURL = urls
        bannerImageView.setImageWithUrl(picUrl: urls, smallPicUrl: smallUrls, isSkeleton: false, needUpdateBannerImage: needUpdateBannerImage)
        bannerImageView.delegate = self
    }
}

extension GroupIndexHeaderImageCell: BannerImageViewProtocol {
    
    func changePageControlFocus(index: Int) {
        self.pageControl.currentPage = index
    }
    
    func onTouchImage(index: Int) {
        if index > self.itemList.count - 1 { return }
        self.delegate?.onTouchItem(item: self.itemList[index])
    }
}
