//
//  LocationDetailViewController.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/16.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

protocol SetChooseCityProtocol: NSObjectProtocol {
    
    func setChooseCity(cityInfo: TKTInitResponse.TicketResponse.City)
}

class LocationDetailViewController: BaseViewController {

    weak var delegate: SetChooseCityProtocol?
    
    private var country: TKTInitResponse.TicketResponse.Country?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavTitle(title: country?.countryName ?? "")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "LocationDetailCell", bundle: nil), forCellWithReuseIdentifier: "LocationDetailCell")
    }
    
    func onBindCountryInfo(countryInfo: TKTInitResponse.TicketResponse.Country) {
        
        self.country = countryInfo
    }
}

extension LocationDetailViewController: LocationDetailCellProtocol {
    
    func onTouchCity(cityInfo: TKTInitResponse.TicketResponse.City) {
        
        delegate?.setChooseCity(cityInfo: cityInfo)
        dismiss(animated: true, completion: nil)
    }
}

extension LocationDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return country?.cityList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationDetailCell", for: indexPath) as! LocationDetailCell
        cell.delegate = self
        cell.setCellWith(cityInfo: (country?.cityList[indexPath.row])!)
        
        return cell
    }
}

extension LocationDetailViewController: UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.collectionView.setCollectionViewLayout(UICollectionViewFlowLayout(), animated: false)
    }
}

extension LocationDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         
        return CGSize(width: 155, height: 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 33
    }
}
