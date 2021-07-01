//
//  BannerImageView.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/20.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
import SDWebImage

class BannerImageView: UIView {
    
    var scrollView = UIScrollView()
    var currentPage = 0

    var timer: Timer?
    
    private var ges: UITapGestureRecognizer?
    var viewModel: BannerImageViewModel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = screenWidth / (800/628)
        
        scrollView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: height)
        scrollView.contentSize = CGSize(width: screenWidth * CGFloat((viewModel?.picUrl.count ?? 0) + 2), height: height)
    }
    
    func startTimer() {
        
        if timer != nil {
            
            timer?.invalidate()
        }
        
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        
        timer?.invalidate()
    }
    
    @objc func autoScroll() {
        
        viewModel?.autoScroll()
        
        scrollView.setContentOffset(CGPoint(x: screenWidth * CGFloat((viewModel?.showImageIndex)!), y: 0), animated: true)
    }
    
    func setView(viewModel: BannerImageViewModel){
        self.viewModel = viewModel
        bindViewModel()
        viewModel.setUpImage()
        startTimer()
    }
    
    @objc func touchEvent(gesture: UITapGestureRecognizer) {
        viewModel?.onTouchImage?(gesture.view!.tag - 1)
    }
}

extension BannerImageView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetX = self.scrollView.contentOffset.x
        
        switch offsetX {
        case 0:
            self.scrollView.contentOffset = CGPoint(x: scrollView.frame.width * CGFloat((viewModel?.picUrl.count)!), y: 0)
            viewModel?.currentPage = (viewModel?.picUrl.count)!
            
        case (self.scrollView.frame.width * CGFloat((viewModel?.picUrl.count ?? 0 ) + 1)):
            self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.width, y: 0)
            viewModel?.currentPage = 0
            
        default:
            viewModel?.currentPage = Int(offsetX / screenWidth - 1)
        }
        viewModel?.changePageControlFocus?(viewModel!.currentPage)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        stopTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        viewModel?.showImageIndex = Int(scrollView.contentOffset.x / screenWidth)
        startTimer()
    }
}

extension BannerImageView {
    private func setup () {
        
        setUpScrollView()
    }
    
    private func setUpScrollView() {

        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: self.bounds.height)
        scrollView.contentSize = CGSize(width: screenWidth * CGFloat((viewModel?.picUrl.count ?? 0) + 2), height: self.bounds.height)
        scrollView.contentOffset = CGPoint(x: screenWidth, y: 0)
        
        self.addSubview(scrollView)
        self.layoutIfNeeded()
    }
    
    private func bindViewModel() {
        viewModel?.updateImage = { [weak self] url, smallUrl in
            for index in 0 ... (url.count + 1) {
                
                self?.ges = UITapGestureRecognizer(target: self, action: #selector(self?.touchEvent(gesture:)))
                
                var url: String! = ""
                var imageTag: Int! = 0
                let imageView = UIImageView(frame: CGRect(x: screenWidth * CGFloat(index), y: 0, width: screenWidth, height: (self?.scrollView.frame.height)!))
                
                self?.viewModel?.getImageTagURL(index: index, completion: { (tag, resultUrl) in
                    url = resultUrl
                    imageTag = tag
                })
                
                self?.downloadPic(imageView: imageView, url: url)
        
                imageView.tag = imageTag
                imageView.backgroundColor = UIColor.white
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer((self?.ges)!)
                
                self?.scrollView.addSubview(imageView)
            }
            self?.scrollView.layoutIfNeeded()
        }
    }
    
    private func downloadPic(imageView: UIImageView, url: String) {

        SDWebImageManager.shared.loadImage(with: URL(string: url), options: SDWebImageOptions.retryFailed, progress: nil, completed: { (image, data, error, cacheType, bool, imageURL) in

            if error == nil {

                imageView.image = image
            } else {

                imageView.image = nil
            }
        })
    }
}
