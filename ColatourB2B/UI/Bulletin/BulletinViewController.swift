//
//  BulletinViewController.swift
//  colatour
//
//  Created by M7268 on 2019/1/21.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit
import SDWebImage

protocol BulletinViewControllerProtocol: BaseViewProtocol{
    func onTouchBulletinLink(linkType: LinkType, linkValue: String?, linkText: String?)
    func onDismissBulletinViewController()
    func onDismissBulletinViewControllerCompletion()
}

class BulletinViewController: BaseViewController {

    @IBOutlet weak var imageConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var cancelButtonView: UIView!
    @IBOutlet weak var offerButtonView: UIView!
    @IBOutlet weak var offerButtonLabel: UILabel!
    @IBOutlet weak var bulletinTitle: UILabel!
    @IBOutlet weak var bulletinContent: UILabel!
    @IBOutlet weak var bulletinImage: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var alertView: UIView!
    
    weak var delegate:BulletinViewControllerProtocol?
    var bulletin: BulletinResponse.Bulletin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBarAlpha(alpha: 0, animate: true)
        let blurredBackgroundView = UIVisualEffectView()
        self.definesPresentationContext = false
        self.providesPresentationContextTransitionStyle = false
        blurredBackgroundView.frame = self.view.frame
        blurredBackgroundView.effect = UIBlurEffect(style: .light)
        view.insertSubview(blurredBackgroundView, belowSubview: shadowView)

        self.shadowView.setShadow(offset: CGSize(width:0, height:1), opacity: 0.4,shadowRadius: 20 )
        
        setBulletin()
        addGesture()
    }
    
    func addGesture() {
        let cancel = UITapGestureRecognizer.init(target: self, action: #selector(self.cancel(_:)))
        let receive = UITapGestureRecognizer.init(target: self, action: #selector(self.onTouchBullatin(_:)))
        self.shadowView.addGestureRecognizer(receive)
        self.shadowView.isUserInteractionEnabled = true
        self.cancelButtonView.addGestureRecognizer(cancel)
        self.cancelButtonView.isUserInteractionEnabled = true
    }
    
    @objc func cancel(_ sender: UIButton) {
        delegate?.onDismissBulletinViewController()
        self.dismiss(animated: true, completion: {
            self.delegate?.onDismissBulletinViewControllerCompletion()
        })
    }
    
    @objc func onTouchBullatin(_ sender: UIButton) {
        self.delegate?.onDismissBulletinViewController()
        self.dismiss(animated: true, completion: self.presentBullatin)
    }
    
    func presentBullatin(){
        let linkType = self.bulletin?.linkType!
        let linkParams = self.bulletin?.actionParam ?? ""
        delegate?.onTouchBulletinLink(linkType: linkType!, linkValue: linkParams, linkText: "")
        delegate?.onDismissBulletinViewControllerCompletion()
    }
    
    func setVCWith(bulletin: BulletinResponse.Bulletin){
        self.bulletin = bulletin
    }
    
    func setBulletin(){
        self.bulletinTitle.text = self.bulletin.bulletinTitle
        self.bulletinContent.text = self.bulletin.bulletinContent

        self.offerButtonLabel.text = self.bulletin.actionName
        self.offerButtonView.isHidden = self.bulletin.actionName.isNilOrEmpty
        
        self.titleView.isHidden = bulletin.bulletinTitle.isNilOrEmpty && bulletin.bulletinContent.isNilOrEmpty
        
        if let picUrl = self.bulletin?.bulletinImage, let url = URL.init(string: picUrl) {
            let data: NSData! = NSData(contentsOf: url)
            if let data = data, let image = UIImage.init(data: data as Data) {
                let height = image.size.height
                let width = image.size.width
                let imageHeight = ((screenWidth - 54) / width) * height
           
                imageConstraintHeight.constant = imageHeight
                
                self.bulletinImage.image = image
                bulletinImage.contentMode = .scaleAspectFit
            } else {
                imageConstraintHeight.constant = 114
                bulletinImage.image = #imageLiteral(resourceName: "remind_announcement")
                bulletinImage.contentMode = .center
            }
        }else{
            imageConstraintHeight.constant = 114
            bulletinImage.image = #imageLiteral(resourceName: "remind_announcement")
            bulletinImage.contentMode = .center
        }
    }
}
