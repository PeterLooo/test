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
    //let bannerDefaultImgTag = 1
    //let imageNames = ["image1", "image2", "image3"]
    let screenSize = UIScreen.main.bounds
    var timer: Timer?
    var showImageIndex: Int?
    var imgViews = [UIImageView]()
    var imgViewsForScroll = [UIImageView]()
    
    weak var delegate: BannerImageViewProtocol?
    
//    var count:Int = 0 {
//        didSet {
//            pageControl.numberOfPages = count
//        }
//    }
//
//    var timerInterVal = 3.0 {
//        didSet {
//            self.setReplay()
//        }
//    }
//
//    var repeatTimer: Timer?
    
    
//    var autoPlay:Bool = false {
//        didSet{
//            self.setReplay()
//        }
//    }
    
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
    
//    fileprivate func setReplay() {
//        repeatTimer?.invalidate()
//        repeatTimer = nil
//
//        if(autoPlay){
//            repeatTimer = Timer.scheduledTimer(timeInterval: timerInterVal, target: self, selector: #selector(BannerImageView.autoScroll), userInfo: nil, repeats: true)
//        }
//    }
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
        
        scrollView.setContentOffset(CGPoint(x: scrollView.frame.width * CGFloat(showImageIndex!), y: 0), animated: true)
    }
    
    func setup () {
        
        showImageIndex = 1
        pageControl.currentPage = 0
        
//        autoPlay = true
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.clipsToBounds = true
        scrollView.contentOffset = CGPoint(x: screenSize.width * CGFloat(imgViewsForScroll.count), y: 0)
    
        self.addSubview(scrollView)
        
//        self.layoutIfNeeded()
        startTimer()
    }
    
//    func addDefaultImageView(imgV:UIImageView){
//        imgV.tag = 1
//        imgView.append(imgV)
//        scrollView.addSubview(imgV)
//    }
    
    func setImageWithUrl(picUrl: [String], smallPicUrl: [String], isSkeleton: Bool, needUpdateBannerImage: Bool) {
        
        if needUpdateBannerImage == false { return }
        
//        scrollView.subviews.forEach{$0.removeFromSuperview()}
//        imgViews.removeAll()
//
//        scrollView.contentOffset = .zero
//        pageControl.currentPage = 0
//
//        let width = self.bounds.width
//        let height = self.bounds.height
        
        for index in 0 ..< picUrl.count {
            
            let imageView = UIImageView()
            imageView.bounds = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            
            if picUrl.count == smallPicUrl.count {
                
                imageView.sd_setImage(with: URL(string: smallPicUrl[index])) { (image, error, cacheType, imageURL) in
                    self.downloadPic(imageView: imageView, url: picUrl[index])
                }
            } else {
                
                self.downloadPic(imageView: imageView, url: picUrl[index])
            }
            
            imgViews.append(imageView)
        }
        
        for index in 0 ... (imgViews.count + 1) {
            
            var imageViewForScroll = UIImageView(frame: CGRect(x: scrollView.frame.width * CGFloat(index), y: 0, width: scrollView.frame.width, height: scrollView.frame.height))
            
            switch index {
            case 0:
                imageViewForScroll = imgViews.last!
                
            case (imgViews.count + 1):
                imageViewForScroll = imgViews.first!
                
            default:
                imageViewForScroll = imgViews[index - 1]
            }
            
            imageViewForScroll.contentMode = .scaleAspectFill
            imageViewForScroll.clipsToBounds = true
            imageViewForScroll.isUserInteractionEnabled = true
            imgViewsForScroll.append(imageViewForScroll)
            
            scrollView.addSubview(imageViewForScroll)
        }
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(imgViewsForScroll.count), height: scrollView.frame.width)
        
//        for (i,_) in picUrl.enumerated() {
//            let resetIdx = i + bannerDefaultImgTag
//            let imageView:UIImageView!
//            if let view = self.scrollView.viewWithTag(resetIdx) as? UIImageView{
//                imageView = view
//            }
//            else{
//                imageView = UIImageView(image: nil)
//                imgViews.append(imageView)
//                scrollView.addSubview(imageView)
//            }
//            imageView.contentMode = .scaleAspectFit
//            imageView.clipsToBounds = true
//            imageView.tag = resetIdx
//            imageView.frame = CGRect(x: width * CGFloat(i), y: 0, width: width, height: height)
//            imageView.backgroundColor = UIColor.gray
//            let ges = UITapGestureRecognizer(target: self, action: #selector(touchEvent(gesture:)))
//            imageView.isUserInteractionEnabled = true
//            imageView.addGestureRecognizer(ges)
//            if picUrl.count == smallPicUrl.count {
//                imageView.sd_setImage(with: URL(string: smallPicUrl[i])) { (image, error, cacheType, imageURL) in
//                    imageView.backgroundColor = UIColor.white
//                    self.downloadPic(imageView: imageView, url: picUrl[i])
//                }
//            }else{
//                self.downloadPic(imageView: imageView, url: picUrl[i])
//            }
//        }
        
//        scrollView.contentSize = CGSize(width: width * CGFloat(count), height: height)
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
    
//    @objc func autoScroll(){
//        if (!autoPlay) { return }
//        if (pageControl.currentPage == count - 1) {
//            self.delegate?.changePageControlFocus(index: 0)
//            self.pageControl.currentPage = 0
//            self.scrollView.setContentOffset(.zero, animated: true)
//        }else {
//            DispatchQueue.main.async {
//                self.pageControl.currentPage += 1
//                let index = self.pageControl.currentPage
//                self.delegate?.changePageControlFocus(index: index)
//                let point = CGPoint.init(x: CGFloat(self.pageControl.currentPage) * self.scrollView.frame.width, y: 0)
//                self.scrollView.setContentOffset(point, animated: true)
//            }
//        }
//    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        scrollView.frame = self.bounds
//        scrollGardient.frame = self.bounds
//        let width = self.bounds.width
//        let height = self.bounds.height
//        for view in scrollView.subviews{
//            if let img = view as? UIImageView {
//                img.frame = CGRect.init(x: CGFloat(img.tag - 1) * width, y: 0, width: width, height: height)
//            }
//        }
//        scrollView.contentSize = CGSize(width: width * CGFloat(count), height: height)
//
//    }
    
//    func setCurrentPage(page:Int,animate:Bool) {
//        let width = self.bounds.width
//        let point = CGPoint.init(x: width*CGFloat(page), y: 0)
//        self.scrollView.setContentOffset(point, animated: animate)
//    }
    
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
            
            pageControl.currentPage = Int(offsetX / screenSize.width - 1)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        stopTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        showImageIndex = Int(scrollView.contentOffset.x / screenSize.width)
        startTimer()
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
//        pageControl.currentPage = Int(pageNumber)
//        self.delegate?.changePageControlFocus(index: Int(pageNumber))
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if autoPlay {
//            repeatTimer?.invalidate()
//            NSObject.cancelPreviousPerformRequests(withTarget: self)
//            self.perform(#selector(BannerImageView.delayStartTimer), with: nil, afterDelay: 0.0)
//        }
//    }
//
//    @objc func delayStartTimer() {
//        self.setReplay()
//    }
}
