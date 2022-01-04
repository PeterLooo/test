//
//  ConfirmKeyCell.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/6/29.
//  Copyright © 2021 Colatour. All rights reserved.
//

import UIKit

class ConfirmKeyCell: UITableViewCell {

    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var confirmKey: CustomTextField!
    @IBOutlet weak var receiveFail: UIButton!
    
    private var viewModel: ConfirmKeyCellViewModel? {
        didSet{
            viewModel?.confirmKeyAreError = { [weak self] keyError in
                self?.confirmKey.someController?.setErrorText(keyError, errorAccessibilityValue: nil)
                self?.confirmKey.becomeFirstResponder()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        receiveFail.setBorder(width: 1, radius: 4, color: UIColor.init(named: "通用綠"))
        confirmKey.addTarget(self, action: #selector(editComfirmKey), for: .editingChanged)
        confirmKey.someController?.placeholderText = "請輸入收信確認碼"
    }
    
    func setCell(viewModel: ConfirmKeyCellViewModel){
        self.viewModel = viewModel
        email.text = viewModel.email
        confirmKey.becomeFirstResponder()
    }
    
    @objc func editComfirmKey(){
        viewModel?.confirmKey = confirmKey.text
        confirmKey.someController?.setErrorText(nil, errorAccessibilityValue: nil)
    }

    @IBAction func onTouchConfirm(_ sender: Any) {
        viewModel?.checkConfirmKey()
    }
    
    @IBAction func receiveFail(_ sender: Any) {
        viewModel?.receiveFail?()
    }
}
