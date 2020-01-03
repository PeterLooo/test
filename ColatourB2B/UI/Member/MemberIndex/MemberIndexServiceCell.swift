//
//  MemberIndexServiceCell.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/31.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit
protocol MemberIndexServiceCellProtocol : NSObjectProtocol {
    func onTouchServer(server:ServerData)
}
class MemberIndexServiceCell: UITableViewCell {

    @IBOutlet weak var serverTitle: UILabel!
    
    weak var delegate : MemberIndexServiceCellProtocol?
    
    private var server: ServerData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let ges = UITapGestureRecognizer(target: self, action: #selector(onTouchServer))
        self.addGestureRecognizer(ges)
        self.isUserInteractionEnabled = true
    }

    func setCellWith(serverData:ServerData){
        self.server = serverData
        serverTitle.text = serverData.linkName
    }
    
    @objc func onTouchServer(){
        self.delegate?.onTouchServer(server: self.server!)
    }
    
}
