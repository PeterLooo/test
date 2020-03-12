//
//  LCCSearchLocationViewController.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/9.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

protocol SetLCCSearchLocationProtocol: NSObjectProtocol {
    
    func setLocation(airportInfo: AirTicketSearchResponse.AirInfo)
}

class LCCSearchLocationViewController: BaseViewController {
    
    enum Section: Int, CaseIterable {
        case Country = 0
        case Airport
        case SearchEmpty
        case SearchResult
    }
    
    weak var delegate: SetLCCSearchLocationProtocol?
    
    private var presenter: LCCSearchLocationPresenter?
    required init?(coder: NSCoder) {
           super.init(coder: coder)
           
           presenter = LCCSearchLocationPresenter(delegate: self)
       }
    
    private var LCCInfo: AirTicketSearchResponse.LCC?
    private var countryIndex = 0
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
        
        collectionView.register(UINib(nibName: "LCCCountryCell", bundle: nil), forCellWithReuseIdentifier: "LCCCountryCell")
        collectionView.register(UINib(nibName: "LCCAirportCell", bundle: nil), forCellWithReuseIdentifier: "LCCAirportCell")
        collectionView.register(UINib(nibName: "SearchEmptyCell", bundle: nil), forCellWithReuseIdentifier: "SearchEmptyCell")
        collectionView.register(UINib(nibName: "SearchResultCell", bundle: nil), forCellWithReuseIdentifier: "SearchResultCell")
        
        LCCInfo?.countryList.first?.isSelected = true
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
}

extension LCCSearchLocationViewController: LCCSearchLocationViewProtocol {
    
    func onBindLCCInfo(response: AirTicketSearchResponse) {
        
        LCCInfo = response.lCC
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
extension LCCSearchLocationViewController {
    
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

extension LCCSearchLocationViewController: LCCCountryCellProtocol {
    
    func onTouchConutry(countryInfo: AirTicketSearchResponse.CountryInfo) {
        
        self.LCCInfo?.countryList.forEach({ (country) in
            
            if country == countryInfo {
                
                country.isSelected = true
            } else {
                
                country.isSelected = false
            }
        })
        
        collectionView.reloadData()
        setCollectionViewLayout()
    }
}

extension LCCSearchLocationViewController: LCCAirportCellProtocol {
    
    func onTouchAirport(airportInfo: AirTicketSearchResponse.AirInfo) {
        
        self.LCCInfo?.countryList.forEach({ (country) in
            
            country.airportList?.forEach({ (airport) in
                
                if airport == airportInfo {
                    
                    self.delegate?.setLocation(airportInfo: airportInfo)
                    self.dismiss(animated: true, completion: nil)
                }
            })
        })
    }
}

extension LCCSearchLocationViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch Section(rawValue: section) {
        case .Country:
            return LCCInfo?.countryList.count ?? 0
            
        case .Airport:
            let airports = LCCInfo?.countryList.filter { $0.isSelected == true }.first
            return airports?.airportList?.count ?? 0
            
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
        case .Country:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LCCCountryCell", for: indexPath) as! LCCCountryCell
            cell.setCellWith(countryInfo: (LCCInfo?.countryList[indexPath.row])!)
            cell.delegate = self
            
            return cell
            
        case .Airport:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LCCAirportCell", for: indexPath) as! LCCAirportCell
            let countryInfo = LCCInfo?.countryList.filter { $0.isSelected == true }.first
            cell.setCellWith(airportInfo: (countryInfo?.airportList?[indexPath.row])!)
            cell.delegate = self

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

extension LCCSearchLocationViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        searchBar.endEditing(true)
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(setCollectionViewLayout), object: nil)
        perform(#selector(setCollectionViewLayout), with: nil, afterDelay: 0.5)
    }
}

extension LCCSearchLocationViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        // 搜尋之後要記得重新給UIEdgeInsets
        switch Section(rawValue: section) {
        case .Country:
            return UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
            
        case .Airport:
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
        case .Country:
            let textFont = UIFont.init(name: "PingFang-TC-Regular", size: 14)!
            let textString = LCCInfo?.countryList[indexPath.item].country ?? ""
            let textMaxSize = CGSize(width: 100, height: CGFloat(MAXFLOAT))
            let textLabelSize = self.textSize(text: textString, font: textFont, maxSize: textMaxSize)

            cellSize.width = textLabelSize.width + 24
            cellSize.height = 28

            return cellSize

        case .Airport:
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
        case .Country:
            return 12
            
        case .Airport:
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
        case .Country:
            return 8
            
        case .Airport:
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
