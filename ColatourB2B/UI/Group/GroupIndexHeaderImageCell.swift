//
//  GroupIndexHeaderImageCell.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/20.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

class GroupIndexHeaderImageCell: UITableViewCell {

    @IBOutlet weak var bannerImageView: BannerImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var viewModel: GroupIndexHeaderImageViewModel?
    
    func setCell(viewModel: GroupIndexHeaderImageViewModel) {
        pageControl.numberOfPages = viewModel.getPageControlCount()
        bannerImageView.setView(viewModel: viewModel.bannerViewModel!)
        viewModel.bannerViewModel?.changePageControlFocus = { [weak self] page in
            self?.pageControl.currentPage = page
        }
    }
}

