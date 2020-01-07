//
//  MemberTopCell.swift
//  ColatourB2B
//
//  Created by M6985 on 2019/12/31.
//  Copyright © 2019 Colatour. All rights reserved.
//

import UIKit
protocol MemberTopCellProtocol: NSObjectProtocol {
    func onTouchLogout()
}
class MemberTopCell: UITableViewCell {

    @IBOutlet weak var logout: UIButton!
    @IBOutlet weak var topViewTitle: UILabel!
    @IBOutlet weak var topViewBackgroundView: UIView!
    
    weak var delegate: MemberTopCellProtocol?
    
    private var topViewGradientLayer: CAGradientLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        logout.setBorder(width: 0.8, radius: 14, color: UIColor.white)
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        reloadTopViewGradient()
    }
    
    func updateLayer(){
        reloadTopViewGradient()
    }

    func setCellWith(title: String?){
        self.topViewTitle.text = title
    }
    
    private func reloadTopViewGradient(){
        let colors = [UIColor(named: "TabBar綠"),UIColor(named: "通用綠")]
        self.contentView.layoutIfNeeded()
        
        topViewGradientLayer = CAGradientLayer()
        
        topViewGradientLayer.frame = self.bounds
        
        topViewGradientLayer.colors = colors.map({$0!.cgColor})
        topViewGradientLayer.opacity = 1
        topViewGradientLayer.startPoint = CGPoint(x: 0.0, y: -1.0)
        topViewGradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
       
        self.topViewBackgroundView.layer.sublayers?.forEach( { if $0 is CAGradientLayer { $0.removeFromSuperlayer() } } )
        self.topViewBackgroundView.layer.addSublayer(topViewGradientLayer)
        self.topViewBackgroundView.layer.zPosition = 0
    }
    
    @IBAction func onTouchLogout(_ sender: UIButton) {
        self.delegate?.onTouchLogout()
    }
}
