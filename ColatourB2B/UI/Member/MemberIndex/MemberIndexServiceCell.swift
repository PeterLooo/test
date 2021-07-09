//
//  MemberIndexServiceCell.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/31.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit

class MemberIndexServiceCell: UITableViewCell {

    @IBOutlet weak var serverTitle: UILabel!
    
    private var viewModel : MemberIndexServiceCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let ges = UITapGestureRecognizer(target: self, action: #selector(onTouchServer))
        self.addGestureRecognizer(ges)
        self.isUserInteractionEnabled = true
    }
    
    func setCell(viewModel : MemberIndexServiceCellViewModel){
        self.viewModel = viewModel
        serverTitle.text = viewModel.serverData?.linkName
    }
    
    @objc func onTouchServer(){
        self.viewModel?.onTouchServer?()
    }
}
