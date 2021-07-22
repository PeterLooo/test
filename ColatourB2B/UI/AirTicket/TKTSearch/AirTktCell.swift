//
//  AirTktCell.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2020/3/9.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

protocol AirTktCellProtocol: NSObjectProtocol {
    func onTouchSelection(selection: TKTInputFieldType, searchType: SearchByType)
    func onTouchSearch(searchType: SearchByType)
    func onTouchArrival(arrival:ArrivalType, searchType: SearchByType)
    func onTouchNonStop(searchType: SearchByType)
    func onTouchDate(searchType: SearchByType)
}

class AirTktCell: UITableViewCell {

    @IBOutlet weak var identity: UILabel!
    @IBOutlet weak var sitClass: UILabel!
    @IBOutlet weak var airline: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var dateRange: UILabel!
    @IBOutlet weak var tourWay: UILabel!
    @IBOutlet weak var departure: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var backDeparture: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var isNonStop: UIImageView!
    
    var viewModel: AirTktCellViewModel?
    
    func setCell(viewModel: AirTktCellViewModel) {
        self.viewModel = viewModel
        identity.text = viewModel.identity
        sitClass.text = viewModel.sitClass
        airline.text = viewModel.airline
        startDate.text = viewModel.startDate
        dateRange.text = viewModel.dateRange
        tourWay.text = viewModel.tourWay
        departure.text = viewModel.departure
        destination.text = viewModel.destination
        destination.textColor = UIColor.init(named: viewModel.destinationColor ?? "")
        backDeparture.text = viewModel.backDeparture
        backDeparture.textColor = UIColor.init(named: viewModel.backDepartureColor ?? "")
        isNonStop.image = (viewModel.isNonStop ?? false)  ? #imageLiteral(resourceName: "check") : #imageLiteral(resourceName: "check_hover")
        backView.isHidden = viewModel.backViewHidden ?? false
        self.backView.layoutIfNeeded()
    }
    
    @IBAction func onTouchTopSelection(_ sender: UIButton) {
        
        viewModel?.onTouchToSelection(tag: sender.tag)
    }
    
    @IBAction func onTouchArrvial(_ sender: UIButton) {
        
        viewModel?.onTouchToArrvial()
    }
    
    @IBAction func onTouchBack(_ sender: Any) {
        viewModel?.onTouchToBack()
    }
    
    @IBAction func onTouchSearch(_ sender: UIButton) {
        viewModel?.onTouchToSearch()
    }
}
