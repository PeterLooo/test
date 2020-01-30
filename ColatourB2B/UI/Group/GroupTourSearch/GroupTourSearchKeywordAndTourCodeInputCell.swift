//
//  GroupTourSearchKeywordAndTourCodeInputCell.swift
//  ColatourB2B
//
//  Created by M6853 on 2020/1/21.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

protocol GroupTourSearchKeywordAndTourCodeInputCellProtocol: NSObjectProtocol {
    func onTouchKeywordOrTourCodeView(_ sender: UIButton)
    func onKeywordOrTourCodeTextFieldDidChange(text: String)
}

class GroupTourSearchKeywordAndTourCodeInputCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var bookingTourCheckBoxImageView: UIImageView!

    @IBOutlet weak var departureCity: UILabel!
    @IBOutlet weak var keywordOrTourCodeTextField: UITextField!
    
    @IBOutlet weak var searchByKeywordButton: UIButton!
    
    weak var delegate: GroupTourSearchKeywordAndTourCodeInputCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        let color = UIColor.init(named: "通用綠")!
        searchByKeywordButton.setBorder(width: 1, radius: 4, color: color)
        keywordOrTourCodeTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingDidEnd)
    }
    
    func setCellWith(groupTourSearchKeywordAndTourCodeRequest: GroupTourSearchKeywordAndTourCodeRequest)
    {
        
        self.departureCity.text = groupTourSearchKeywordAndTourCodeRequest
            .selectedDepartureCity?
            .departureName
        
        self.keywordOrTourCodeTextField.text = groupTourSearchKeywordAndTourCodeRequest.keywordOrTourCode
    }
    
    @IBAction func onTouchKeywordOrTourCode(_ sender: UIButton) {
        delegate?.onTouchKeywordOrTourCodeView(sender)
        keywordOrTourCodeTextField.becomeFirstResponder()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        delegate?.onKeywordOrTourCodeTextFieldDidChange(text: textField.text ?? "")
    }
}
