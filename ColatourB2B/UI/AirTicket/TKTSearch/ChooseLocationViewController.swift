//
//  ChooseLocationViewController.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/9.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

protocol SetChooseLocationProtocol: NSObjectProtocol {
    
    func setLocation(cityInfo: TKTInitResponse.TicketResponse.City)
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
    private var lccAirInfo: TKTInitResponse.TicketResponse?
    private var area: TKTInitResponse.TicketResponse.Area?
    private var countryList: [TKTInitResponse.TicketResponse.Country]?
    private var cityList: [TKTInitResponse.TicketResponse.City]?
    private var searchText = ""
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var keyWord = ""
    var searchResultText:String?
    var searchResultList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ges = UITapGestureRecognizer.init(target: self, action: #selector(dimissKeyBoard))
        view.addGestureRecognizer(ges)
        
        searchBar.becomeFirstResponder()
        
        setNavBarItem(left: .custom, mid: .searchBar, right: .nothingWithEmptySpace)
        setSearchBarPlaceHolder(text: "輸入 國家/城市/機場代碼")
        setNavCustom()
    
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "CapsuleCell", bundle: nil), forCellWithReuseIdentifier: "CapsuleCell")
        collectionView.register(UINib(nibName: "BrickCell", bundle: nil), forCellWithReuseIdentifier: "BrickCell")
        collectionView.register(UINib(nibName: "SearchEmptyCell", bundle: nil), forCellWithReuseIdentifier: "SearchEmptyCell")
        collectionView.register(UINib(nibName: "SearchResultCell", bundle: nil), forCellWithReuseIdentifier: "SearchResultCell")
        
        setCollectionViewLayout()
    }
    
    override func loadData() {
        
        self.searchResultText = self.keyWord
        
        if self.searchResultText != nil {
            
            self.searchBar.text = self.searchResultText
            searchBar((self.searchBar), textDidChange: self.searchResultText!)
        }
        presenter?.getSearchResult()
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
    
    func setViewControllerByKeyWord(keyWord: String){
        
        self.keyWord = keyWord
    }
    
    @objc func setCollectionViewLayout(){
        
        self.collectionView.setCollectionViewLayout(UICollectionViewFlowLayout(), animated: false)
    }
    
    func infoSort() {
        
//        switch startEndType {
//        case .Departure:
//            if searchType == SearchByType.lcc {
//                var tempInfo: [AirTicketSearchResponse.CountryInfo] = []
//                let taiwan = (lccAirInfo?.countryList.filter { $0.country == "台灣" }.first)!
//
//                tempInfo = (lccAirInfo?.countryList.filter { $0.country != "台灣" })!
//                tempInfo.insert(taiwan, at: 0)
//
//                lccAirInfo?.countryList = tempInfo
//            }
//
//        case .Destination:
//            var tempInfo: [AirTicketSearchResponse.CountryInfo] = []
//            let japan = (lccAirInfo?.countryList.filter { $0.country == "日本" }.first)!
//            let taiwan = (lccAirInfo?.countryList.filter { $0.country == "台灣" }.first)!
//
//            tempInfo = (lccAirInfo?.countryList.filter { $0.country != "日本" })!
//            tempInfo = tempInfo.filter { $0.country != "台灣" }
//            tempInfo.insert(japan, at: 0)
//            tempInfo.append(taiwan)
//
//            lccAirInfo?.countryList = tempInfo
//
//        default:
//            ()
//        }
        
        airTicketInfo?.areaList.forEach { $0.isSelected = false }
        airTicketInfo?.areaList.first?.isSelected = true
//        lccAirInfo?.countryList.forEach { $0.isSelected = false }
//        lccAirInfo?.countryList.first?.isSelected = true
    }
}

extension ChooseLocationViewController: ChooseLocationViewProtocol {
    
    func onBindAirTicketInfo(tktSearchInit: TKTInitResponse.TicketResponse, searchType: SearchByType, startEndType: StartEndType) {
        
        self.searchType = searchType
        self.startEndType = startEndType
        
        switch searchType {
        case .airTkt:
            airTicketInfo = tktSearchInit
//            airTicketInfo?.areaList.first?.isSelected = true
        case .soto:
            ()
            
        case .lcc:
            lccAirInfo = tktSearchInit
        }
        
        infoSort()
    }
    
    func onBindSearchResult() {
        
        ()
    }
//            (result: ) {
//
//            if self.searchText == "" { return }
//
//            self.searchResultList = result.
//
//            collectionView.reloadData()
//            setCollectionViewLayout()
//        }
}

// UISearchBarDelegate
extension ChooseLocationViewController {
    
   override func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
       return true
   }
   
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
       if (2 <= searchText.count && searchText.count <= 10) {
        
           self.searchResultText = searchText
           self.keyWord = searchText
       } else if (searchText.count == 0) {
        
           self.searchResultList = []
           self.searchResultText = searchText
       } else if (searchText.count > 10) {
        
           self.searchResultText = searchText
       }
   }
   
   func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
       self.searchBar.endEditing(true)
   }
}

extension ChooseLocationViewController: CapsuleCellProtocol {
    
    func onTouchCapsule(areaInfo: TKTInitResponse.TicketResponse.Area) {
        
        self.airTicketInfo?.areaList.forEach({ (area) in
            
            if area == areaInfo {
                
                area.isSelected = true
            } else {
                
                area.isSelected = false
            }
        })
        collectionView.reloadData()
        setCollectionViewLayout()
    }
    
//    func onTouchCapsule(countryInfo: AirTicketSearchResponse.CountryInfo) {
//
//        self.lccAirInfo?.countryList.forEach({ (country) in
//
//            if country == countryInfo {
//
//                country.isSelected = true
//            } else {
//
//                country.isSelected = false
//            }
//        })
//
//        collectionView.reloadData()
//        setCollectionViewLayout()
//    }
}

extension ChooseLocationViewController: BrickCellProtocol {

    func onTouchBrick(countryInfo: TKTInitResponse.TicketResponse.Country) {
        let vc = getVC(st: "LocationDetail", vc: "LocationDetail") as! LocationDetailViewController
        vc.onBindCountryInfo(countryInfo: countryInfo)
        vc.delegate = self

        self.navigationController?.pushViewController(vc, animated: true)
    }

//    func onTouchBrick(airportInfo: AirTicketSearchResponse.AirInfo) {
//
//        self.lccAirInfo?.countryList.forEach({ (country) in
//
//            country.airportList?.forEach({ (airport) in
//
//                if airport == airportInfo {
//
//                    self.delegate?.setLocation(airportInfo: airportInfo, startEndType: startEndType!)
//                    self.dismiss(animated: true, completion: nil)
//                }
//            })
//        })
//    }
}

extension ChooseLocationViewController: SetChooseCityProtocol {
    
    func setChooseCity(cityInfo: TKTInitResponse.TicketResponse.City) {
        
        delegate?.setLocation(cityInfo: cityInfo)
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
                return airTicketInfo?.areaList.count ?? 0
                
            case .lcc:
                return 0 //lccAirInfo?.countryList.count ?? 0
 
            default:
                return 0
            }
            
        case .Brick:
            
            switch searchType {
            case .airTkt:
                area = airTicketInfo?.areaList.filter{ $0.isSelected == true }.first
                countryList = airTicketInfo?.countryList.filter{ $0.areaId == area?.areaId }
                return countryList?.count ?? 0
                
            case .lcc:
//                let country = lccAirInfo?.countryList.filter { $0.isSelected == true }.first
//                return country?.airportList?.count ?? 0
                return 0
                
            default:
                return 0
            }
            
        case .SearchEmpty:
            return 0
            
        case .SearchResult:
            return 0
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch Section(rawValue: indexPath.section) {
        case .Capsule:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CapsuleCell", for: indexPath) as! CapsuleCell
            cell.delegate = self
            cell.setCellWith(airTicketInfo: airTicketInfo!, searchType: searchType!, row: indexPath.row)
                
            return cell
            
        case .Brick:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrickCell", for: indexPath) as! BrickCell
            cell.delegate = self
            
            switch searchType {
            case .airTkt:
                
                cell.setCellWithCountry(countryInfo: (countryList?[indexPath.row])!, searchType: searchType!)
                
                return cell
                
            case .lcc:
                ()
                
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
            cell.setCellWith(text: "搜尋結果名稱")
            
            return cell

        default:
            return UICollectionViewCell()
        }
    }
}

extension ChooseLocationViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        searchBar.endEditing(true)
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(setCollectionViewLayout), object: nil)
        perform(#selector(setCollectionViewLayout), with: nil, afterDelay: 0.5)
    }
}

extension ChooseLocationViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        // 搜尋之後要記得重新給UIEdgeInsets
        switch Section(rawValue: section) {
        case .Capsule:
            return UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
            
        case .Brick:
            return UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
            
        case .SearchEmpty:
            return .zero
            
        case .SearchResult:
            return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
            
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize = CGSize()
        
        switch Section(rawValue: indexPath.section) {
        case .Capsule:
            var textString: String?
            
            switch searchType {
            case .airTkt:
                textString = airTicketInfo?.areaList[indexPath.item].areaName
                
            case .lcc:
                () //textString = lccAirInfo?.countryList[indexPath.item].country ?? ""
                
            default:
                ()
            }
            
            let textFont = UIFont.init(name: "PingFang-TC-Regular", size: 14)!
            let textMaxSize = CGSize(width: 100, height: CGFloat(MAXFLOAT))
            let textLabelSize = self.textSize(text: textString ?? "", font: textFont, maxSize: textMaxSize)

            cellSize.width = textLabelSize.width + 24
            cellSize.height = 28

            return cellSize

        case .Brick:
            cellSize.width = 155
            cellSize.height = 36
            
            return cellSize
            
        case .SearchEmpty:
            cellSize.width = collectionView.frame.width
            cellSize.height = collectionView.frame.height
            
            return cellSize
            
        case .SearchResult:
            cellSize.width = collectionView.frame.width
            cellSize.height = 20
            
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
