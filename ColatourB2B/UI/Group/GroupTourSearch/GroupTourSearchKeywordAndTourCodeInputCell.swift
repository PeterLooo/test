//
//  GroupTourSearchKeywordAndTourCodeInputCell.swift
//  ColatourB2B
//
//  Created by M6853 on 2020/1/21.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

protocol GroupTourSearchKeywordAndTourCodeInputCellProtocol: NSObjectProtocol {
    func onTouchKeywordOrTourCodeView()
    func onKeywordOrTourCodeTextFieldDidChange(text: String)
}

class GroupTourSearchKeywordAndTourCodeInputCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var departureCity: UILabel!
    @IBOutlet weak var keywordOrTourCodeTextField: UITextField!
    @IBOutlet weak var searchByKeywordButton: UIButton!
    
    weak var delegate: GroupTourSearchKeywordAndTourCodeInputCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        let color = UIColor.init(named: "通用綠")!
        searchByKeywordButton.setBorder(width: 1, radius: 4, color: color)
        keywordOrTourCodeTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingDidEnd)
        keywordOrTourCodeTextField.addTarget(self, action: #selector(self.onTouchTextField), for: .editingDidBegin)
    }
    
    func setCellWith(groupTourSearchKeywordAndTourCodeRequest: GroupTourSearchKeywordAndTourCodeRequest) {
        
        self.departureCity.text = groupTourSearchKeywordAndTourCodeRequest.selectedDepartureCity?.value
        self.keywordOrTourCodeTextField.text = groupTourSearchKeywordAndTourCodeRequest.keywordOrTourCode
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        delegate?.onKeywordOrTourCodeTextFieldDidChange(text: textField.text ?? "")
    }
    
    @objc func onTouchTextField() {
        delegate?.onTouchKeywordOrTourCodeView()
    }
}
