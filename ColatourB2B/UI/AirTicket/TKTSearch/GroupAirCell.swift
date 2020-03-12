//
//  GroupAirCell.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2020/3/9.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
protocol GroupAirCellProtocol: NSObjectProtocol {
    func onTouchSelection(selection:TKTInputFieldType, searchType: SearchByType)
    func onTouchSearch(searchType:SearchByType)
    func onTouchArrival(arrival:ArrivalType, searchType: SearchByType)
    func onTouchNonStop(searchType: SearchByType)
}
class GroupAirCell: UITableViewCell {

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
    
    weak var delegate: GroupAirCellProtocol?
    
    func setCell(info:TKTSearchRequest, searchType:SearchByType){
        identity.text = info.selectedID?.text
        sitClass.text = info.selectedSitClass?.text
        airline.text = info.selectedAirlineCode?.text
        startDate.text = info.startTourDate
        dateRange.text = info.selectedDateRange?.text
        tourWay.text = info.selectedTourWay?.text
        departure.text = info.selectedDeparture?.text
        isNonStop.image = info.isNonStop ? #imageLiteral(resourceName: "check") : #imageLiteral(resourceName: "check_hover")
        backView.isHidden = !(info.selectedTourWay?.text == "雙程" || info.selectedTourWay?.text == "旅遊")
        
    }
    
    @IBAction func onTouchTopSelection(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.delegate?.onTouchSelection(selection: .id, searchType: .groupAir)
        case 1:
            self.delegate?.onTouchSelection(selection: .sitClass, searchType: .groupAir)
        case 2:
            self.delegate?.onTouchSelection(selection: .airlineCode, searchType: .groupAir)
        case 3:
            self.delegate?.onTouchSelection(selection: .startTourDate, searchType: .groupAir)
        case 4:
            self.delegate?.onTouchSelection(selection: .dateRange, searchType: .groupAir)
        case 5:
            self.delegate?.onTouchSelection(selection: .tourType, searchType: .groupAir)
        case 6:
            self.delegate?.onTouchSelection(selection: .departureCity, searchType: .groupAir)
        case 7:
            self.delegate?.onTouchNonStop(searchType: .groupAir )
        default:
            ()
        }
    }
    @IBAction func onTouchArrvial(_ sender: UIButton) {
        self.delegate?.onTouchArrival(arrival: .departureCity, searchType: .groupAir)
    }
    @IBAction func onTouchBack(_ sender: Any) {
        self.delegate?.onTouchArrival(arrival: .backStartingCity, searchType: .groupAir)
    }
    
    @IBAction func onTouchSearch(_ sender: UIButton) {
        self.delegate?.onTouchSearch(searchType: .groupAir)
    }
    
}
