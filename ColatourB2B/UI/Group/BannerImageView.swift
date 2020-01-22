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
    let bannerDefaultImgTag = 1
    weak var delegate: BannerImageViewProtocol?
    
    var count:Int = 0 {
        didSet {
            pageControl.numberOfPages = count
        }
    }
    
    var timerInterVal = 3.0 {
        didSet {
            self.setReplay()
        }
    }
    
    var scrollGardient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.black.withAlphaComponent(0.10).cgColor,
                           UIColor.black.withAlphaComponent(0).cgColor]
        gradient.zPosition = 1
        return gradient
    }()
    
    var repeatTimer: Timer?
    var imgView = [UIImageView]()
    var currentCount = 0
    var clickIndex: ((Int)->Void)?
    
    var autoPlay:Bool = false {
        didSet{
            self.setReplay()
        }
    }
    
    var picUrl: [String] = []
    
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
    
    fileprivate func setReplay() {
        repeatTimer?.invalidate()
        repeatTimer = nil
        
        if(autoPlay){
            repeatTimer = Timer.scheduledTimer(timeInterval: timerInterVal, target: self, selector: #selector(BannerImageView.autoScroll), userInfo: nil, repeats: true)
        }
    }
    
    func setup () {
        autoPlay = true
        scrollView.bounces = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.clipsToBounds = true
        self.addSubview(scrollView)
        
        self.layoutIfNeeded()
    }
    
    func addDefaultImageView(imgV:UIImageView){
        imgV.tag = 1
        imgView.append(imgV)
        scrollView.addSubview(imgV)
    }
    
    func setImageWithUrl(picUrl: [String], smallPicUrl: [String], isSkeleton: Bool){
        scrollView.subviews.forEach{$0.removeFromSuperview()}
        imgView.removeAll()
        currentCount = 0
        scrollView.contentOffset = .zero
        pageControl.currentPage = 0
        self.picUrl = picUrl
        
        let width = self.bounds.width
        let height = self.bounds.height
        
        if picUrl.isEmpty {
            let resetIdx = 1
            let imageView:UIImageView!
            if let view = self.scrollView.viewWithTag(1) as? UIImageView{
                imageView = view
            }
            else{
                imageView = UIImageView(image: nil)
                imgView.append(imageView)
                scrollView.addSubview(imageView)
            }
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.tag = resetIdx
            imageView.frame = CGRect(x: width * CGFloat(1), y: 0, width: width, height: height)
            imageView.backgroundColor = UIColor.gray
            
            if isSkeleton {
                imageView.image = nil
            }else{
                imageView.image = nil
            }
            
        }
        
        for (i,_) in picUrl.enumerated() {
            let resetIdx = i + bannerDefaultImgTag
            let imageView:UIImageView!
            if let view = self.scrollView.viewWithTag(resetIdx) as? UIImageView{
                imageView = view
            }
            else{
                imageView = UIImageView(image: nil)
                imgView.append(imageView)
                scrollView.addSubview(imageView)
            }
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.tag = resetIdx
            imageView.frame = CGRect(x: width * CGFloat(i), y: 0, width: width, height: height)
            imageView.backgroundColor = UIColor.gray
            let ges = UITapGestureRecognizer(target: self, action: #selector(touchEvent(gesture:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(ges)
            if picUrl.count == smallPicUrl.count {
                imageView.sd_setImage(with: URL(string: smallPicUrl[i])) { (image, error, cacheType, imageURL) in
                    imageView.backgroundColor = UIColor.white
                    self.downloadPic(imageView: imageView, url: picUrl[i])
                }
            }else{
                self.downloadPic(imageView: imageView, url: picUrl[i])
            }
            
        }
        
        count = imgView.count
        scrollView.contentSize = CGSize(width: width * CGFloat(count), height: height)
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func downloadPic(imageView:UIImageView,url:String){
        SDWebImageManager.shared.loadImage(with: URL(string: url), options: SDWebImageOptions.retryFailed, progress: nil, completed: { (image, data, error, cacheType, bool, imageURL) in
            if error == nil {
                imageView.image = image
                imageView.backgroundColor = UIColor.white
                
            }else{
                imageView.image = nil
                imageView.backgroundColor = UIColor.white
            }
        })
    }
    
    @objc func autoScroll(){
        if (!autoPlay) { return }
        if (pageControl.currentPage == count - 1) {
            self.delegate?.changePageControlFocus(index: 0)
            self.pageControl.currentPage = 0
            self.scrollView.setContentOffset(.zero, animated: false)
        }else {
            DispatchQueue.main.async {
                self.pageControl.currentPage += 1
                let index = self.pageControl.currentPage
                self.delegate?.changePageControlFocus(index: index)
                let point = CGPoint.init(x: CGFloat(self.pageControl.currentPage) * self.scrollView.frame.width, y: 0)
                self.scrollView.setContentOffset(point, animated: true)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = self.bounds
        scrollGardient.frame = self.bounds
        let width = self.bounds.width
        let height = self.bounds.height
        for view in scrollView.subviews{
            if let img = view as? UIImageView {
                img.frame = CGRect.init(x: CGFloat(img.tag - 1) * width, y: 0, width: width, height: height)
            }
        }
        scrollView.contentSize = CGSize(width: width * CGFloat(count), height: height)
        
    }
    
    func setCurrentPage(page:Int,animate:Bool) {
        let width = self.bounds.width
        let point = CGPoint.init(x: width*CGFloat(page), y: 0)
        self.scrollView.setContentOffset(point, animated: animate)
    }
    
    @objc func touchEvent(gesture:UITapGestureRecognizer) {
        delegate?.onTouchImage(index: gesture.view!.tag - 1)
        
    }
}

extension BannerImageView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        self.delegate?.changePageControlFocus(index: Int(pageNumber))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if autoPlay {
            repeatTimer?.invalidate()
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            self.perform(#selector(BannerImageView.delayStartTimer), with: nil, afterDelay: 0.0)
        }
    }
    
    @objc func delayStartTimer() {
        self.setReplay()
    }
}
