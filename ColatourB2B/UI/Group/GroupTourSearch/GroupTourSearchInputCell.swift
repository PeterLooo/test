//
//  GroupTourSearchInputCell.swift
//  ColatourB2B
//
//  Created by M6853 on 2020/1/17.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

protocol GroupTourSearchInputCellProtocol: NSObjectProtocol {
    func onTouchTourDaysView(_ sender: UIButton)
    func onTourDaysTextFieldDidChange(text: String)
}

class GroupTourSearchInputCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var bookingTourCheckBoxImageView: UIImageView!
    
    @IBOutlet weak var startTourDate: UILabel!
    @IBOutlet weak var tourDays: UILabel!
    @IBOutlet weak var regionCode: UILabel!
    @IBOutlet weak var departureCity: UILabel!
    @IBOutlet weak var airLineCode: UILabel!
    @IBOutlet weak var tourType: UILabel!
    @IBOutlet weak var tourDaysTextField: UITextField!
    
    weak var delegate: GroupTourSearchInputCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        tourDaysTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingDidEnd)
    }
    
    func setCellWith(groupTourSearchRequest: GroupTourSearchRequest)
    {
        
        bookingTourCheckBoxImageView.image = groupTourSearchRequest.isBookingTour ? #imageLiteral(resourceName: "check") : #imageLiteral(resourceName: "check_hover")
        
        self.regionCode.text = groupTourSearchRequest
            .selectedRegionCode?
            .regionName
        self.departureCity.text = groupTourSearchRequest
            .selectedDepartureCity?
            .departureName
        self.airLineCode.text = groupTourSearchRequest
            .selectedAirlineCode?
            .airlineName
        self.tourType.text = groupTourSearchRequest
            .selectedTourType?
            .tourTypeName
        
        if groupTourSearchRequest.startTourDate == nil {
            self.startTourDate.text = "出發日期"
            self.startTourDate.textColor = UIColor.init(named: "預設文字")!
        } else {
            self.startTourDate.text = groupTourSearchRequest.startTourDate
            self.startTourDate.textColor = UIColor.init(named: "標題黑")!
        }
        
        if let tourDays = groupTourSearchRequest.tourDays {
            tourDaysTextField.text = "\(tourDays)"
        } else {
            tourDaysTextField.text = ""
        }

    }
    
    @IBAction func onTouchTourDays(_ sender: UIButton) {
        delegate?.onTouchTourDaysView(sender)
        tourDaysTextField.becomeFirstResponder()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        delegate?.onTourDaysTextFieldDidChange(text: textField.text ?? "")
    }
}
