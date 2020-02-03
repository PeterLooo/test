//
//  NoticeDetailContentCell.swift
//  ColatourB2B
//
//  Created by M6853 on 2020/1/9.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

class NoticeDetailContentCell: UITableViewCell {
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var groupNo: UILabel!
    @IBOutlet weak var orderNo: UILabel!
    @IBOutlet weak var sendUser: UILabel!
    @IBOutlet weak var messageDate: UILabel!
    
    @IBOutlet weak var groupNoView: UIView!
    @IBOutlet weak var orderNoView: UIView!
    @IBOutlet weak var sendUserView: UIView!
    @IBOutlet weak var messageDateView: UIView!
    
    func setCellWith(noticeDetail: NoticeDetailResponse.NoticeDetail) {
        borderView.setBorder(width: 1, radius: 4, color: ColorHexUtil.hexColor(hex: "#e7e7e7"))
        contentLabel.text = noticeDetail.content ?? ""
        groupNo.text = noticeDetail.groupNo ?? ""
        orderNo.text = noticeDetail.orderNo ?? ""
        sendUser.text = noticeDetail.sendUser ?? ""
        messageDate.text = noticeDetail.messageDate ?? ""
        
        groupNoView.isHidden = noticeDetail.groupNo.isNilOrEmpty
        orderNoView.isHidden = noticeDetail.orderNo.isNilOrEmpty
        sendUserView.isHidden = noticeDetail.sendUser.isNilOrEmpty
        messageDateView.isHidden = noticeDetail.messageDate.isNilOrEmpty
    }
}
