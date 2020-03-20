//
//  ChooseLocationViewController.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/9.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

protocol SetChooseLocationProtocol: NSObjectProtocol {
    
    func setLocation(cityInfo: TKTInitResponse.TicketResponse.City, searchType: SearchByType, arrival: ArrivalType?, startEndType: StartEndType?)
}

class ChooseLocationViewController: BaseViewController {
    
    enum Section: Int, CaseIterable {
        case Capsule = 0
        case Brick
        case SearchEmpty
        case SearchResult
    }
    
    weak var delegate: SetChooseLocationProtocol?
    
    private var presenter: ChooseLocationPresenter?
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        presenter = ChooseLocationPresenter(delegate: self)
    }
    
    private var searchType: SearchByType?
    private var startEndType: StartEndType?
    private var airTicketInfo: TKTInitResponse.TicketResponse?
    private var lccAirInfo: LccResponse.LCCSearchInitialData?
    private var area: TKTInitResponse.TicketResponse.Area?
    private var countryList: [TKTInitResponse.TicketResponse.Country]?
    private var cityList: [TKTInitResponse.TicketResponse.City]?
    private var arrival: ArrivalType?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var searchText = ""
    var searchResultList: [TKTInitResponse.TicketResponse.City] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ges = UITapGestureRecognizer.init(target: self, action: #selector(dimissKeyBoard))
        view.addGestureRecognizer(ges)
        
        searchBar.becomeFirstResponder()
        
        switch searchType {
        case .airTkt:
            setSearchBarPlaceHolder(text: "輸入 目的城市/機場代碼")
        case .lcc:
            setSearchBarPlaceHolder(text: "輸入 國家/城市/機場代碼")
        default:
            ()
        }
        
        setNavBarItem(left: .custom, mid: .searchBar, right: .nothingWithEmptySpace)
        setNavCustom()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "CapsuleCell", bundle: nil), forCellWithReuseIdentifier: "CapsuleCell")
        collectionView.register(UINib(nibName: "BrickCell", bundle: nil), forCellWithReuseIdentifier: "BrickCell")
        collectionView.register(UINib(nibName: "SearchEmptyCell", bundle: nil), forCellWithReuseIdentifier: "SearchEmptyCell")
        collectionView.register(UINib(nibName: "SearchResultCell", bundle: nil), forCellWithReuseIdentifier: "SearchResultCell")
        
        setCollectionViewLayout()
    }
    
    @objc func dimissKeyBoard(){
        
        self.searchBar.endEditing(true)
    }
    
    func setNavCustom() {
        
        let close = UIBarButtonItem(image:  #imageLiteral(resourceName: "close").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(self.onTouchCancel))
        setCustomLeftBarButtonItem(barButtonItem: close)
    }
    
    @objc private func onTouchCancel(){
        
        dismiss(animated: true, completion: nil)
    }
    
    func textSize(text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        
        return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : font], context: nil).size
    }
    
    @objc func setCollectionViewLayout(){
        
        self.collectionView.setCollectionViewLayout(UICollectionViewFlowLayout(), animated: false)
    }
    
    func infoSort() {
        
        switch startEndType {
        case .Departure:
            if searchType == SearchByType.lcc {
                var tempInfo: [TKTInitResponse.TicketResponse.Country] = []
                let taiwan = (lccAirInfo?.countryList.filter { $0.countryName == "台灣" }.first)!
                
                tempInfo = (lccAirInfo?.countryList.filter { $0.countryName != "台灣" })!
                tempInfo.insert(taiwan, at: 0)
                
                lccAirInfo?.countryList = tempInfo
            }
            
        case .Destination:
            var tempInfo: [TKTInitResponse.TicketResponse.Country] = []
            let japan = (lccAirInfo?.countryList.filter { $0.countryName == "日本" }.first)!
            let taiwan = (lccAirInfo?.countryList.filter { $0.countryName == "台灣" }.first)!
            
            tempInfo = (lccAirInfo?.countryList.filter { $0.countryName != "日本" })!
            tempInfo = tempInfo.filter { $0.countryName != "台灣" }
            tempInfo.insert(japan, at: 0)
            tempInfo.append(taiwan)
            
            lccAirInfo?.countryList = tempInfo
            
        default:
            ()
        }
        
        airTicketInfo?.areaList.forEach { $0.isSelected = false }
        airTicketInfo?.areaList.first?.isSelected = true
        lccAirInfo?.countryList.forEach { $0.isSelected = false }
        lccAirInfo?.countryList.first?.isSelected = true
    }
    
    func setVC(tktSearchInit: TKTInitResponse.TicketResponse?, lccSearchInit: LccResponse.LCCSearchInitialData?, searchType: SearchByType, startEndType: StartEndType, arrival: ArrivalType? = nil) {
        
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
        
        infoSort()
    }
}

extension ChooseLocationViewController: ChooseLocationViewProtocol {
    
    func onBindSearchResult(result: [TKTInitResponse.TicketResponse.City]) {
        
        if self.searchText == "" { return }
        
        searchResultList = result
        
        collectionView.reloadData()
        setCollectionViewLayout()
    }
}

// UISearchBarDelegate
extension ChooseLocationViewController {
    
    override func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchBar.text = searchText.uppercased()
        self.searchText = searchText.uppercased()
        
        switch searchType {
        case .airTkt:
            if searchText.count >= 1 {
                presenter?.getAirTktSearchResult(keyword: self.searchText)
            }
        case .lcc:
            if searchText.count >= 2 {
                presenter?.getLccSearchResult(keyword: self.searchText)
            }
        default:
            ()
        }
        
        searchResultList = []
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchBar.endEditing(true)
    }
}

extension ChooseLocationViewController: CapsuleCellProtocol {
    
    func onTouchCapsule(areaInfo: TKTInitResponse.TicketResponse.Area?, countryInfo: TKTInitResponse.TicketResponse.Country?, searchType: SearchByType) {
        
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
        
        collectionView.reloadData()
        setCollectionViewLayout()
    }
}

extension ChooseLocationViewController: BrickCellProtocol {
    
    func onTouchBrick(countryInfo: TKTInitResponse.TicketResponse.Country?, cityInfo: TKTInitResponse.TicketResponse.City?, searchType: SearchByType) {
        
        switch searchType {
        case .airTkt:
            let vc = getVC(st: "LocationDetail", vc: "LocationDetail") as! LocationDetailViewController
            vc.onBindCountryInfo(countryInfo: countryInfo!)
            vc.delegate = self
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .lcc:
            self.lccAirInfo?.countryList.forEach({ (country) in
                country.cityList.forEach({ (city) in
                    
                    if city == cityInfo {
                        
                        self.delegate?.setLocation(cityInfo: cityInfo!, searchType: .lcc, arrival: nil, startEndType: self.startEndType)
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            })
            
        default:
            ()
        }
    }
}

extension ChooseLocationViewController: SearchResultCellProtocol {
    
    func onTouchCity(cityInfo: TKTInitResponse.TicketResponse.City, searchType: SearchByType) {
        
        delegate?.setLocation(cityInfo: cityInfo, searchType: searchType, arrival: self.arrival, startEndType: self.startEndType)
        dismiss(animated: true, completion: nil)
    }
}

extension ChooseLocationViewController: SetAirTktChooseCityProtocol {
    
    func setChooseCity(cityInfo: TKTInitResponse.TicketResponse.City) {
        
        onTouchCity(cityInfo: cityInfo, searchType: .airTkt)
    }
}

extension ChooseLocationViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch Section(rawValue: section) {
        case .Capsule:
            switch searchType {
            case .airTkt:
                if searchText.count >= 1 { return 0 }
                return airTicketInfo?.areaList.count ?? 0
                
            case .lcc:
                if searchText.count >= 2 { return 0 }
                return lccAirInfo?.countryList.count ?? 0
                
            default:
                return 0
            }
            
        case .Brick:
            switch searchType {
            case .airTkt:
                if searchText.count >= 1 { return 0 }
                area = airTicketInfo?.areaList.filter{ $0.isSelected == true }.first
                countryList = airTicketInfo?.countryList.filter{ $0.areaId == area?.areaId }
                return countryList?.count ?? 0
                
            case .lcc:
                if searchText.count >= 2 { return 0 }
                let country = lccAirInfo?.countryList.filter { $0.isSelected == true }.first
                cityList = country?.cityList
                return cityList?.count ?? 0
                
            default:
                return 0
            }
            
        case .SearchEmpty:
            switch searchType {
            case .airTkt:
                if searchText.count >= 1 && searchResultList.count == 0 { return 1 }
                
            case .lcc:
                if searchText.count >= 2 && searchResultList.count == 0 { return 1 }
                
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch Section(rawValue: indexPath.section) {
        case .Capsule:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CapsuleCell", for: indexPath) as! CapsuleCell
            cell.delegate = self
            
            switch searchType {
            case .airTkt:
                cell.setCellWith(airTicketInfo: airTicketInfo, lccAirInfo: nil, searchType: .airTkt, row: indexPath.row)
                
            case .lcc:
                cell.setCellWith(airTicketInfo: nil, lccAirInfo: lccAirInfo, searchType: .lcc, row: indexPath.row)
                
            default:
                ()
            }
            return cell
            
        case .Brick:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrickCell", for: indexPath) as! BrickCell
            cell.delegate = self
            
            switch searchType {
            case .airTkt:
                cell.setCellWith(countryInfo: (countryList?[indexPath.row])!, cityInfo: nil, searchType: .airTkt)
                
            case .lcc:
                cell.setCellWith(countryInfo: nil, cityInfo: (cityList?[indexPath.row])!, searchType: .lcc)
                
            default:
                ()
            }
            return cell
            
        case .SearchEmpty:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchEmptyCell", for: indexPath) as! SearchEmptyCell
            cell.setEmptyHint()
            
            return cell
            
        case .SearchResult:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
            cell.delegate = self
            
            switch searchType {
            case .airTkt:
                cell.setCellWith(cityInfo: searchResultList[indexPath.row], searchText: searchText, searchType: .airTkt)
                
            case .lcc:
                cell.setCellWith(cityInfo: searchResultList[indexPath.row], searchText: searchText, searchType: .lcc)
                
            default:
                ()
            }
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
}

extension ChooseLocationViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        searchBar.endEditing(true)
    }
}

extension ChooseLocationViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize = CGSize()
        
        let textFont = UIFont.init(name: "PingFang-TC-Regular", size: 14)!
        var textString: String?
        var textMaxSize = CGSize()
        var textLabelSize = CGSize()
        
        switch Section(rawValue: indexPath.section) {
        case .Capsule:
            switch searchType {
            case .airTkt:
                textString = airTicketInfo?.areaList[indexPath.item].areaName
                
            case .lcc:
                textString = lccAirInfo?.countryList[indexPath.item].countryName
                
            default:
                ()
            }
            
            textMaxSize = CGSize(width: 100, height: 28)
            textLabelSize = self.textSize(text: textString ?? "", font: textFont, maxSize: textMaxSize)
            
            cellSize.width = textLabelSize.width + 24
            cellSize.height = 28
            
            return cellSize
            
        case .Brick:
            cellSize.width = (collectionView.frame.width - 65) / 2
            cellSize.height = 36
            
            return cellSize
            
        case .SearchEmpty:
            cellSize.width = collectionView.frame.width
            cellSize.height = collectionView.frame.height
            
            return cellSize
            
        case .SearchResult:
            textString = searchResultList[indexPath.item].cityName
            textMaxSize = CGSize(width: collectionView.frame.width - 48, height: 40)
            textLabelSize = self.textSize(text: textString ?? "", font: textFont, maxSize: textMaxSize)
            
            cellSize.width = collectionView.frame.width - 48
            cellSize.height = textLabelSize.height
            
            return cellSize
            
        default:
            return cellSize
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        switch Section(rawValue: section) {
        case .Capsule:
            return 12
            
        case .Brick:
            return 8
            
        case .SearchEmpty:
            return 0
            
        case .SearchResult:
            return 22
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        switch Section(rawValue: section) {
        case .Capsule:
            return 8
            
        case .Brick:
            return 33
            
        case .SearchEmpty:
            return 0
            
        case .SearchResult:
            return 0
            
        default:
            return 0
        }
    }
}
