//
//  MessageSendTopicCell.swift
//  ColatourB2B
//
//  Created by M7635 on 2020/1/21.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

protocol MessageSendTopicCellDelegate: NSObjectProtocol {
    
    func didChange(topicText: String)
}

class MessageSendTopicCell: UITableViewCell {
    
    @IBOutlet weak var messageTopic: UITextView!
    
    weak var messageSendTopicCellDelegate: MessageSendTopicCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
        messageTopic.text = "請填寫"
        messageTopic.textColor = UIColor.lightGray
        messageTopic.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension MessageSendTopicCell: UITextViewDelegate {
    
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
            messageSendTopicCellDelegate?.didChange(topicText: newText)
        }
        
        return true
    }
}
