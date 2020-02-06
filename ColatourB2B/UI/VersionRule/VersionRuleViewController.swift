//
//  VersionRuleViewController.swift
//  colatour
//
//  Created by M7268 on 2019/1/23.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit

protocol VersionRuleViewControllerProtocol {
    func onDismissVersionRuleViewController()
    func onDismissVersionRuleViewControllerCompletion()
}
class VersionRuleViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightButton: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var updateNowButtonLabel: UILabel!
    @IBOutlet weak var cancelButtonLabel: UILabel!
    @IBOutlet weak var immediatlyButtonLabel: UILabel!
    @IBOutlet weak var updateNowHeight: NSLayoutConstraint!
    @IBOutlet weak var cancelButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var immediatlyButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var updateNowButton: UIView!
    @IBOutlet weak var cancelButton: UIView!
    @IBOutlet weak var immediatlyButton: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var updateMessage: UILabel!
    var versionRule: VersionRuleReponse.Update!
    var delegate:VersionRuleViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurredBackgroundView = UIVisualEffectView()
        self.definesPresentationContext = false
        self.providesPresentationContextTransitionStyle = false
        blurredBackgroundView.frame = self.view.frame
        blurredBackgroundView.effect = UIBlurEffect(style: .light)
        view.insertSubview(blurredBackgroundView, belowSubview: shadowView)

        self.shadowView.setShadow(offset: CGSize(width:0, height:1), opacity: 0.4,shadowRadius: 20 )
        self.cancelButton.setBorder(width: 0.5, radius: 5, color: ColorHexUtil.hexColor(hex: "#00a3e0"))

        onBindVersionRule()
        setButton()
        setTabBarType(tabBarType: .hidden)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavType(navBarType: .hidden)
        self.setBarAlpha(alpha: 0, animate: true)
        super.viewWillAppear(animated)
    }
    
    func setVersionRule(versionRule:VersionRuleReponse.Update){
        self.versionRule = versionRule
    }
    
    func onBindVersionRule(){
        self.updateMessage.text = self.versionRule.updateMessage
        switch self.versionRule.updateMode {
        case "Maintain":
            self.immediatlyButton.isHidden = true
            self.cancelButton.isHidden = true
            self.updateNowButton.isHidden = true
            self.rightButton.isHidden = false
            self.titleLabel.text = "系統維護中！"
            self.imageView.image = UIImage(named: "remind_maintaining")
        case "Suggestion" :
            self.immediatlyButton.isHidden = true
            self.rightButton.isHidden = true
            self.cancelButton.isHidden = false
            self.updateNowButton.isHidden = false
            self.titleLabel.text = "提醒您該更新囉！"
            self.imageView.image = UIImage(named: "remind_refresh")
        case "Force" :
            self.immediatlyButton.isHidden = false
            self.cancelButton.isHidden = true
            self.updateNowButton.isHidden = true
            self.rightButton.isHidden = true
            self.titleLabel.text = "提醒您該更新囉！"
            self.imageView.image = UIImage(named: "remind_refresh")
        default:
            self.immediatlyButton.isHidden = true
            self.cancelButton.isHidden = true
            self.updateNowButton.isHidden = true
            self.rightButton.isHidden = false
            self.titleLabel.text = "系統維護中！"
            self.imageView.image = UIImage(named: "remind_maintaining")
        }
    }
    
    func setButton(){
        let cancel = UITapGestureRecognizer.init(target: self, action: #selector(self.cancel(_:)))
        self.cancelButton.addGestureRecognizer(cancel)
        
        let updateNow = UITapGestureRecognizer.init(target: self, action: #selector(self.updateNow(_:)))
        self.updateNowButton.addGestureRecognizer(updateNow)
        
        let immediatlyButton = UITapGestureRecognizer.init(target: self, action: #selector(self.updateNow(_:)))
        self.immediatlyButton.addGestureRecognizer(immediatlyButton)
        
        let rightButton = UITapGestureRecognizer.init(target: self, action: #selector(self.exitApp(_:)))
        self.rightButton.addGestureRecognizer(rightButton)
    }
    
    @objc func cancel(_ sender: UIButton) {
        if let updateNo = UserDefaultUtil.shared.updateNo {
            if updateNo < (self.versionRule.updateNo)!{
                UserDefaultUtil.shared.updateNo = self.versionRule.updateNo ?? 0
            }
        }else{
            UserDefaultUtil.shared.updateNo = self.versionRule.updateNo ?? 0
        }
        self.delegate?.onDismissVersionRuleViewController()
        self.dismiss(animated: true, completion: {
            self.delegate?.onDismissVersionRuleViewControllerCompletion()
        })
    }
    
    @objc func exitApp(_ sender: UIButton) {
        exit(0)
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
}
