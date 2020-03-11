//
//  LccCell.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2020/3/10.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
protocol LccCellProtocol: NSObjectProtocol {
    func onTouchRadio(isToAndFor:Bool)
    func onTouchDate()
    func onTouchAirlineSwitch()
}
class LccCell: UITableViewCell {

    @IBOutlet weak var toAndForRadio: UIImageView!
    @IBOutlet weak var oneWayRadio: UIImageView!
    @IBOutlet weak var tourDate: UILabel!
    @IBOutlet weak var sameAirlineSwitch: UISwitch!
    
    weak var delegate: LccCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCell(lccInfo:LCCTicketRequest){
        toAndForRadio.image = lccInfo.isToAndFro ? #imageLiteral(resourceName: "radio_on"):#imageLiteral(resourceName: "radio_off")
        oneWayRadio.image = lccInfo.isToAndFro ? #imageLiteral(resourceName: "radio_off"):#imageLiteral(resourceName: "radio_on")
        tourDate.text = lccInfo.isToAndFro ? "\(lccInfo.startTourDate ?? "") ~ \(lccInfo.endTourDate ?? "")":"\(lccInfo.startTourDate ?? "")"
        sameAirlineSwitch.isOn = lccInfo.isSameAirline
    }
    
    @IBAction func onTouchDate(_ sender: Any) {
        self.delegate?.onTouchDate()
    }
    @IBAction func onTouchRadioButton(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.delegate?.onTouchRadio(isToAndFor: true)
        case 1:
            self.delegate?.onTouchRadio(isToAndFor: false)
        default:
            ()
        }
    }
    
    @IBAction func onTouchAirlineSwithc(_ sender: Any) {
        self.delegate?.onTouchAirlineSwitch()
    }
    
}
