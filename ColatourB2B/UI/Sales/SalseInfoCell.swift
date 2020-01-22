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
    @IBOutlet weak var salseTitle: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var ext: UILabel!
    @IBOutlet weak var dedicatedLine: UILabel!
    @IBOutlet weak var nameAndMobile: UITextView!
    @IBOutlet weak var email: UITextView!
    @IBOutlet weak var introduction: UITextView!
    @IBOutlet weak var borderTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var borderBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var introTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var nameAndMobileHeight: NSLayoutConstraint!
    @IBOutlet weak var emailHeight: NSLayoutConstraint!
    
    weak var delegate: SalseInfoCellProtocol?
    
    private var sales: SalesResponse.Sales?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        borderView.setBorder(width: 1, radius: 4, color: ColorHexUtil.hexColor(hex: "e7e7e7"))
        comment.setBorder(width: 1, radius: 15, color: UIColor.init(named: "通用綠"))
        
        let phoneGes = UITapGestureRecognizer(target: self, action: #selector(onTouchPhone))
        self.phone.addGestureRecognizer(phoneGes)
        self.phone.isUserInteractionEnabled = true
        
        let dedicatedGes = UITapGestureRecognizer(target: self, action: #selector(onTouchDedicatedLine))
        self.dedicatedLine.addGestureRecognizer(dedicatedGes)
        self.dedicatedLine.isUserInteractionEnabled = true
    }
    
    @objc func onTouchPhone(){
        if let phone = self.sales?.officePhone , let url = URL.init(string: "tel://\(phone)") {
            self.delegate?.onTouchPhoneNum(url: url)
        }
    }
    
    @objc func onTouchDedicatedLine() {
        if let dedicatedLine = self.sales?.directPhone , let url = URL.init(string: "tel://\(dedicatedLine)") {
            self.delegate?.onTouchPhoneNum(url: url)
        }
    }
    
    func setCell(sales:SalesResponse.Sales,
                 isFirst: Bool,
                 isLast: Bool) {
        self.sales = sales
        salseTitle.text = sales.salesType
        nameAndMobile.text = "\(sales.salesName ?? "")      \(sales.mobilePhone ?? "")"
        phone.text = sales.officePhone
        ext.text = sales.officePhoneExt
        email.text = sales.emailAddress
        introduction.text = sales.sopMemo
        dedicatedLine.text = sales.directPhone
        
        borderTopConstraint.constant = isFirst ? 16 : 5
        borderBottomConstraint.constant = isLast ? 40 : 5
        setTextViewConstant()
    }
    
    private func setTextViewConstant() {
        let textViewWidth = screenWidth - 64
        introduction.textContainerInset = .zero
        nameAndMobile.textContainerInset = .zero
        email.textContainerInset = .zero
        
        introTextViewHeight.constant = getLabelHeight(text: sales!.sopMemo!, font: UIFont.init(thickness: .regular, size: 15), width: textViewWidth)
        nameAndMobileHeight.constant = getLabelHeight(text: "\(sales!.salesName ?? "")      \(sales!.mobilePhone ?? "")", font: UIFont.init(thickness: .regular, size: 15), width: textViewWidth)
        emailHeight.constant = getLabelHeight(text: sales!.emailAddress!, font: UIFont.init(thickness: .regular, size: 15), width: textViewWidth)
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


