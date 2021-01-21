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
    func sliderDown()
}

class GroupTourSearchInputCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var priceLimitCheckBoxImageView: UIImageView!
    @IBOutlet weak var bookingTourCheckBoxImageView: UIImageView!
    
    @IBOutlet weak var startTourDate: UILabel!
    @IBOutlet weak var tourDays: UILabel!
    @IBOutlet weak var regionCode: UILabel!
    @IBOutlet weak var departureCity: UILabel!
    @IBOutlet weak var airLineCode: UILabel!
    @IBOutlet weak var tourType: UILabel!
    @IBOutlet weak var tourDaysTextField: UITextField!
    @IBOutlet weak var priceView: UIView!
    var priceRangeSlider: PriceRangeSlider?
    weak var delegate: GroupTourSearchInputCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        tourDaysTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingDidEnd)
        creatPriceView()
    }
    
    func setCellWith(groupTourSearchRequest: GroupTourSearchRequest)
    {
        priceLimitCheckBoxImageView.image = groupTourSearchRequest.isPriceLimit ? #imageLiteral(resourceName: "check") : #imageLiteral(resourceName: "check_hover")
        bookingTourCheckBoxImageView.image = groupTourSearchRequest.isBookingTour ? #imageLiteral(resourceName: "check") : #imageLiteral(resourceName: "check_hover")
        
        self.regionCode.text = groupTourSearchRequest
            .selectedRegionCode?
            .regionName?.trimmingCharacters(in: .whitespaces)
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
    
    private func creatPriceView(){
        let sliderWidth: CGFloat = screenWidth - 112
        let rangeSlider = PriceRangeSlider(frame: CGRect(x: 0, y: 0, width: sliderWidth, height: 44))
        rangeSlider.setRange(minRange: 0, maxRange: 200000, accuracy: 1000)
        self.priceView.addSubview(rangeSlider)
        rangeSlider.setCurrentValue(left: 0, right: 200000)
        priceRangeSlider = rangeSlider
        priceRangeSlider?.delegate = self
    }
    
    @IBAction func onTouchTourDays(_ sender: UIButton) {
        delegate?.onTouchTourDaysView(sender)
        tourDaysTextField.becomeFirstResponder()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        delegate?.onTourDaysTextFieldDidChange(text: textField.text ?? "")
    }
}
extension GroupTourSearchInputCell : PriceRangeSliderPortocol {
    func sliderDown() {
        self.delegate?.sliderDown()
    }
}
