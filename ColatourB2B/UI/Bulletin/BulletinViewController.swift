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
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleStackView: UIStackView!
    @IBOutlet weak var actionButtonStackView: UIStackView!
    @IBOutlet weak var actionButtonLabel: UILabel!
    @IBOutlet weak var bulletinTitle: UILabel!
    @IBOutlet weak var bulletinContent: UILabel!
    @IBOutlet weak var bulletinImage: UIImageView!
    
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
        view.insertSubview(blurredBackgroundView, belowSubview: cardView)

        self.cardView.setShadow(offset: CGSize(width:0, height:1), opacity: 0.4,shadowRadius: 20 )
        
        setBulletin()
        addGesture()
    }
    
    func setVCWith(bulletin: BulletinResponse.Bulletin){
        self.bulletin = bulletin
    }
    
    private func setBulletin(){
        self.bulletinTitle.text = self.bulletin.bulletinTitle
        self.bulletinContent.text = self.bulletin.bulletinContent

        self.actionButtonLabel.text = self.bulletin.actionName
        self.actionButtonStackView.isHidden = self.bulletin.actionName.isNilOrEmpty
        
        self.titleStackView.isHidden = bulletin.bulletinTitle.isNilOrEmpty && bulletin.bulletinContent.isNilOrEmpty
        
        if let picUrl = self.bulletin?.bulletinImage, let url = URL.init(string: picUrl) {
            let data: NSData! = NSData(contentsOf: url)
            if let data = data, let image = UIImage.init(data: data as Data) {
                let height = image.size.height
                let width = image.size.width
                let imageHeight = ((screenWidth - 54) / width) * height
           
                self.imageHeight.constant = imageHeight
                
                self.bulletinImage.image = image
                bulletinImage.contentMode = .scaleAspectFit
            } else {
                imageHeight.constant = 114
                bulletinImage.image = #imageLiteral(resourceName: "remind_announcement")
                bulletinImage.contentMode = .center
            }
        }else{
            imageHeight.constant = 114
            bulletinImage.image = #imageLiteral(resourceName: "remind_announcement")
            bulletinImage.contentMode = .center
        }
    }
    
    private func addGesture() {
        let cancel = UITapGestureRecognizer.init(target: self, action: #selector(self.onTouchCancel(_:)))
        let receive = UITapGestureRecognizer.init(target: self, action: #selector(self.onTouchBulletin(_:)))
        self.cardView.addGestureRecognizer(receive)
        self.cardView.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(cancel)
        self.view.isUserInteractionEnabled = true
    }
    
    @objc func onTouchCancel(_ sender: UIButton) {
        delegate?.onDismissBulletinViewController()
        self.dismiss(animated: true, completion: {
            self.delegate?.onDismissBulletinViewControllerCompletion()
        })
    }
    
    @objc func onTouchBulletin(_ sender: UIButton) {
        self.delegate?.onDismissBulletinViewController()
        self.dismiss(animated: true, completion: self.handleLinkType)
    }
    
    private func handleLinkType(){
        let linkType = self.bulletin?.linkType!
        let linkParams = self.bulletin?.actionParam ?? ""
        delegate?.onTouchBulletinLink(linkType: linkType!, linkValue: linkParams, linkText: "")
        delegate?.onDismissBulletinViewControllerCompletion()
    }
}
