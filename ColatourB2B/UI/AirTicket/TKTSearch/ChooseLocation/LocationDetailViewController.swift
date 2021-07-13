//
//  LocationDetailViewController.swift
//  ColatourB2B
//
//  Created by 7635 邱郁雯 on 2020/3/16.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

extension LocationDetailViewController {
    
    func setVC(viewModel: LocationDetailViewModel) {
        self.viewModel = viewModel
    }
}

class LocationDetailViewController: BaseViewController {
    
    var setChooseCity: ((_ cityInfo: TKTInitResponse.TicketResponse.City?) -> ())?
    var viewModel: LocationDetailViewModel?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setCollectionViewLayout()
    }
}

extension LocationDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel?.country?.cityList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationDetailCell", for: indexPath) as! LocationDetailCell
        cell.setCell(viewModel: LocationDetailCellViewModel(cityInfo: (viewModel?.country?.cityList[indexPath.row])!))
        cell.onTouchCity = { [weak self] cityInfo in
            self?.setChooseCity?(cityInfo)
            self?.dismiss(animated: true, completion: nil)
        }
        return cell
    }
}

extension LocationDetailViewController: UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        setCollectionViewLayout()
    }
}

extension LocationDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize = CGSize()
        
        cellSize.width = (collectionView.frame.width - 65) / 2
        cellSize.height = 36
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 33
    }
}

extension LocationDetailViewController {
    
    private func setCollectionViewLayout() {
        self.collectionView.setCollectionViewLayout(UICollectionViewFlowLayout(), animated: false)
    }
    
    private func setView() {
        
        viewModel = LocationDetailViewModel(countryInfo: viewModel?.country ?? TKTInitResponse.TicketResponse.Country())
        setNavTitle(title: viewModel?.country?.countryName ?? "")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "LocationDetailCell", bundle: nil), forCellWithReuseIdentifier: "LocationDetailCell")
    }
}
