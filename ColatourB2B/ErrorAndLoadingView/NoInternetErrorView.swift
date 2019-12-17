//
//  NoInternetView.swift
//  colatour
//
//  Created by M6853 on 2018/3/9.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit

class NoInternetErrorView: UIView {
    @IBOutlet weak var reload: UIButton!
    weak var delegate: BaseViewProtocol?
    
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
        let nib = UINib.init(nibName: "NoInternetErrorView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    func setUpNoInternetErrorView(){
        self.isHidden = true
        self.reload.addTarget(self, action: #selector(self.onTouchReload), for: .touchUpInside)
    }
    
    @objc func onTouchReload(){
        self.delegate?.loadData()
    }
}
