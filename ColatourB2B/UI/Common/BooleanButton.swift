//
//  BooleanButton.swift
//  colatour
//
//  Created by M3758 on 2018/2/21.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit
@IBDesignable
class BooleanButton: UIButton {
    var valueChange: ((Bool)->Void)?

    @IBInspectable var isSelect:Bool = false {
        didSet {
            self.resetImage()
        }
    }
    
    @IBInspectable var selectImage:UIImage = #imageLiteral(resourceName: "member_code_reveal") {
        didSet {
            self.resetImage()
        }
    }
    
    @IBInspectable var nonSelecImage:UIImage = #imageLiteral(resourceName: "member_code_hide") {
        didSet {
            self.resetImage()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp()
    }
    
    func setUp() {
        self.addTarget(self, action: #selector(BooleanButton.tap), for: .touchUpInside)
        self.resetImage()
    }
    
    @objc func tap() {
        self.isSelect = !isSelect
        if let v = valueChange {
            v(isSelect)
        }
    }
    
    func setStatus(isSelect: Bool, valueChange: ((Bool)->Void)?) {
        self.isSelect = isSelect
        self.valueChange = valueChange
    }
    
    func resetImage() {
        let image = (isSelect) ? selectImage : nonSelecImage
        self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 0)
        self.setImage(image, for: .normal)
    }
}
