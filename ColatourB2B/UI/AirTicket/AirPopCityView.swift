//
//  AirPopCityView.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2020/3/13.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
import SDWebImage

class AirPopCityView: UIView {

    @IBOutlet weak var boderView: UIView!
    @IBOutlet weak var borderSecView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var shadowSecView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageSecView: UIImageView!
    @IBOutlet weak var itemContent: UILabel!
    @IBOutlet weak var itemSecContent: UILabel!
    @IBOutlet weak var viewLeading: NSLayoutConstraint!
    @IBOutlet weak var viewTrailing: NSLayoutConstraint!
    @IBOutlet weak var boderViewWidth: NSLayoutConstraint!
    @IBOutlet weak var boderViewHeight: NSLayoutConstraint!

    weak var delegate: HomeAd1ViewProcotol?
    
    private var adItem: IndexResponse.ModuleItem?
    private var adSecItem: IndexResponse.ModuleItem?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUp()
    }
    
    fileprivate func setUp(){
        let bundle = Bundle.init(for: self.classForCoder)
        let nib = UINib.init(nibName: "AirPopCityView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        setCustomViewFrameAndGes()
    }
    
    func setView(item: IndexResponse.ModuleItem, isFirst: Bool, isLast: Bool){
        self.adItem = item
        
        self.imageView.sd_setImage(with: URL.init(string: item.smallPicUrl ?? "")) { (image, error, cacheType, imageURL) in
            SDWebImageManager.shared.loadImage(with: URL(string: item.picUrl ?? ""), options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (image, data, error, cacheType, bool, imageURL) in
                if error == nil {
                    self.imageView.image = image
                }
            })
        }
        viewLeading.constant = isFirst ? 16:0
        viewTrailing.constant = isLast ? 16:0
        
        self.imageView.contentMode = .scaleAspectFill
        self.imageSecView.contentMode = .scaleAspectFill
        
        self.itemContent.text = item.itemText
        self.itemSecContent.text = ""
        self.itemSecContent.backgroundColor = UIColor.init(named: "背景灰")
        self.imageSecView.image = nil
        self.imageSecView.backgroundColor = UIColor.init(named: "ImageBackColor")
        self.boderView.layoutIfNeeded()
        self.borderSecView.layoutIfNeeded()
        self.boderView.layer.masksToBounds = true
        self.borderSecView.layer.masksToBounds = true
    }
    
    func setCellSec(item: IndexResponse.ModuleItem) {
        self.adSecItem = item
        self.itemSecContent.backgroundColor = UIColor.white
        self.itemSecContent.text = item.itemText
        self.imageSecView.backgroundColor = UIColor.init(named: "ImageBackColor")
        self.imageSecView.sd_setImage(with: URL.init(string: item.smallPicUrl ?? "")) { (image, error, cacheType, imageURL) in
            SDWebImageManager.shared.loadImage(with: URL(string: item.picUrl ?? ""), options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (image, data, error, cacheType, bool, imageURL) in
                if error == nil {
                    self.imageSecView.image = image
                }
            })
        }
        setSecViewFrameAndGes()
    }
    
    @objc func onTouchAdView(){
        self.delegate?.onTouchHotelAdItem(adItem: self.adItem!)
    }
    
    @objc func onTouchSecAdView(){
        self.delegate?.onTouchHotelAdItem(adItem: self.adSecItem!)
    }
    
    private func setCustomViewFrameAndGes(){
        self.shadowView.setShadow(offset: CGSize(width:0, height:1), opacity: 0.4,shadowRadius: 2 , color: UIColor.gray)
        self.boderView.layer.cornerRadius = CGFloat(4)
        
        self.boderViewWidth.constant = screenWidth * (1 / 3.75)
        self.boderViewHeight.constant = screenWidth * (1 / 3.75)
        let ges = UITapGestureRecognizer(target: self, action: #selector(onTouchAdView))
        self.boderView.addGestureRecognizer(ges)
        self.boderView.isUserInteractionEnabled = true
    }
    
    private func setSecViewFrameAndGes(){
        self.shadowSecView.setShadow(offset: CGSize(width:0, height:1), opacity: 0.4,shadowRadius: 2 , color: UIColor.gray)
        self.borderSecView.layer.cornerRadius = CGFloat(4)
        let ges = UITapGestureRecognizer(target: self, action: #selector(onTouchSecAdView))
        self.borderSecView.addGestureRecognizer(ges)
        self.borderSecView.isUserInteractionEnabled = true
    }

}
