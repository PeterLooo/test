//
//  ToastView.swift
//  colatour
//
//  Created by M6853 on 2018/12/19.
//  Copyright © 2018 Colatour. All rights reserved.
//

import UIKit

class ToastView: UIView {
    @IBOutlet weak var toastLabel: UILabel!
    @IBOutlet weak var toastView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    private var defaultBottomHeight: CGFloat!
    
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
        let nib = UINib.init(nibName: "ToastView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
        self.isUserInteractionEnabled = false
        self.toastView.alpha = 0
        self.layoutIfNeeded()
        defaultBottomHeight = self.bottomConstraint.constant
        toastView.setBorder(width: 0, radius: 20.0, color: UIColor.clear)
    }
    
    func setToastHintText(text: String){
        self.toastLabel.text = text
    }
    
    func addToastViewBottomHeight(_ height: CGFloat){
        self.bottomConstraint.constant = defaultBottomHeight + height
    }
    
    func resetToastViewBottomHeight(){
        self.bottomConstraint.constant = defaultBottomHeight
    }
    
    func toast(text: String){
        self.toastLabel.text = text
        UIView.animate(withDuration: 0.5, animations: {
            self.toastView.alpha = 1
            self.layoutIfNeeded()
            
        }, completion: { after in
            if after {
                UIView.animate(withDuration: 0.5, delay: 2, options: .allowUserInteraction, animations: {
                    self.toastView.alpha = 0
                    self.layoutIfNeeded()
                })
            }
        })
    }
}
