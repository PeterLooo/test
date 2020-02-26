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
    
        let pageControl = UIPageControl()
        let scrollView = UIScrollView()
        let screenSize = UIScreen.main.bounds
        var timer: Timer?
        var showImageIndex: Int?
        var imgViews = [String]()
        
        weak var delegate: BannerImageViewProtocol?

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            self.setup()
        }
        
        required override init(frame: CGRect) {
            super.init(frame: frame)
            self.setup()
        }
        
        open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            return true
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
            
            if showImageIndex == imgViews.count + 1 {
                
                showImageIndex = 2
            } else {
                
                showImageIndex! += 1
            }
            
            scrollView.setContentOffset(CGPoint(x: screenWidth * CGFloat(showImageIndex!), y: 0), animated: true)
        }
        
        func setup () {
            
            showImageIndex = 0
            pageControl.currentPage = 0
            scrollView.delegate = self
            scrollView.bounces = false
            scrollView.isDirectionalLockEnabled = true
            scrollView.isUserInteractionEnabled = true
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.isPagingEnabled = true
            scrollView.clipsToBounds = true
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
        
            self.addSubview(scrollView)
            
            self.layoutIfNeeded()
            startTimer()
        }

        
        func setImageWithUrl(picUrl: [String], smallPicUrl: [String], isSkeleton: Bool, needUpdateBannerImage: Bool) {
            
            if needUpdateBannerImage == false { return }
            
            scrollView.contentSize = CGSize(width: screenSize.width * CGFloat(picUrl.count + 2), height: self.bounds.height)
            scrollView.subviews.forEach{$0.removeFromSuperview()}
            imgViews = []
            imgViews = picUrl
            scrollView.contentOffset = .zero
            pageControl.currentPage = 0

            let width = screenWidth
            let height = self.bounds.height
            
            for index in 0 ... imgViews.count + 1 {
                var pic = ""
                let imageView = UIImageView(frame: CGRect(x: screenWidth * CGFloat(index), y: 0, width: width, height: scrollView.frame.height))
                
                switch index {
                case 0:
                    pic = picUrl.last!
                    
                case (picUrl.count + 1):
                    pic = picUrl.first!
                    
                default:
                    pic = picUrl[index - 1]
                }
                self.downloadPic(imageView: imageView, url: pic)
                
                scrollView.addSubview(imageView)
            }
            scrollView.layoutIfNeeded()
        }
        
        func downloadPic(imageView: UIImageView, url: String){
            
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
        
        override func layoutSubviews() {
            super.layoutSubviews()
            scrollView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: self.bounds.height)
            
        }

        @objc func touchEvent(gesture: UITapGestureRecognizer) {
            
            delegate?.onTouchImage(index: gesture.view!.tag - 1)
        }
    }

    extension BannerImageView: UIScrollViewDelegate {
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            
            let offsetX = scrollView.contentOffset.x
            
            if offsetX == 0 {
                
                scrollView.contentOffset = CGPoint(x: scrollView.frame.width * CGFloat(imgViews.count), y: 0)
                pageControl.currentPage = imgViews.count
                
            } else if offsetX == scrollView.frame.width * CGFloat(imgViews.count + 1) {
                
                scrollView.contentOffset = CGPoint(x: scrollView.frame.width, y: 0)
                pageControl.currentPage = 0
                
            } else {
                
                pageControl.currentPage = Int(offsetX / screenWidth - 1)
            }
        }
        
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            
            stopTimer()
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

            showImageIndex = Int(scrollView.contentOffset.x / screenWidth)
            startTimer()
        }
        
    }
