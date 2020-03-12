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
    
    weak var delegate: GroupAirCellProtocol?
    
    func setCell(info:TKTSearchRequest, searchType:SearchByType){
        identity.text = info.selectedID?.text
        sitClass.text = info.selectedSitClass?.text
        airline.text = info.selectedAirlineCode?.text
        startDate.text = info.startTourDate
        dateRange.text = info.selectedDateRange?.text
        tourWay.text = info.selectedTourWay?.text
        departure.text = info.selectedDeparture?.text
        destination.text = info.selectedDestinatione?.text
        isNonStop.image = info.isNonStop ? #imageLiteral(resourceName: "check") : #imageLiteral(resourceName: "check_hover")
        
    }
    
    @IBAction func onTouchTopSelection(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.delegate?.onTouchSelection(selection: .id, searchType: .soto)
        case 1:
            self.delegate?.onTouchSelection(selection: .sitClass, searchType: .soto)
        case 2:
            self.delegate?.onTouchSelection(selection: .airlineCode, searchType: .soto)
        case 3:
            self.delegate?.onTouchSelection(selection: .startTourDate, searchType: .soto)
        case 4:
            self.delegate?.onTouchSelection(selection: .dateRange, searchType: .soto)
        case 5:
            self.delegate?.onTouchSelection(selection: .tourType, searchType: .soto)
        case 6:
            self.delegate?.onTouchSelection(selection: .departureCity, searchType: .soto)
        case 7:
            self.delegate?.onTouchNonStop(searchType: .soto)
        default:
            ()
        }
    }
    @IBAction func onTouchArrvial(_ sender: UIButton) {
        self.delegate?.onTouchSelection(selection: .sotoArrival, searchType: .soto)
    }
    
    @IBAction func onTouchSearch(_ sender: UIButton) {
        self.delegate?.onTouchSearch(searchType: .soto)
        
    }
}
