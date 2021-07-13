//
//  ChooseLocationViewModel.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/7/9.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation
import RxSwift

class  ChooseLocationViewModel: BaseViewModel {
    
    enum Section: Int, CaseIterable {
        case Capsule = 0
        case Brick
        case SearchEmpty
        case SearchResult
    }
    
    var reloadData: (() -> ())?
    var toLocationDetailViewController: ((_ countryInfo:  TKTInitResponse.TicketResponse.Country?) -> ())?
    var setLocation: ((_ cityInfo: TKTInitResponse.TicketResponse.City?, _ searchType: SearchByType?, _ arrival: ArrivalType?, _ startEndType: StartEndType?) -> ())?
    
    var searchText = ""
    var preSearchText = ""
    var searchResultList: [TKTInitResponse.TicketResponse.City] = []
    
    var searchType: SearchByType?
    var startEndType: StartEndType?
    var airTicketInfo: TKTInitResponse.TicketResponse?
    var lccAirInfo: LccResponse.LCCSearchInitialData?
    var area: TKTInitResponse.TicketResponse.Area?
    var countryList: [TKTInitResponse.TicketResponse.Country]?
    var cityList: [TKTInitResponse.TicketResponse.City]?
    var arrival: ArrivalType?
    
    var capsuleCellViewModel: CapsuleCellViewModel?
    var brickCellViewModel: BrickCellViewModel?
    var searchResultCellViewModel: SearchResultCellViewModel?
    
    fileprivate let repository = TKTRepository.shared
    fileprivate var dispose = DisposeBag()
    
    required init (tktSearchInit: TKTInitResponse.TicketResponse?, lccSearchInit: LccResponse.LCCSearchInitialData?, searchType: SearchByType, startEndType: StartEndType, arrival: ArrivalType? = nil) {
        
        self.searchType = searchType
        self.startEndType = startEndType
        self.arrival = arrival
        
        switch searchType {
        case .airTkt:
            airTicketInfo = tktSearchInit
            
        case .soto:
            ()
            
        case .lcc:
            lccAirInfo = lccSearchInit
        }
    }
    
    func getAirTktSearchResult() {
        
        onStartLoadingHandle?(.coverPlate)
        
        repository.getAirTktLocationKeywordSearchResult(keyword: searchText).subscribe(
            onSuccess: { [weak self] (model) in
                self?.onBindSearchResult(result: model.keywordResultData?.cityList ?? [])
                self?.onCompletedLoadingHandle?()
            }, onError: { [weak self] (error) in
                self?.onApiErrorHandle?((error as! APIError), .custom)
                self?.onCompletedLoadingHandle?()
            }).disposed(by: dispose)
    }
    
    func getLccSearchResult() {
        
        onStartLoadingHandle?(.coverPlate)
        
        repository.getLccLocationKeywordSearchResult(keyword: searchText).subscribe(
            onSuccess: { [weak self] (model) in
                self?.onBindSearchResult(result: model.keywordResultData?.cityList ?? [])
                self?.onCompletedLoadingHandle?()
            }, onError: { [weak self] (error) in
                self?.onApiErrorHandle?((error as! APIError), .custom)
                self?.onCompletedLoadingHandle?()
            }).disposed(by: dispose)
    }
    
    func setCellViewModel(section: Int, row: Int) -> String {
        
        switch Section(rawValue: section) {
        
        case .Capsule:
            
            switch searchType {
            
            case .airTkt:
                capsuleCellViewModel = CapsuleCellViewModel(airTicketInfo: airTicketInfo, lccAirInfo: nil, searchType:  .airTkt, row: row)
                capsuleCellViewModel?.onTouchCapsule = { [weak self] areaInfo, countryInfo, searchType in
                    
                    self?.cellOnTouchCapsule(areaInfo: areaInfo, countryInfo: countryInfo, searchType: searchType)
                }
                
            case .lcc:
                capsuleCellViewModel = CapsuleCellViewModel(airTicketInfo: nil, lccAirInfo: lccAirInfo, searchType: .lcc, row: row)
                capsuleCellViewModel?.onTouchCapsule = { [weak self] areaInfo, countryInfo, searchType in
                    
                    self?.cellOnTouchCapsule(areaInfo: areaInfo, countryInfo: countryInfo, searchType: searchType)
                }
                
            default:
                ()
            }
            return "capsuleCell"
            
        case .Brick:
            
            switch searchType {
            case .airTkt:
                brickCellViewModel = BrickCellViewModel(countryInfo: countryList?[row], cityInfo: nil, searchType: .airTkt)
                brickCellViewModel?.onTouchBrick = { [weak self] countryInfo, cityInfo, searchType in
                    
                    self?.cellOnTouchBrick(countryInfo: countryInfo, cityInfo: cityInfo, searchType: searchType)
                }
                
            case .lcc:
                brickCellViewModel = BrickCellViewModel(countryInfo: nil, cityInfo: cityList?[row], searchType: .lcc)
                brickCellViewModel?.onTouchBrick = { [weak self] countryInfo, cityInfo, searchType in
                    
                    self?.cellOnTouchBrick(countryInfo: countryInfo, cityInfo: cityInfo, searchType: searchType)
                }
            default:
                ()
            }
            return "brickCell"
            
        case .SearchEmpty:
            
            return "searchEmpty"
            
        case .SearchResult:
            
            switch searchType {
            case .airTkt:
                searchResultCellViewModel = SearchResultCellViewModel(cityInfo: searchResultList[row], searchText: searchText, searchType: .airTkt)
                searchResultCellViewModel?.onTouchCity = { [weak self] cityInfo, searchType in
                    self?.setLocation?(cityInfo, searchType, self?.arrival, self?.startEndType)
                }
                
            case .lcc:
                searchResultCellViewModel = SearchResultCellViewModel(cityInfo: searchResultList[row], searchText: searchText, searchType: .lcc)
                searchResultCellViewModel?.onTouchCity = { [weak self] cityInfo, searchType in
                    self?.setLocation?(cityInfo, searchType, self?.arrival, self?.startEndType)
                }
                
            default:
                ()
            }
            
            return "searchResult"
            
        default:
            return ""
        }
    }
}

extension ChooseLocationViewModel {
    
    private func onBindSearchResult(result: [TKTInitResponse.TicketResponse.City]) {
        
        if self.searchText == "" { return }
        
        searchResultList = result
        reloadData?()
    }
    
    private func cellOnTouchCapsule(areaInfo: TKTInitResponse.TicketResponse.Area?, countryInfo: TKTInitResponse.TicketResponse.Country?, searchType: SearchByType?) {
        switch searchType {
        case .airTkt:
            self.airTicketInfo?.areaList.forEach({ (area) in
                
                if area == areaInfo {
                    
                    area.isSelected = true
                } else {
                    
                    area.isSelected = false
                }
            })
            
        case .lcc:
            self.lccAirInfo?.countryList.forEach({ (country) in
                
                if country == countryInfo {
                    
                    country.isSelected = true
                } else {
                    
                    country.isSelected = false
                }
            })
            
        default:
            ()
        }
        self.reloadData?()
    }
    
    private func cellOnTouchBrick(countryInfo: TKTInitResponse.TicketResponse.Country?, cityInfo: TKTInitResponse.TicketResponse.City?, searchType: SearchByType?) {
        switch searchType {
        case .airTkt:
            
            self.toLocationDetailViewController?(countryInfo!)
            
        case .lcc:
            self.lccAirInfo?.countryList.forEach({ (country) in
                country.cityList.forEach({ (city) in
                    
                    if city == cityInfo {
                        
                        self.setLocation?(cityInfo!, .lcc, nil, self.startEndType)
                    }
                })
            })
            
        default:
            ()
        }
    }
}
