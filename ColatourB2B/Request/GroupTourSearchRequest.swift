//
//  GroupTourSearchRequest.swift
//  ColatourB2B
//
//  Created by M6853 on 2020/1/21.
//  Copyright © 2020 Colatour. All rights reserved.
//

class GroupTourSearchRequest: NSObject {
    var startTourDate: String?
    var tourDays: String?
    var selectedRegionCode: GroupTourSearchInitResponse.Region?
    var selectedDepartureCity: GroupTourSearchInitResponse.DepartureCity?
    var selectedAirlineCode: GroupTourSearchInitResponse.AirlineCode?
    var selectedTourType: GroupTourSearchInitResponse.TourType?
    var minPrice: Int?
    var maxPrice: Int?
    var isBookingTour: Bool = true
    var isPriceLimit: Bool = true {
        didSet{
            self.isPriceLimitValueChange?()
        }
    }
    
    var isPriceLimitValueChange: (()->())?
    
    func getDictionary() -> [String:Any] {
        let params = ["Tour_Date": "\(startTourDate ?? "")"
            , "Departure_City": selectedDepartureCity?.departureCode ?? ""
            , "Airline_Code": selectedAirlineCode?.airlineCode ?? ""
            , "Region_Code": selectedRegionCode?.regionCode ?? ""
            , "TourType_Code": selectedTourType?.tourTypeCode ?? ""
            , "PriceRange_Mark": !isPriceLimit
            , "BookingTour_Mark": isBookingTour
            , "Tour_Days": tourDays ?? ""
            , "Max_Price": maxPrice ?? 200000
            , "Min_Price": minPrice ?? 0] as [String : Any]
        
        return params
    }
}
