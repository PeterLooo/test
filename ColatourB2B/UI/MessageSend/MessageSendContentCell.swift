//
//  MessageSendContentCell.swift
//  ColatourB2B
//
//  Created by M7635 on 2020/1/21.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

protocol MessageSendContentCellDelegate: NSObjectProtocol {
    
    func didChange(contentText: String)
}

class MessageSendContentCell: UITableViewCell {
    
    @IBOutlet weak var messageContent: UITextView!
    
    weak var messageSendContentCellDelegate: MessageSendContentCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        messageContent.text = "請填寫"
        messageContent.textColor = UIColor.lightGray
        messageContent.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        messageContent.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension MessageSendContentCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty == true {
            
            textView.text = "請填寫"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if let originalText = textView.text, let range = Range(range, in: originalText) {
            
            let newText = originalText.replacingCharacters(in: range, with: text)
            messageSendContentCellDelegate?.didChange(contentText: newText)
        }
        
        return true
    }
}
