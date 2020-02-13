//
//  NotificationItemCell.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/2.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

protocol NotificationItemCellProtocol: NSObjectProtocol {
    func onTouchItem(item: NotiItem)
}

class NotificationItemCell: UITableViewCell {

    weak var delegate: NotificationItemCellProtocol?
    @IBOutlet weak var unReadView: UIView!
    @IBOutlet weak var notiTitle: UILabel!
    @IBOutlet weak var notiContent: UILabel!
    
    private var item: NotiItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let ges = UITapGestureRecognizer(target: self, action: #selector(onTouchItem))
        self.addGestureRecognizer(ges)
        self.isUserInteractionEnabled = true
    }
    
    func setCell(item: NotiItem) {
        self.item = item
        self.notiTitle.text = item.notiTitle
        self.notiContent.text = item.notiContent
        self.notiContent.numberOfLines = item.apiNotiType == "Message" ? 1 : 0
        self.unReadView.backgroundColor = item.unreadMark != false ? UIColor.init(named: "通用綠") : UIColor.white
    }
    
    @objc func onTouchItem(){
        unReadView.backgroundColor = UIColor.white
        self.delegate?.onTouchItem(item: self.item!)
    }
}
