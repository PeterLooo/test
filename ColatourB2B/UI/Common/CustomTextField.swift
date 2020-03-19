
//
//  CustomTextField.swift
//  colatour
//
//  Created by M6853 on 2018/5/29.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields
import MaterialComponents.MDCTextInputControllerUnderline

class CustomTextField: MDCTextField {
    var someController: MDCTextInputControllerUnderline?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp()
    }
    
    func setUp() {
        someController = MDCTextInputControllerUnderline(textInput: self)
        someController?.placeholderText = "SomethingHere"
        someController?.borderFillColor = UIColor.white
        someController?.textInput?.updateConstraints()
        someController?.textInputFont = UIFont(name:  "PingFangTC-Regular", size: 15)
        someController?.normalColor = UIColor.init(red: 151, green: 151, blue: 151, a: 0.31)
        someController?.activeColor = UIColor(named: "TabBar綠")
        someController?.floatingPlaceholderActiveColor = ColorHexUtil.hexColor(hex: "#6e6e6e")
        
    }
    
    func setRightArrowView(isHidden: Bool){
        switch isHidden {
        case true:
            self.rightViewMode = .never
            self.rightView = nil
        case false:
            self.rightViewMode = .always
            self.rightView = UIImageView(image: #imageLiteral(resourceName: "arrow drop down"))
        }
    }
}
