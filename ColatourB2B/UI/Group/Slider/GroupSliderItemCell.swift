//
//  GroupSliderItemCell.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/25.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit
protocol GroupSliderItemCellProtocol: NSObjectProtocol {
    func onTouchDate(serverData: GroupMenuResponse.ServerData)
}
class GroupSliderItemCell: UITableViewCell {

    @IBOutlet weak var serverTitle: UILabel!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    
    weak var delegate: GroupSliderItemCellProtocol?
    private var serverData: GroupMenuResponse.ServerData?
    override func awakeFromNib() {
        super.awakeFromNib()
        let ges = UITapGestureRecognizer(target: self, action: #selector(onTouchDate))
        self.addGestureRecognizer(ges)
        self.isUserInteractionEnabled = true
    }

    func setCell(serverData: GroupMenuResponse.ServerData, isNeedLine: Bool){
        self.serverData = serverData
        self.serverTitle.text = serverData.server
        bottomViewHeight.constant = isNeedLine ? 17 : 0
    }
    
    @objc func onTouchDate(){
        self.delegate?.onTouchDate(serverData: self.serverData!)
    }
}
