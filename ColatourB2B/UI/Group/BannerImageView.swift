//
//  BannerImageView.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/20.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
import SDWebImage

protocol BannerImageViewProtocol: NSObjectProtocol {
    func onTouchImage(index: Int)
    func changePageControlFocus(index: Int)
}

class BannerImageView: UIView {
    
    var scrollView = UIScrollView()
    var currentPage = 0
    var imageViewsURL: [String] = []
    var timer: Timer?
    var showImageIndex: Int?
    var ges: UITapGestureRecognizer?
    
    weak var delegate: BannerImageViewProtocol?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    func setup () {
        
        showImageIndex = 1
        setUpScrollView()
        startTimer()
    }
    
    func setUpScrollView() {

        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: self.bounds.height)
        scrollView.contentSize = CGSize(width: screenWidth * CGFloat(imageViewsURL.count + 2), height: self.bounds.height)
        scrollView.contentOffset = CGPoint(x: screenWidth, y: 0)
        
        self.addSubview(scrollView)
        self.layoutIfNeeded()
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
        
        if showImageIndex == imageViewsURL.count + 1 {
            
            showImageIndex = 2
        } else {
            
            showImageIndex! += 1
        }
        
        scrollView.setContentOffset(CGPoint(x: screenWidth * CGFloat(showImageIndex!), y: 0), animated: true)
    }
    
    func setImageWithUrl(picUrl: [String], smallPicUrl: [String], isSkeleton: Bool, needUpdateBannerImage: Bool) {
        
        if needUpdateBannerImage == false { return }
        
        for index in 0 ... (imageViewsURL.count + 1) {
            
            ges = UITapGestureRecognizer(target: self, action: #selector(touchEvent(gesture:)))
            
            var url: String
            var imageTag: Int
            let imageView = UIImageView(frame: CGRect(x: screenWidth * CGFloat(index), y: 0, width: screenWidth, height: scrollView.frame.height))
            
            switch index {
            case 0:
                url = imageViewsURL.last!
                imageTag = imageViewsURL.count
                
            case (imageViewsURL.count + 1):
                url = imageViewsURL.first!
                imageTag = 1
                
            default:
                url = imageViewsURL[index - 1]
                imageTag = index
            }
            
            downloadPic(imageView: imageView, url: url)
    
            imageView.tag = imageTag
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(self.ges!)
            
            scrollView.addSubview(imageView)
        }
        scrollView.layoutIfNeeded()
    }
    
    func downloadPic(imageView: UIImageView, url: String) {

        SDWebImageManager.shared.loadImage(with: URL(string: url), options: SDWebImageOptions.retryFailed, progress: nil, completed: { (image, data, error, cacheType, bool, imageURL) in

            if error == nil {

                imageView.image = image
                imageView.backgroundColor = UIColor.white
            } else {

                imageView.image = nil
                imageView.backgroundColor = UIColor.white
            }
        })
    }

    func resizeImage(image: UIImage) -> UIImage {

        let size = CGSize(width: screenWidth, height: scrollView.frame.height)
        let renderer = UIGraphicsImageRenderer(size: size)

        let newImage = renderer.image { (context) in
            image.draw(in: renderer.format.bounds)
        }

        return newImage
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let height = screenWidth / (800/628)
        scrollView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: height)
        scrollView.contentSize = CGSize(width: screenWidth * CGFloat(imageViewsURL.count + 2), height: height)
    }
    
    @objc func touchEvent(gesture: UITapGestureRecognizer) {
        
        delegate?.onTouchImage(index: gesture.view!.tag - 1)
    }
}

extension BannerImageView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetX = scrollView.contentOffset.x
        
        switch offsetX {
        case 0:
            scrollView.contentOffset = CGPoint(x: scrollView.frame.width * CGFloat(imageViewsURL.count), y: 0)
            currentPage = imageViewsURL.count
            
        case (scrollView.frame.width * CGFloat(imageViewsURL.count + 1)):
            scrollView.contentOffset = CGPoint(x: scrollView.frame.width, y: 0)
            currentPage = 0
            
        default:
            currentPage = Int(offsetX / screenWidth - 1)
        }
        
        delegate?.changePageControlFocus(index: currentPage)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        stopTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        showImageIndex = Int(scrollView.contentOffset.x / screenWidth)
        startTimer()
    }
}
