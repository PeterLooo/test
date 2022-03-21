//
//  GroupTourSearchKeywordAndTourCodeInputCell.swift
//  ColatourB2B
//
//  Created by M6853 on 2020/1/21.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

class GroupTourSearchKeywordAndTourCodeInputCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var departureCity: UILabel!
    @IBOutlet weak var keywordOrTourCodeTextField: UITextField!
    @IBOutlet weak var searchByKeywordButton: UIButton!
    
    private var viewModel: GroupTourSearchKeywordAndTourCodeRequest?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        let color = UIColor.init(named: "通用綠")!
        searchByKeywordButton.setBorder(width: 1, radius: 4, color: color)
        keywordOrTourCodeTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingDidEnd)
    }
    
    func setCellWith(groupTourSearchKeywordAndTourCodeRequest: GroupTourSearchKeywordAndTourCodeRequest) {
        viewModel = groupTourSearchKeywordAndTourCodeRequest
        self.departureCity.text = groupTourSearchKeywordAndTourCodeRequest.selectedDepartureCity?.departureName
        self.keywordOrTourCodeTextField.text = groupTourSearchKeywordAndTourCodeRequest.keywordOrTourCode
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        viewModel?.keywordOrTourCode = textField.text
    }
}
