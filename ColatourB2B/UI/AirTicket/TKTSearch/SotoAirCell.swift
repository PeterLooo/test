//
//  SotoAirCell.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2020/3/10.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

class SotoAirCell: UITableViewCell {
    
    @IBOutlet weak var identity: UILabel!
    @IBOutlet weak var sitClass: UILabel!
    @IBOutlet weak var airline: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var dateRange: UILabel!
    @IBOutlet weak var tourWay: UILabel!
    @IBOutlet weak var departure: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var isNonStop: UIImageView!
    
    var viewModel: SotoAirCellViewModel?
    
    func setCell(viewModel: SotoAirCellViewModel) {
        self.viewModel = viewModel
        
        identity.text = viewModel.identity
        sitClass.text = viewModel.sitClass
        airline.text = viewModel.airline
        startDate.text = viewModel.startDate
        dateRange.text = viewModel.dateRange
        tourWay.text = viewModel.tourWay
        departure.text = viewModel.departure
        destination.text = viewModel.destination
        isNonStop.image = (viewModel.isNonStop ?? false) ? #imageLiteral(resourceName: "check") : #imageLiteral(resourceName: "check_hover")
    }
    
    @IBAction func onTouchTopSelection(_ sender: UIButton) {
        
        viewModel?.onTouchTopSelection(tag: sender.tag)
    }
    
    @IBAction func onTouchArrvial(_ sender: UIButton) {
        
        viewModel?.onTouchArrvial()
    }
    
    @IBAction func onTouchSearch(_ sender: UIButton) {
        
        viewModel?.onTouchToSearch()
    }
}
