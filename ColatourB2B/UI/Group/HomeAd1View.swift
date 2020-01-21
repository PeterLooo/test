//
//  HomeAd1View.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/20.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
import SDWebImage

protocol HomeAd1ViewProcotol : NSObjectProtocol {
    func onTouchHotelAdItem(adItem: IndexResponse.ModuleItem)
}
class HomeAd1View: UIView {
    
    @IBOutlet weak var boderView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var itemContent: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var viewLeading: NSLayoutConstraint!
    @IBOutlet weak var viewTrailing: NSLayoutConstraint!
    @IBOutlet weak var boderViewWidth: NSLayoutConstraint!
    @IBOutlet weak var boderViewHeight: NSLayoutConstraint!

    weak var delegate: HomeAd1ViewProcotol?
    
    private var adItem: IndexResponse.ModuleItem?
    
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
        let nib = UINib.init(nibName: "HomeAd1View", bundle: bundle)
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
                }else{
                    self.imageView.image = #imageLiteral(resourceName: "emptystate")
                }
            })
        }
        viewLeading.constant = isFirst ? 16:0
        viewTrailing.constant = isLast ? 16:0
        
        self.imageView.contentMode = .scaleAspectFill
        
        self.itemContent.text = item.itemText
        let priceFormat = FormatUtil.priceFormat(price: item.itemPrice)
        self.itemPrice.text = item.itemPrice == 0 ? "" : "\(priceFormat)起"
        setAttribute(label: self.itemPrice, amount: self.itemPrice.text!)
        self.boderView.layoutIfNeeded()
        self.boderView.layer.masksToBounds = true
    }
    
    @objc func onTouchAdView(){
        self.delegate?.onTouchHotelAdItem(adItem: self.adItem!)
    }
    
    private func setCustomViewFrameAndGes(){
        self.shadowView.setShadow(offset: CGSize(width:0, height:1), opacity: 0.4,shadowRadius: 2 , color: UIColor.gray)
        self.boderView.layer.cornerRadius = CGFloat(4)
        self.boderViewWidth.constant = ((screenWidth - 32) / 2) - 4
        self.boderViewHeight.constant = (screenWidth / 2.21) / 0.9
        let ges = UITapGestureRecognizer(target: self, action: #selector(onTouchAdView))
        self.addGestureRecognizer(ges)
        self.isUserInteractionEnabled = true
    }
    
    func setAttribute(label:UILabel,amount:String){
        
        let length = amount.count
        if length <= 0 {return}
        let attributedString = NSMutableAttributedString(string: label.text!, attributes: [
            .font: UIFont(name: "PingFangTC-Medium", size: 15)!,
            .foregroundColor: ColorHexUtil.hexColor(hex: "fc4c02"),
            .kern: -0.1
            ])
        
        attributedString.addAttributes([
            .font: UIFont(name: "PingFangTC-Regular", size: 10)!,
            .foregroundColor: ColorHexUtil.hexColor(hex: "333333"),
            .kern: -0.1
            ], range: NSRange(location: length - 1, length: 1))
        label.attributedText = attributedString
    }
}
