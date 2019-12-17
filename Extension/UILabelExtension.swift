//
//  UILabelExtension.swift
//  colatour
//
//  Created by M6853 on 2018/10/30.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit

extension UILabel {

    private func isHeightTallerThanNotExpandHeight(text: String, fitWidth: CGFloat, notExpandNumberOfLines: Int) -> Bool {
        let countLabel = UILabel(frame: CGRect(x: 0, y: 0, width: fitWidth, height: CGFloat.greatestFiniteMagnitude))
        countLabel.text = text
        countLabel.numberOfLines = 0
        countLabel.font = UIFont.systemFont(ofSize: 14.0)
        let expandFittingSize = countLabel.sizeThatFits(CGSize(width: fitWidth, height: CGFloat.greatestFiniteMagnitude))
        let expandHeight = expandFittingSize.height
        
        countLabel.numberOfLines = notExpandNumberOfLines
        
        let notExpandFittingSize = countLabel.sizeThatFits(CGSize(width: fitWidth, height: CGFloat.greatestFiniteMagnitude))
        let notExpandHeight = notExpandFittingSize.height
        
        return expandHeight > notExpandHeight
    }
    
    func drawDeleteLine() {
        if self.text.isNilOrEmpty { return }
        let deletelineRange = NSMakeRange(0, (self.text?.count)!)
        let attributedDeleteLine = NSMutableAttributedString(string: self.text!)
        attributedDeleteLine.addAttribute(NSAttributedStringKey.strikethroughStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: deletelineRange)
        self.attributedText = attributedDeleteLine
    }
    
    func addUnderLine(){
        if self.text.isNilOrEmpty { return }
        let underlineRange = NSMakeRange(0, (self.text?.count)!)
        let attributedUnderline = NSMutableAttributedString(string: self.text!)
        attributedUnderline.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: underlineRange)
        self.attributedText = attributedUnderline
    }
    
    func removeUnderLine(){
        if self.text.isNilOrEmpty { return }
        let underlineRange = NSMakeRange(0, (self.text?.count)!)
        let attributedUnderline = NSMutableAttributedString(string: self.text!)
        attributedUnderline.removeAttribute(NSAttributedStringKey.underlineStyle, range: underlineRange)
        self.attributedText = attributedUnderline
    }
}
