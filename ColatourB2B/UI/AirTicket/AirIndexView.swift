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
    @IBOutlet weak var leftToMidConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var midToRightConstraints: NSLayoutConstraint!
    @IBOutlet weak var safeAreaLeading: NSLayoutConstraint!
    @IBOutlet weak var safeAreaTrailing: NSLayoutConstraint!
    
    var viewModel: AirIndexViewModel?
    
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
        setImageStatus()
    }
    
    func setView(viewModel: AirIndexViewModel) {
        self.viewModel = viewModel
        
        self.downImage(picUrl: viewModel.adItem?.picUrl ?? "", imageView: imageView)
        self.itemText.text = viewModel.adItem?.itemText
        self.downImage(picUrl: viewModel.adSecItem?.picUrl ?? "", imageView: imageSecView)
        self.itemSecText.text = viewModel.adSecItem?.itemText
        self.downImage(picUrl: viewModel.adThrItem?.picUrl ?? "", imageView: imageThrView)
        self.itemThrText.text = viewModel.adThrItem?.itemText
        
        if viewModel.adSecItem != nil {
            self.imageSecView.isHidden = false
            self.itemSecText.isHidden = false
        }
        
        if viewModel.adThrItem != nil {
            self.imageThrView.isHidden = false
            self.itemThrText.isHidden = false
        }
    }
    
    private func setImageStatus() {
        leftToMidConstraints.constant = (screenWidth - 180) / 4
        midToRightConstraints.constant = (screenWidth - 180) / 4
        safeAreaLeading.constant = (screenWidth - 180) / 4
        safeAreaTrailing.constant = (screenWidth - 180) / 4
        self.imageView.contentMode = .scaleAspectFill
        self.imageSecView.contentMode = .scaleAspectFill
        self.imageThrView.contentMode = .scaleAspectFill
        self.imageSecView.isHidden = true
        self.imageThrView.isHidden = true
        self.itemSecText.isHidden = true
        self.itemThrText.isHidden = true
    }
    
    @IBAction func onTouchItem(_ sender: Any) {
        
        viewModel?.onTouchItem(tag: (sender as! UIButton).tag)
    }
    
    private func downImage(picUrl: String, imageView: UIImageView) {
        DispatchQueue.main.async {
            imageView.sd_setImage(with: URL.init(string: picUrl), completed: nil)
        }
    }
}
