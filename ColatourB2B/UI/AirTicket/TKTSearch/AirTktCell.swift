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
    
    weak var delegate: AirTktCellProtocol?
    
    func setCell(info: TKTSearchRequest, searchType: SearchByType){
        identity.text = info.identityType
        sitClass.text = info.service?.serviceName
        airline.text = info.airline?.airlineName
        startDate.text = info.startTravelDate
        dateRange.text = info.endTravelDate?.endTravelDateName
        tourWay.text = info.journeyType
        departure.text = info.departure?.departureCodeName
        destination.text = info.destination == nil ? "輸入 目的城市/機場代碼" : info.destination?.cityName
        destination.textColor = info.destination == nil ? UIColor.init(named: "預設文字") : UIColor.init(named: "標題黑" )
        backDeparture.text = info.returnCode == nil ? "輸入 目的城市/機場代碼":info.returnCode?.cityName
        backDeparture.textColor = info.returnCode == nil ? UIColor.init(named: "預設文字") : UIColor.init(named: "標題黑" )
        isNonStop.image = info.isNonStop ? #imageLiteral(resourceName: "check") : #imageLiteral(resourceName: "check_hover")
        backView.isHidden = !(info.journeyType == "雙程" || info.journeyType == "環遊")
        self.backView.layoutIfNeeded()
        
    }
    
    @IBAction func onTouchTopSelection(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.delegate?.onTouchSelection(selection: .id, searchType: .airTkt)
        case 1:
            self.delegate?.onTouchSelection(selection: .sitClass, searchType: .airTkt)
        case 2:
            self.delegate?.onTouchSelection(selection: .airlineCode, searchType: .airTkt)
        case 3:
            self.delegate?.onTouchDate(searchType: .airTkt)
        case 4:
            self.delegate?.onTouchSelection(selection: .dateRange, searchType: .airTkt)
        case 5:
            self.delegate?.onTouchSelection(selection: .tourType, searchType: .airTkt)
        case 6:
            self.delegate?.onTouchSelection(selection: .departureCity, searchType: .airTkt)
        case 7:
            self.delegate?.onTouchNonStop(searchType: .airTkt )
        default:
            ()
        }
    }
    
    @IBAction func onTouchArrvial(_ sender: UIButton) {
        self.delegate?.onTouchArrival(arrival: .departureCity, searchType: .airTkt)
    }
    
    @IBAction func onTouchBack(_ sender: Any) {
        self.delegate?.onTouchArrival(arrival: .backStartingCity, searchType: .airTkt)
    }
    
    @IBAction func onTouchSearch(_ sender: UIButton) {
        self.delegate?.onTouchSearch(searchType: .airTkt)
    }
}
