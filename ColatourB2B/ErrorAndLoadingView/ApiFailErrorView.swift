//
//  ApiFailErrorView.swift
//  colatour
//
//  Created by M6853 on 2018/3/9.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit

class ApiFailErrorView: UIView {
    
    weak var delegate: BaseViewProtocol?
    
    var loadData: (()->())?
    var onTouchServiceAction: (()->())?
    
    @IBOutlet weak var midReload: UIButton!
    @IBOutlet weak var midService: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUp()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    fileprivate func setUp(){
        let bundle = Bundle.init(for: self.classForCoder)
        let nib = UINib.init(nibName: "ApiFailErrorView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        setButtonBorder()
    }
    
    func setUpApiFailErrorView(){
        self.isHidden = true
        self.midReload.addTarget(self, action: #selector(self.onTouchReload), for: .touchUpInside)
        self.midService.addTarget(self, action: #selector(self.onTouchService), for: .touchUpInside)
    }
    
    func setButtonBorder(){
        self.midService.setBorder(width: 1, radius: 21, color: UIColor.init(named: "通用綠"))
    }
    
    @objc func onTouchReload(){
        self.delegate?.loadData()
        self.loadData?()
    }
    
    @objc func onTouchService(){
        self.delegate?.onTouchService()
        self.onTouchServiceAction?()
    }
}
