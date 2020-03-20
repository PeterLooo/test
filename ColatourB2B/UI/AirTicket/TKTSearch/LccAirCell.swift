//
//  LccAirCell.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2020/3/10.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

protocol LccCellProtocol: NSObjectProtocol {
    func onTouchRadio(isToAndFor:Bool)
    func onTouchLccDate()
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
    @IBOutlet weak var departure: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var tourDate: UILabel!
    @IBOutlet weak var sameAirlineSwitch: UISwitch!
    @IBOutlet weak var paxInfo: UILabel!
    
    weak var delegate: LccCellProtocol?

    func setCell(lccInfo: LccTicketRequest) {
        toAndForRadio.image = lccInfo.isToAndFro ? #imageLiteral(resourceName: "radio_on"):#imageLiteral(resourceName: "radio_off")
        oneWayRadio.image = lccInfo.isToAndFro ? #imageLiteral(resourceName: "radio_off"):#imageLiteral(resourceName: "radio_on")
        departure.text = lccInfo.departure == nil ? "輸入 國家/城市/機場代碼" : lccInfo.departure?.cityName
        departure.textColor = lccInfo.departure == nil ? UIColor.init(named: "預設文字") : UIColor.init(named: "標題黑" )
        destination.text = lccInfo.destination == nil ? "輸入 國家/城市/機場代碼" : lccInfo.destination?.cityName
        destination.textColor = lccInfo.destination == nil ? UIColor.init(named: "預設文字") : UIColor.init(named: "標題黑" )
        tourDate.text = lccInfo.isToAndFro ? "\(lccInfo.startTravelDate ?? "") ~ \(lccInfo.endTravelDate ?? "")" : "\(lccInfo.startTravelDate ?? "")"
        sameAirlineSwitch.isOn = lccInfo.isSameAirline
        paxInfo.text = "\(lccInfo.adultCount) 大人 \(lccInfo.childCount) 小孩 \(lccInfo.infanCount) 嬰兒"
    }
    
    @IBAction func onTouchDate(_ sender: Any) {
        self.delegate?.onTouchLccDate()
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
