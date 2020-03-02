//
//  HomeAd2View.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/21.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

class HomeAd2View: UIView {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var itemText: UILabel!
    @IBOutlet weak var itemPromotion: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
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
        let nib = UINib.init(nibName: "HomeAd2View", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        let ges = UITapGestureRecognizer(target: self, action: #selector(onTouchAdView))
        self.addGestureRecognizer(ges)
        self.isUserInteractionEnabled = true
    }
    
    func setView(item: IndexResponse.ModuleItem, isLast: Bool){
        self.adItem = item
        self.itemText.text = item.itemText
        self.itemPromotion.text = item.itemPromotion.isNilOrEmpty == false ? "  \(item.itemPromotion ?? "")  ":""
        self.itemPromotion.layer.cornerRadius = 4
        self.itemPromotion.layer.masksToBounds = true
        let priceFormat = FormatUtil.priceFormat(price: item.itemPrice)
        self.itemPrice.text = item.itemPrice != 0 ? "同業 \(priceFormat)起":""
        self.bottomConstraint.constant = isLast == true ? 40:5
        self.borderView.setBorder(width: 0.1, radius: 4, color: UIColor.lightGray)
        
        self.shadowView.setShadow(offset: CGSize(width:0, height:1), opacity: 0.4,shadowRadius: 4 , color: UIColor.lightGray)
        
    }
    @objc func onTouchAdView(){
        self.delegate?.onTouchHotelAdItem(adItem: adItem!)
    }
}
