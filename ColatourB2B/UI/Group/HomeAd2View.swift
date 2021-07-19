//
//  HomeAd2View.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/21.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
import SDWebImage
class HomeAd2View: UIView {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var itemText: UILabel!
    @IBOutlet weak var itemPromotion: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    
    private var adItem: IndexResponse.ModuleItem?
    private var viewModel: HomeAd2SubViewModel?
    
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
        self.logoImage.contentMode = .scaleAspectFill
        self.itemPromotion.layer.cornerRadius = 4
        self.itemPromotion.layer.masksToBounds = true
        self.borderView.setBorder(width: 0.1, radius: 4, color: UIColor.lightGray)
        
        self.shadowView.setShadow(offset: CGSize(width:0, height:1), opacity: 0.4,shadowRadius: 4 , color: UIColor.lightGray)
    }
    
    func setView(viewModel: HomeAd2SubViewModel){
        self.viewModel = viewModel
        self.itemText.text = viewModel.itemText
        self.itemPromotion.text = viewModel.itemPromotion
        self.itemPrice.text = viewModel.itemPrice
        
        viewModel.setImage { (url, constant) in
            self.imageWidth.constant = constant
            if let imageUrl = url {
                self.logoImage.sd_setImage(with: URL.init(string: imageUrl), completed: nil)
            }else{
                self.logoImage.image = nil
            }
        }
    }
    
    @objc func onTouchAdView() {
        viewModel?.onTouchHotelAdItem?()
    }
}
