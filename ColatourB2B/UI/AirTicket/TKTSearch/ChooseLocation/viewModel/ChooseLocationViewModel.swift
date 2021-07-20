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
    var uppercased: ((_ maxLengthThreeText: String) -> ())?
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
    
    func getNumberOfItemsInSection(section: Int) -> Int {
        
        switch Section(rawValue: section) {
        case .Capsule:
            
            switch searchType {
            case .airTkt:
                if (searchText.count) >= 1 { return 0 }
                return airTicketInfo?.areaList.count ?? 0
                
            case .lcc:
                if (searchText.count) >= 2 { return 0 }
                return lccAirInfo?.countryList.count ?? 0
                
            default:
                return 0
            }
            
        case .Brick:
            switch searchType {
            case .airTkt:
                if (searchText.count) >= 1 { return 0 }
                area = airTicketInfo?.areaList.filter{ $0.isSelected == true }.first
                countryList = airTicketInfo?.countryList.filter{ $0.areaId == area?.areaId }
                return countryList?.count ?? 0
                
            case .lcc:
                if (searchText.count) >= 2 { return 0 }
                let country = lccAirInfo?.countryList.filter { $0.isSelected == true }.first
                cityList = country?.cityList
                return cityList?.count ?? 0
                
            default:
                return 0
            }
            
        case .SearchEmpty:
            switch searchType {
            case .airTkt:
                if (searchText.count) >= 1 && searchResultList.count == 0 { return 1 }
                
            case .lcc:
                if (searchText.count) >= 2 && searchResultList.count == 0 { return 1 }
                
            default:
                return 0
            }
            return 0
            
        case .SearchResult:
            return searchResultList.count
            
        default:
            return 0
        }
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
            
            return "searchResultCell"
            
        default:
            return ""
        }
    }
    
    func getCollectionViewFlowLayout(section: Int) -> UIEdgeInsets {
        
        switch Section(rawValue: section) {
        case .Capsule:
            switch searchType {
            case .airTkt:
                if searchText.count >= 1 { return .zero }
                
            case .lcc:
                if searchText.count >= 2 { return .zero }
                
            default:
                return .zero
            }
            return UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
            
        case .Brick:
            switch searchType {
            case .airTkt:
                if searchText.count >= 1 { return .zero }
                
            case .lcc:
                if searchText.count >= 2 { return .zero }
                
            default:
                return .zero
            }
            return UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
            
        case .SearchEmpty:
            return .zero
            
        case .SearchResult:
            if searchText.count != 0 && searchResultList.count == 0 { return .zero }
            return UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
            
        default:
            return .zero
        }
    }
    
    func getGCSize(section: Int, item: Int, width: CGFloat, height: CGFloat) -> CGSize {
        
        var cellSize = CGSize()
        let textFont = UIFont.init(name: "PingFang-TC-Regular", size: 14)!
        var textString: String?
        var textMaxSize = CGSize()
        var textLabelSize = CGSize()
        
        switch Section(rawValue: section) {
        case .Capsule:
            switch searchType {
            case .airTkt:
                textString = airTicketInfo?.areaList[item].areaName
                
            case .lcc:
                textString = lccAirInfo?.countryList[item].countryName
                
            default:
                ()
            }
            
            textMaxSize = CGSize(width: 100, height: 28)
            textLabelSize = self.textSize(text: textString ?? "", font: textFont, maxSize: textMaxSize)
            
            cellSize.width = textLabelSize.width + 24
            cellSize.height = 28
            
            return cellSize
            
        case .Brick:
            cellSize.width = (width - 65) / 2
            cellSize.height = 36
            
            return cellSize
            
        case .SearchEmpty:
            cellSize.width = width
            cellSize.height = height
            
            return cellSize
            
        case .SearchResult:
            textString = searchResultList[item].cityName
            textMaxSize = CGSize(width: width - 48, height: 40)
            textLabelSize = self.textSize(text: textString ?? "", font: textFont, maxSize: textMaxSize)
            
            cellSize.width = width - 48
            cellSize.height = textLabelSize.height
            
            return cellSize
            
        default:
            return cellSize
        }
    }
    
    func getSearch(searchText: String) {
        
        let range = NSRange(location: 0, length: searchText.utf16.count)
        let regex = try! NSRegularExpression(pattern: "[^A-Za-z\\u4E00-\\u9FA5]")
        let regexMatch: Bool = regex.firstMatch(in: searchText, options: [], range: range) != nil
        
        self.searchText = searchText.uppercased()
        
        switch searchType {
        case .airTkt:
            if searchText.count > 3 {
                let maxLengthThreeText = String(searchText.dropLast(searchText.count - 3))
                uppercased?(maxLengthThreeText)
                self.searchText = maxLengthThreeText.uppercased()
            }
            if searchText.count >= 1 && self.preSearchText != self.searchText && !regexMatch {
                getAirTktSearchResult()
                self.preSearchText = self.searchText
                // 搜尋文字清空時也要清空preSearchText，否則下次輸入相同文字時會無法進入搜尋
            } else if searchText != "" {
                return
            } else {
                self.preSearchText = ""
            }
        case .lcc:
            if searchText.count >= 2 && self.preSearchText != self.searchText && !regexMatch {
                getLccSearchResult()
                self.preSearchText = self.searchText
            } else if searchText != "" {
                return
            } else {
                self.preSearchText = ""
            }
        default:
            ()
        }
        
        self.searchResultList = []
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
    
    private func textSize(text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        
        return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : font], context: nil).size
    }
}
