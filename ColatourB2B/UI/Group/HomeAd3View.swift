//
//  HomeAd3View.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/2/7.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

class HomeAd3View: UIView {
    
    @IBOutlet weak var itemText: UILabel!
    
    private var adItem: IndexResponse.ModuleItem?
    weak var delegate: HomeAd1ViewProcotol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    fileprivate func setUp() {
        let bundle = Bundle.init(for: self.classForCoder)
        let nib = UINib.init(nibName: "HomeAd3View", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
        let ges = UITapGestureRecognizer(target: self, action: #selector(onTouchAdView))
        self.addGestureRecognizer(ges)
        self.isUserInteractionEnabled = true
    }
    
    func setView(item: IndexResponse.ModuleItem, isFirst: Bool, isLast: Bool) {
        self.adItem = item
        self.itemText.text = item.itemText
    }
    @IBAction func action(_ sender: Any) {
        print("action")
    }
    
    @objc func onTouchAdView(){
        print("AAAA")
        self.delegate?.onTouchHotelAdItem(adItem: adItem!)
    }
}
