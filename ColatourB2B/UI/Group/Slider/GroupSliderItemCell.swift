//
//  GroupSliderItemCell.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/25.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit

class GroupSliderItemCell: UITableViewCell {

    var onTouchDate: ((_ serverData: ServerData)->())?
    
    @IBOutlet weak var serverTitle: UILabel!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var titleBottomConstraint: NSLayoutConstraint!
    
    private var serverData: ServerData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let ges = UITapGestureRecognizer(target: self, action: #selector(onTouchDateAction))
        self.addGestureRecognizer(ges)
        self.isUserInteractionEnabled = true
    }

    func setCell(serverData: ServerData,
                 isNeedLine: Bool,
                 isFirst: Bool,
                 isLast: Bool){
        
        self.serverData = serverData
        self.serverTitle.text = serverData.linkName
        titleTopConstraint.constant = isFirst ? 26 : 12
        bottomViewHeight.constant = isNeedLine ? 1 : 0
        titleBottomConstraint.constant = isLast ? 26 : 12
    }
    
    @objc func onTouchDateAction(){
        self.onTouchDate?(self.serverData!)
    }
}
