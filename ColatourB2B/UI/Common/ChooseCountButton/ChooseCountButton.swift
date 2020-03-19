//
//  ChooseCountButton.swift
//  colatour
//
//  Created by M6853 on 2018/5/31.
//  Copyright © 2018年 Colatour. All rights reserved.
//

import UIKit

protocol ChooseCountButtonProtocol: NSObjectProtocol {
    
   func onChangeCount()
}
protocol ChooseCountButtonProtocolForHotel: NSObjectProtocol {
    
    func onChangeCount(view:UIView)
}
class ChooseCountButton: UIView {
 
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var plus: UIButton!
    @IBOutlet weak var minus: UIButton!
    
    weak var delegate: ChooseCountButtonProtocol?
    weak var delegateForHotel: ChooseCountButtonProtocolForHotel?
    var count = 0
    var limitFlour: Int?
    var allowSaleMark: Bool?
    var lowLimit: Int?
    
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
        let nib = UINib.init(nibName: "ChooseCountButton", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width , height: view.frame.height)
        setButtonStatus()
        self.addSubview(view)
    }
    
    func setButtonStatus(){
        plus.setImage(#imageLiteral(resourceName: "count_plus").withRenderingMode(.alwaysOriginal), for: .normal)
        minus.setImage(#imageLiteral(resourceName: "count_minor").withRenderingMode(.alwaysOriginal), for: .normal)
        plus.setImage(#imageLiteral(resourceName: "count_plus_unavailable").withRenderingMode(.alwaysOriginal), for: .disabled)
        minus.setImage(#imageLiteral(resourceName: "count_minor_unavailable").withRenderingMode(.alwaysOriginal), for: .disabled)
        plus.setImage(#imageLiteral(resourceName: "count_plus_unavailable").withRenderingMode(.alwaysOriginal), for: .highlighted)
        minus.setImage(#imageLiteral(resourceName: "count_minor_unavailable").withRenderingMode(.alwaysOriginal), for: .highlighted)
        plus.showsTouchWhenHighlighted = true
        minus.showsTouchWhenHighlighted = true
    }
    
    func setChooseCountButton(count : Int, allowSaleMark:Bool){
        self.allowSaleMark = allowSaleMark
        self.count = count
        self.countLabel.text = "\(count)"
        setButtonEnableAndColor()
    }
    
    func setButtonEnableAndColor(){
        if self.allowSaleMark == false{
            unableButton(button: plus)
            unableButton(button: minus)
        } else {
            if self.count == 0 && self.limitFlour == 0{
                unableButton(button: plus)
                unableButton(button: minus)
            } else if self.count == self.limitFlour {
                enableButton(button: minus)
                unableButton(button: plus)
            } else if self.count == 0 || self.count == self.lowLimit{
                enableButton(button: plus)
                unableButton(button: minus)
            } else {
                enableButton(button: plus)
                enableButton(button: minus)
            }
        }
    }
    
    private func enableButton(button: UIButton){
        button.isEnabled = true
    }
    
    private func unableButton(button: UIButton){
        button.isEnabled = false
    }
    
    @IBAction func plus(_ sender: UIButton) {
        count += 1
        self.countLabel.text = "\(count)"
        setButtonEnableAndColor()
        self.delegate?.onChangeCount()
        self.delegateForHotel?.onChangeCount(view: self)
    }
    
    @IBAction func minus(_ sender: UIButton) {
        count -= 1
        if (count < 0) { count = 0 }
        self.countLabel.text = "\(count)"
        setButtonEnableAndColor()
        self.delegate?.onChangeCount()
        self.delegateForHotel?.onChangeCount(view: self)
    }
    
}
