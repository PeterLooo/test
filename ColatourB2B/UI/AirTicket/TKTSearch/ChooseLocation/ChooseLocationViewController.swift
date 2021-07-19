//
//  ChooseLocationViewController.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/9.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

extension ChooseLocationViewController {
    
    func setVC(viewModel: ChooseLocationViewModel) {
        
        self.viewModel = viewModel
        infoSort()
    }
}

class ChooseLocationViewController: BaseViewControllerMVVM {
    
    enum Section: Int, CaseIterable {
        case Capsule = 0
        case Brick
        case SearchEmpty
        case SearchResult
    }
    
    var viewModel: ChooseLocationViewModel?
    var setLocation: ((_ cityInfo: TKTInitResponse.TicketResponse.City?, _ searchType: SearchByType?, _ arrival: ArrivalType?, _ startEndType: StartEndType?) -> ())?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setView()
        setNavBarItem(left: .custom, mid: .searchBar, right: .nothingWithEmptySpace)
        setNavCustom()
        setCollectionView()
        setCollectionViewLayout()
    }
    
    @objc func dimissKeyBoard() {
        
        self.searchBar.endEditing(true)
    }
    
    @objc private func onTouchCancel() {
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func setCollectionViewLayout() {
        
        self.collectionView.setCollectionViewLayout(UICollectionViewFlowLayout(), animated: false)
    }
}

// UISearchBarDelegate
extension ChooseLocationViewController {
    
    override func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        switch viewModel?.searchType {
        case .airTkt:
            return viewModel?.searchText.count ?? 0 <= 3
        default:
            return true
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchBar.text = searchText.uppercased()
        viewModel?.getSearch(searchText: searchText)
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchBar.endEditing(true)
    }
}

extension ChooseLocationViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch Section(rawValue: section) {
        case .Capsule:
            
            switch viewModel?.searchType {
            case .airTkt:
                if (viewModel?.searchText.count ?? 0) >= 1 { return 0 }
                return viewModel?.airTicketInfo?.areaList.count ?? 0
                
            case .lcc:
                if (viewModel?.searchText.count ?? 0) >= 2 { return 0 }
                return viewModel?.lccAirInfo?.countryList.count ?? 0
                
            default:
                return 0
            }
            
        case .Brick:
            switch viewModel?.searchType {
            case .airTkt:
                if (viewModel?.searchText.count ?? 0) >= 1 { return 0 }
                viewModel?.area = viewModel?.airTicketInfo?.areaList.filter{ $0.isSelected == true }.first
                viewModel?.countryList = viewModel?.airTicketInfo?.countryList.filter{ $0.areaId == viewModel?.area?.areaId }
                return viewModel?.countryList?.count ?? 0
                
            case .lcc:
                if (viewModel?.searchText.count ?? 0) >= 2 { return 0 }
                let country = viewModel?.lccAirInfo?.countryList.filter { $0.isSelected == true }.first
                viewModel?.cityList = country?.cityList
                return viewModel?.cityList?.count ?? 0
                
            default:
                return 0
            }
            
        case .SearchEmpty:
            switch viewModel?.searchType {
            case .airTkt:
                if (viewModel?.searchText.count ?? 0) >= 1 && viewModel?.searchResultList.count == 0 { return 1 }
                
            case .lcc:
                if (viewModel?.searchText.count ?? 0) >= 2 && viewModel?.searchResultList.count == 0 { return 1 }
                
            default:
                return 0
            }
            return 0
            
        case .SearchResult:
            return viewModel?.searchResultList.count ?? 0
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellName = viewModel?.setCellViewModel(section: indexPath.section, row: indexPath.row)
        
        switch cellName {
        case "capsuleCell":
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CapsuleCell", for: indexPath) as! CapsuleCell
            cell.setCell(viewModel: (viewModel?.capsuleCellViewModel)!)
            return cell
            
        case "brickCell":
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrickCell", for: indexPath) as! BrickCell
            cell.setCell(viewModel: (viewModel?.brickCellViewModel)!)
            return cell
            
        case "searchEmpty":
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchEmptyCell", for: indexPath) as! SearchEmptyCell
            cell.setEmptyHint()
            return cell
            
        case "searchResultCell":
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
            cell.setCellWith(viewModel: (viewModel?.searchResultCellViewModel)!)
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
            switch viewModel?.searchType {
            case .airTkt:
                if (viewModel?.searchText.count ?? 0) >= 1 { return .zero }
                
            case .lcc:
                if (viewModel?.searchText.count ?? 0) >= 2 { return .zero }
                
            default:
                return .zero
            }
            return UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
            
        case .Brick:
            switch viewModel?.searchType {
            case .airTkt:
                if (viewModel?.searchText.count ?? 0) >= 1 { return .zero }
                
            case .lcc:
                if (viewModel?.searchText.count ?? 0) >= 2 { return .zero }
                
            default:
                return .zero
            }
            return UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
            
        case .SearchEmpty:
            return .zero
            
        case .SearchResult:
            if (viewModel?.searchText.count ?? 0) != 0 && (viewModel?.searchResultList.count ?? 0) == 0 { return .zero }
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
            switch viewModel?.searchType {
            case .airTkt:
                textString = viewModel?.airTicketInfo?.areaList[indexPath.item].areaName
                
            case .lcc:
                textString = viewModel?.lccAirInfo?.countryList[indexPath.item].countryName
                
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
            textString = viewModel?.searchResultList[indexPath.item].cityName
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

extension ChooseLocationViewController {
    
    private func bindViewModel() {
        
        self.bindToBaseViewModel(viewModel: self.viewModel!)
        
        viewModel?.reloadData = { [weak self] in
            self?.collectionView.reloadData()
            self?.setCollectionViewLayout()
        }
        
        viewModel?.toLocationDetailViewController = { [weak self] countryInfo in
            let vc = self?.getVC(st: "LocationDetail", vc: "LocationDetail") as! LocationDetailViewController
            vc.setVC(viewModel: LocationDetailViewModel(countryInfo: countryInfo!))
            vc.setChooseCity = { [weak self] cityInfo in
                self?.setLocation?(cityInfo, .airTkt, self?.viewModel?.arrival, self?.viewModel?.startEndType)
                self?.dismiss(animated: true, completion: nil)
            }
            
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        viewModel?.setLocation = { [weak self] cityInfo, searchType, arrival, startEndType in
            self?.setLocation?(cityInfo, searchType, arrival, startEndType)
            self?.dismiss(animated: true, completion: nil)
        }
        
        viewModel?.uppercased = { [weak self]  maxLengthThreeText in
            self?.searchBar.text = maxLengthThreeText.uppercased()
        }
    }
    
    private func setView() {
        let ges = UITapGestureRecognizer.init(target: self, action: #selector(dimissKeyBoard))
        view.addGestureRecognizer(ges)
        
        searchBar.becomeFirstResponder()
        
        switch viewModel?.searchType {
        case .airTkt:
            setSearchBarPlaceHolder(text: "輸入 目的城市/機場代碼")
        case .lcc:
            setSearchBarPlaceHolder(text: "輸入 國家/城市/機場代碼")
        default:
            ()
        }
    }
    
    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "CapsuleCell", bundle: nil), forCellWithReuseIdentifier: "CapsuleCell")
        collectionView.register(UINib(nibName: "BrickCell", bundle: nil), forCellWithReuseIdentifier: "BrickCell")
        collectionView.register(UINib(nibName: "SearchEmptyCell", bundle: nil), forCellWithReuseIdentifier: "SearchEmptyCell")
        collectionView.register(UINib(nibName: "SearchResultCell", bundle: nil), forCellWithReuseIdentifier: "SearchResultCell")
    }
    
    private func setNavCustom() {
        
        let close = UIBarButtonItem(image:  #imageLiteral(resourceName: "close").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(self.onTouchCancel))
        setCustomLeftBarButtonItem(barButtonItem: close)
    }
    
    private func textSize(text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        
        return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : font], context: nil).size
    }
    
    func infoSort() {
        
        switch viewModel?.startEndType {
        case .Departure:
            if viewModel?.searchType == SearchByType.lcc {
                var tempInfo: [TKTInitResponse.TicketResponse.Country] = []
                let taiwan = viewModel?.lccAirInfo?.countryList.filter { $0.countryName == "台灣" }.first ?? TKTInitResponse.TicketResponse.Country()
                
                tempInfo = viewModel?.lccAirInfo?.countryList.filter { $0.countryName != "台灣" } ?? []
                tempInfo.insert(taiwan, at: 0)
                
                viewModel?.lccAirInfo?.countryList = tempInfo
            }
            
        case .Destination:
            var tempInfo: [TKTInitResponse.TicketResponse.Country] = []
            let japan = viewModel?.lccAirInfo?.countryList.filter { $0.countryName == "日本" }.first ?? TKTInitResponse.TicketResponse.Country()
            let taiwan = viewModel?.lccAirInfo?.countryList.filter { $0.countryName == "台灣" }.first ?? TKTInitResponse.TicketResponse.Country()
            
            tempInfo = viewModel?.lccAirInfo?.countryList.filter { $0.countryName != "日本" } ?? []
            tempInfo = tempInfo.filter { $0.countryName != "台灣" }
            tempInfo.insert(japan, at: 0)
            tempInfo.append(taiwan)
            
            viewModel?.lccAirInfo?.countryList = tempInfo
            
        default:
            ()
        }
        
        viewModel?.airTicketInfo?.areaList.forEach { $0.isSelected = false }
        viewModel?.airTicketInfo?.areaList.first?.isSelected = true
        viewModel?.lccAirInfo?.countryList.forEach { $0.isSelected = false }
        viewModel?.lccAirInfo?.countryList.first?.isSelected = true
    }
}
