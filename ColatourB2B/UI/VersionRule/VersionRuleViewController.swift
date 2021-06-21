//
//  VersionRuleViewController.swift
//  colatour
//
//  Created by M7268 on 2019/1/23.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit

class VersionRuleViewController: BaseViewController {
    
    var onDismissVersionRuleViewController: (()->())?
    var onDismissVersionRuleViewControllerCompletion: (()->())?
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var updateMessage: UILabel!
    @IBOutlet weak var updateNowButton: UIView!
    @IBOutlet weak var updateLaterButton: UIView!
    @IBOutlet weak var immediatlyUpdateButton: UIView!
    @IBOutlet weak var confirmButton: UIView!

    private var versionRule: VersionRuleReponse.Update!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurredBackgroundView = UIVisualEffectView()
        self.definesPresentationContext = false
        self.providesPresentationContextTransitionStyle = false
        blurredBackgroundView.frame = self.view.frame
        blurredBackgroundView.effect = UIBlurEffect(style: .light)
        view.insertSubview(blurredBackgroundView, belowSubview: cardView)

        self.cardView.setShadow(offset: CGSize(width:0, height:1), opacity: 0.4,shadowRadius: 20 )
        self.updateLaterButton.setBorder(width: 0.5, radius: 5, color: ColorHexUtil.hexColor(hex: "#00a3e0"))
        
        setNavType(navBarType: .hidden)
        setBarAlpha(alpha: 0, animate: true)
        setTabBarType(tabBarType: .hidden)

        onBindVersionRule()
        addButtonGesture()
    }
    
    func setVersionRule(versionRule:VersionRuleReponse.Update){
        self.versionRule = versionRule
    }
    
    func onBindVersionRule(){
        self.updateMessage.text = self.versionRule.updateMessage
        switch self.versionRule.updateMode {
        case "Maintain":
            self.immediatlyUpdateButton.isHidden = true
            self.updateLaterButton.isHidden = true
            self.updateNowButton.isHidden = true
            self.confirmButton.isHidden = false
            self.titleLabel.text = "系統維護中！"
            self.imageView.image = UIImage(named: "remind_maintaining")
        case "Suggestion" :
            self.immediatlyUpdateButton.isHidden = true
            self.confirmButton.isHidden = true
            self.updateLaterButton.isHidden = false
            self.updateNowButton.isHidden = false
            self.titleLabel.text = "提醒您該更新囉！"
            self.imageView.image = UIImage(named: "remind_refresh")
        case "Force" :
            self.immediatlyUpdateButton.isHidden = false
            self.updateLaterButton.isHidden = true
            self.updateNowButton.isHidden = true
            self.confirmButton.isHidden = true
            self.titleLabel.text = "提醒您該更新囉！"
            self.imageView.image = UIImage(named: "remind_refresh")
        default:
            self.immediatlyUpdateButton.isHidden = true
            self.updateLaterButton.isHidden = true
            self.updateNowButton.isHidden = true
            self.confirmButton.isHidden = false
            self.titleLabel.text = "系統維護中！"
            self.imageView.image = UIImage(named: "remind_maintaining")
        }
    }
    
    func addButtonGesture(){
        let updateLater = UITapGestureRecognizer.init(target: self, action: #selector(self.cancel(_:)))
        self.updateLaterButton.addGestureRecognizer(updateLater)
        
        let updateNow = UITapGestureRecognizer.init(target: self, action: #selector(self.updateNow(_:)))
        self.updateNowButton.addGestureRecognizer(updateNow)
        
        let immediatlyUpdate = UITapGestureRecognizer.init(target: self, action: #selector(self.updateNow(_:)))
        self.immediatlyUpdateButton.addGestureRecognizer(immediatlyUpdate)
        
        let confirm = UITapGestureRecognizer.init(target: self, action: #selector(self.exitApp(_:)))
        self.confirmButton.addGestureRecognizer(confirm)
    }
    
    @objc func cancel(_ sender: UIButton) {
        if let updateNo = UserDefaultUtil.shared.updateNo {
            if updateNo < (self.versionRule.updateNo)!{
                UserDefaultUtil.shared.updateNo = self.versionRule.updateNo ?? 0
            }
        }else{
            UserDefaultUtil.shared.updateNo = self.versionRule.updateNo ?? 0
        }
        
        self.dismiss(animated: true, completion: {
            self.onDismissVersionRuleViewControllerCompletion?()
        })
    }
    
    @objc func updateNow(_ sender: UIButton) {
        let urlString = self.versionRule.updateUrl
        if let url = URL(string: urlString!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @objc func exitApp(_ sender: UIButton) {
        exit(0)
    }
}
