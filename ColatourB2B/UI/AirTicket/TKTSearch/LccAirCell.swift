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
    
    var viewModel: LccAirCellViewModel?
    
    func setCell(viewModel: LccAirCellViewModel) {
        self.viewModel = viewModel
        
        toAndForRadio.image = (viewModel.isToAndFro ?? false) ? #imageLiteral(resourceName: "radio_on"):#imageLiteral(resourceName: "radio_off")
        oneWayRadio.image = (viewModel.isToAndFro ?? false) ? #imageLiteral(resourceName: "radio_off"):#imageLiteral(resourceName: "radio_on")
        departure.text = viewModel.departure
        departure.textColor = UIColor.init(named: viewModel.departureColor ?? "")
        destination.text = viewModel.destination
        destination.textColor = UIColor.init(named: viewModel.destinationColor ?? "")
        tourDate.text = viewModel.tourDate
        sameAirlineSwitch.isOn = viewModel.sameAirlineSwitch ?? false
        paxInfo.text = viewModel.paxInfo
    }
    
    @IBAction func onTouchDate(_ sender: Any) {
        
        viewModel?.onTouchLccDate?()
    }
    
    @IBAction func onTouchRadioButton(_ sender: UIButton) {
        
        viewModel?.onTouchRadioButton(tag: sender.tag)
    }
    
    @IBAction func onTouchAirlineSwithc(_ sender: Any) {
        viewModel?.onTouchAirlineSwitch?()
    }
    
    @IBAction func onTouchPax(_ sender: Any) {
        viewModel?.onTouchPax?()
    }
    
    @IBAction func onTouchLccRequestByPerson(_ sender: Any) {
        viewModel?.onTouchLccRequestByPerson?()
    }
    
    @IBAction func onTouchSearch() {
        viewModel?.onTouchLccSearch?()
    }
    
    @IBAction func onTouchDeparture(_ sender: Any) {
        viewModel?.onTouchLccDeparture?()
    }
    
    @IBAction func onTouchDestination(_ sender: Any) {
        viewModel?.onTouchLccDestination?()
    }
}
