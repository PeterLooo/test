//
//  NotificationItemCell.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/2.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

class NotificationItemCell: UITableViewCell {

    @IBOutlet weak var unReadView: UIView!
    @IBOutlet weak var notiTitle: UILabel!
    @IBOutlet weak var notiContent: UILabel!
    @IBOutlet weak var notiDate: UILabel!
    
    private var viewModel: NotiItemViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let ges = UITapGestureRecognizer(target: self, action: #selector(onTouchItem))
        self.addGestureRecognizer(ges)
        self.isUserInteractionEnabled = true
    }
    
    func setCell(viewModel: NotiItemViewModel) {
        self.viewModel = viewModel
        self.notiTitle.text = viewModel.notiTitle
        self.notiContent.text = viewModel.notiContent
        self.notiContent.numberOfLines = viewModel.apiNotiType == "Message" ? 1 : 0
        self.notiDate.text = viewModel.notiDate
        self.unReadView.backgroundColor = viewModel.unreadMark != false ? UIColor.init(named: "通用綠") : UIColor.white
    }
    
    @objc func onTouchItem(){
        unReadView.backgroundColor = UIColor.white
        viewModel?.onTouchItem?()
    }
}
