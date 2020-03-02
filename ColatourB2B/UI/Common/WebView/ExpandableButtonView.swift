//
//  ExpandableButtonView.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/2/27.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
import RxSwift

enum ExpandableButtonType {
    case Forward
    case DownloadWord
    case Share
    case Booking
}

protocol ExpandableButtonViewDelegate {
    func webViewTurnGraySwitch()
    func didTapExpandableButton(buttonType: ExpandableButtonType, url: URL)
}

class ExpandableButtonView: UIView {

    var delegate: ExpandableButtonViewDelegate?
    var baseButton = UIButton()
    var buttons: [UIButton] = []
    var buttonImages: [UIImage] = []
    var buttonURLs: [String] = []
    var openButtons = true
    
    var forwardURL: String = ""
    var downloadWordURL: String = ""
    var shareURL: String = ""
    var bookingURL: String = ""
    
    let openButtonsImage = UIImage(named: "b2b_fab")
    let closeButtonsImage = UIImage(named: "b2b_fab_close")
    
    let forwardImage = UIImage(named: "b2b_fab_forward")
    let downloadWordImage = UIImage(named: "b2b_fab_download_word")
    let shareImage = UIImage(named: "b2b_fab_share")
    let bookingImage = UIImage(named: "b2b_fab_form")

    func setUpButtons(shareList: WebViewTourShareResponse.ItineraryShareData) {
        
        forwardURL = shareList.forwardUrl ?? ""
        downloadWordURL = shareList.wordUrl ?? ""
        shareURL = shareList.shareUrl ?? ""
        bookingURL = shareList.bookingUrl ?? ""
        
        buttonURLs = [forwardURL, downloadWordURL, shareURL, bookingURL]
        buttonURLs = buttonURLs.filter {$0.isEmpty == false}
        
        for index in 0 ..< buttonURLs.count {
            
            switch buttonURLs[index] {
            case forwardURL:
                buttonImages.append(forwardImage!)
                
            case downloadWordURL:
                buttonImages.append(downloadWordImage!)
                
            case shareURL:
                buttonImages.append(shareImage!)
                
            case bookingURL:
                buttonImages.append(bookingImage!)
                
            default:
                ()
            }
        }
        
        baseButton.frame = CGRect(x: 0, y: 200, width: 56, height: 56)
        baseButton.setImage(openButtonsImage, for: .normal)
        baseButton.layer.backgroundColor = UIColor.systemGreen.cgColor
        baseButton.addTarget(self, action: #selector(onTouchBaseButton), for: .touchUpInside)
        buttonShadowStyle(button: baseButton)
        
        addSubview(baseButton)
        
        for index in 0 ..< buttonImages.count {
            
            let button = UIButton()
            let buttonImage = buttonImages[index]

            button.alpha = 0
            button.tag = index
            button.frame = CGRect(x: 8, y: 200, width: 40, height: 40)
            button.setImage(buttonImage, for: .normal)
            button.accessibilityValue = buttonURLs[index]
            button.layer.backgroundColor = UIColor.white.cgColor
            button.addTarget(self, action: #selector(onTouchButton(button:)), for: .touchUpInside)
            buttonShadowStyle(button: button)
            
            addSubview(button)
            buttons.append(button)
        }
    }
    
    func buttonShadowStyle(button: UIButton) {
        
        button.layer.cornerRadius = button.bounds.size.width / 2
        button.layer.shadowRadius = 2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
    }
    
    @objc func onTouchBaseButton() {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.buttons.forEach {
                $0.frame = CGRect(x: 8,
                                  y: (self.openButtons) ? (200 - 50 * (self.buttonImages.count - $0.tag)) : 200,
                                  width: 40, height: 40)
                $0.alpha = ($0.alpha == 0) ? 1 : 0
            }
            
            self.openButtons = !self.openButtons
        })
        
        delegate?.webViewTurnGraySwitch()
        baseButton.setImage((baseButton.currentImage == openButtonsImage ? closeButtonsImage : openButtonsImage), for: .normal)
    }
    
    @objc func onTouchButton(button: UIButton) {
        
        guard let okURL = URL(string: (button.accessibilityValue?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!) else { return }
        
        switch button.accessibilityValue {
        case forwardURL:
            self.delegate?.didTapExpandableButton(buttonType: .Forward, url: okURL)
            
        case downloadWordURL:
            self.delegate?.didTapExpandableButton(buttonType: .DownloadWord, url: okURL)
            
        case shareURL:
            self.delegate?.didTapExpandableButton(buttonType: .Share, url: okURL)
            
        case bookingURL:
            self.delegate?.didTapExpandableButton(buttonType: .Booking, url: okURL)

        default:
            ()
        }
        
        self.onTouchBaseButton()
    }
}
