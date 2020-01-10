//
//  GroupNavigationView.swift
//  ColatourB2B
//
//  Created by M6985 on 2020/1/7.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit
protocol GroupNavigationViewProtocol: NSObjectProtocol {
    func onTouchSearchView()
}
class GroupNavigationView: UIView {

    weak var delegate: GroupNavigationViewProtocol?
    @IBOutlet weak var searchView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUp()
    }
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    fileprivate func setUp(){
        let bundle = Bundle.init(for: self.classForCoder)
        let nib = UINib.init(nibName: "GroupNavigationView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        self.addSubview(view)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        
        let ges = UITapGestureRecognizer(target: self, action: #selector(onTouchSearch))
        searchView.addGestureRecognizer(ges)
        searchView.isUserInteractionEnabled = true
        
        searchView.setBorder(width: 0.5, radius: 17, color: UIColor.init(red: 230, green: 230, blue: 230))
        
    }

    @objc private func onTouchSearch() {
        self.delegate?.onTouchSearchView()
    }
}
