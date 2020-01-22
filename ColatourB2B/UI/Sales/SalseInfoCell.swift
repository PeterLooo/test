//
//  SalseInfoCell.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/10.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
protocol SalseInfoCellProtocol: NSObjectProtocol {
    func onTouchComment(sales: SalesResponse.Sales)
    func onTouchLine(sales: SalesResponse.Sales)
    func onTouchPhoneNum(url:URL)
}
class SalseInfoCell: UITableViewCell {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var comment: UIButton!
    @IBOutlet weak var lineMessage: UIButton!
    @IBOutlet weak var salesType: UILabel!
    @IBOutlet weak var officePhone: UILabel!
    @IBOutlet weak var officePhoneExt: UILabel!
    @IBOutlet weak var directPhone: UILabel!
    @IBOutlet weak var salesNameAndMobilePhone: UITextView!
    @IBOutlet weak var emailAddress: UITextView!
    @IBOutlet weak var sopMemo: UITextView!
    @IBOutlet weak var borderTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var borderBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var introTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var salesNameAndMobilePhoneHeight: NSLayoutConstraint!
    @IBOutlet weak var emailAddressHeight: NSLayoutConstraint!
    
    weak var delegate: SalseInfoCellProtocol?
    
    private var sales: SalesResponse.Sales?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        borderView.setBorder(width: 1, radius: 4, color: ColorHexUtil.hexColor(hex: "e7e7e7"))
        comment.setBorder(width: 1, radius: 15, color: UIColor.init(named: "通用綠"))
        
        let officePhoneGes = UITapGestureRecognizer(target: self, action: #selector(onTouchOfficePhone))
        self.officePhone.addGestureRecognizer(officePhoneGes)
        self.officePhone.isUserInteractionEnabled = true
        
        let directPhoneGes = UITapGestureRecognizer(target: self, action: #selector(onTouchDirectPhone))
        self.directPhone.addGestureRecognizer(directPhoneGes)
        self.directPhone.isUserInteractionEnabled = true
    }
    
    @objc func onTouchOfficePhone(){
        if let officePhone = self.sales?.officePhone , let url = URL.init(string: "tel://\(officePhone)") {
            self.delegate?.onTouchPhoneNum(url: url)
        }
    }
    
    @objc func onTouchDirectPhone() {
        if let directPhone = self.sales?.directPhone , let url = URL.init(string: "tel://\(directPhone)") {
            self.delegate?.onTouchPhoneNum(url: url)
        }
    }
    
    func setCell(sales:SalesResponse.Sales,
                 isFirst: Bool,
                 isLast: Bool) {
        self.sales = sales
        salesType.text = sales.salesType
        salesNameAndMobilePhone.text = "\(sales.salesName ?? "")      \(sales.mobilePhone ?? "")"
        officePhone.text = sales.officePhone
        officePhoneExt.text = sales.officePhoneExt
        emailAddress.text = sales.emailAddress
        sopMemo.text = sales.sopMemo
        directPhone.text = sales.directPhone
        
        borderTopConstraint.constant = isFirst ? 16 : 5
        borderBottomConstraint.constant = isLast ? 40 : 5
        setTextViewConstant()
    }
    
    private func setTextViewConstant() {
        let textViewWidth = screenWidth - 64
        sopMemo.textContainerInset = .zero
        salesNameAndMobilePhone.textContainerInset = .zero
        emailAddress.textContainerInset = .zero
        
        introTextViewHeight.constant = getLabelHeight(text: sales!.sopMemo!, font: UIFont.init(thickness: .regular, size: 15), width: textViewWidth)
        salesNameAndMobilePhoneHeight.constant = getLabelHeight(text: "\(sales!.salesName ?? "")      \(sales!.mobilePhone ?? "")", font: UIFont.init(thickness: .regular, size: 15), width: textViewWidth)
        emailAddressHeight.constant = getLabelHeight(text: sales!.emailAddress!, font: UIFont.init(thickness: .regular, size: 15), width: textViewWidth)
    }
    
    @IBAction func onTouchComment(_ sender: Any) {
        self.delegate?.onTouchComment(sales: self.sales!)
    }
    
    @IBAction func onTouchLine(_ sender: Any) {
        self.delegate?.onTouchLine(sales: self.sales!)
    }
    
    private func getLabelHeight(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
}


