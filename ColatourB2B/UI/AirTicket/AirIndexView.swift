//
//  AirIndexView.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2020/3/13.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

class AirIndexView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageSecView: UIImageView!
    @IBOutlet weak var imageThrView: UIImageView!
    @IBOutlet weak var itemText: UILabel!
    @IBOutlet weak var itemSecText: UILabel!
    @IBOutlet weak var itemThrText: UILabel!
    
    weak var delegate: HomeAd1ViewProcotol?
    
    private var adItem: IndexResponse.ModuleItem?
    private var adSecItem: IndexResponse.ModuleItem?
    private var adThrItem: IndexResponse.ModuleItem?
    
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
        let nib = UINib.init(nibName: "AirIndexView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
    }
    
    func setView(item: IndexResponse.ModuleItem, moduleIndex: Int) {
        
        switch moduleIndex {
        case 0:
            self.downImage(picUrl: item.picUrl ?? "", imageView: imageView)
            self.itemText.text = item.itemText
        case 1:
            self.downImage(picUrl: item.picUrl ?? "", imageView: imageSecView)
            self.itemSecText.text = item.itemText
        case 2:
            self.downImage(picUrl: item.picUrl ?? "", imageView: imageThrView)
            self.itemThrText.text = item.itemText
        default:
            ()
        }
    }
    
    private func downImage(picUrl:String, imageView:UIImageView){
        imageView.sd_setImage(with: URL.init(string: picUrl), completed: nil)
        
    }
}
