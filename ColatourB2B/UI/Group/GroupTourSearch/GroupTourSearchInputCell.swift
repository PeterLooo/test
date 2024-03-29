//
//  GroupTourSearchInputCell.swift
//  ColatourB2B
//
//  Created by M6853 on 2020/1/17.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

class GroupTourSearchInputCell: UITableViewCell {

    @IBOutlet weak var priceLimitCheckBoxImageView: UIImageView!
    @IBOutlet weak var bookingTourCheckBoxImageView: UIImageView!
    
    @IBOutlet weak var startTourDate: UILabel!
    @IBOutlet weak var tourDays: UILabel!
    @IBOutlet weak var regionCode: UILabel!
    @IBOutlet weak var departureCity: UILabel!
    @IBOutlet weak var airLineCode: UILabel!
    @IBOutlet weak var tourType: UILabel!
    @IBOutlet weak var newDatePicker: UIDatePicker!
    @IBOutlet weak var tourDaysTextField: UITextField!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var dateButton: UIButton!
    
    var priceRangeSlider: PriceRangeSlider?
    private var viewModel: GroupTourSearchRequest?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        tourDaysTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingDidEnd)
        tourDaysTextField.delegate = self
        creatPriceView()
        if #available(iOS 14.0, *) {

            dateButton.isHidden = true
            newDatePicker.isHidden = false
            startTourDate.isHidden = true
            newDatePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        }else{
            startTourDate.isHidden = false
            dateButton.isHidden = false
            newDatePicker.isHidden = true
        }
    }
    
    func setCellWith(groupTourSearchRequest: GroupTourSearchRequest){
        viewModel = groupTourSearchRequest
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
        
        if let date = groupTourSearchRequest.startTourDate {
            newDatePicker.date = FormatUtil.convertStringToDate(dateFormatFrom: "yyyy/MM/dd", dateString: date) ?? Date()
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
        priceRangeSlider?.valueChangeClosure = { [weak self] _,_ in
            self?.viewModel?.isPriceLimit = false
        }
    }
    
    @IBAction func onTouchTourDays(_ sender: UIButton) {

        tourDaysTextField.becomeFirstResponder()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        viewModel?.tourDays = textField.text
    }
    
    @objc private func datePickerChanged(picker: UIDatePicker) {
        let selectDate = FormatUtil.convertDateToString(dateFormatTo: "yyyy/MM/dd", date: picker.date)
        
        viewModel?.startTourDate = selectDate
    }
}

extension GroupTourSearchInputCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tourDaysTextField  { // 修正旅遊天數長度最多3，range.length == 1 代表刪除時。
            return textField.text!.count < 3 || range.length == 1
        }else{
            return true
        }
    }
}
