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
    func onTouchLccRequestByPerson()
    func onTouchPax()
    func onTouchLccSearch()
    func onTouchLccDeparture()
    func onTouchLccDestination()
}

class LccAirCell: UITableViewCell {

    @IBOutlet weak var toAndForRadio: UIImageView!
    @IBOutlet weak var oneWayRadio: UIImageView!
    @IBOutlet weak var tourDate: UILabel!
    @IBOutlet weak var sameAirlineSwitch: UISwitch!
    @IBOutlet weak var paxInfo: UILabel!
    
    weak var delegate: LccCellProtocol?

    func setCell(lccInfo:LCCTicketRequest){
        toAndForRadio.image = lccInfo.isToAndFro ? #imageLiteral(resourceName: "radio_on"):#imageLiteral(resourceName: "radio_off")
        oneWayRadio.image = lccInfo.isToAndFro ? #imageLiteral(resourceName: "radio_off"):#imageLiteral(resourceName: "radio_on")
        tourDate.text = lccInfo.isToAndFro ? "\(lccInfo.startTourDate ?? "") ~ \(lccInfo.endTourDate ?? "")":"\(lccInfo.startTourDate ?? "")"
        sameAirlineSwitch.isOn = lccInfo.isSameAirline
        
        paxInfo.text = "\(lccInfo.adultCount) 大人 \(lccInfo.childCount) 小孩 \(lccInfo.infanCount) 嬰兒"
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
    
    @IBAction func onTouchPax(_ sender: Any) {
        self.delegate?.onTouchPax()
    }
    
    @IBAction func onTouchLccRequestByPerson(_ sender: Any) {
        self.delegate?.onTouchLccRequestByPerson()
    }
    
    @IBAction func onTouchSearch(){
        self.delegate?.onTouchLccSearch()
    }
    
    @IBAction func onTouchDeparture(_ sender: Any) {
        self.delegate?.onTouchLccDeparture()
    }
    
    @IBAction func onTouchDestination(_ sender: Any) {
        self.delegate?.onTouchLccDestination()
    }
}
