//
//  ShareFunc.swift
//  colatour
//
//  Created by M6853 on 2018/11/16.
//  Copyright © 2018 Colatour. All rights reserved.
//

import UIKit

class ShareFunc: NSObject {
    static func getVC(st: String, vc: String) -> UIViewController{
        let storyboard = UIStoryboard(name: st, bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: vc)
        
        return viewController
    }
    
    static func safeReload(tableView: UITableView, section: Int) {
        if (tableView.numberOfRows(inSection: section) == 0) {
            //如果Section中row數量為零，不reload
            return
        }
        
        tableView.beginUpdates()
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .fade)
        tableView.endUpdates()
    }
    
    static func safeReload(tableView: UITableView, section: Int, row: Int) {
        if (tableView.numberOfRows(inSection: section) == 0) {
            //如果Section中row數量為零，不reload
            return
        }
        
        if (tableView.numberOfRows(inSection: section) < row + 1) {
            //如果Section中row數量不到row，不reload
            return
        }
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath.init(row: row, section: section)], with: .fade)
        tableView.endUpdates()
    }
    
    func getVC(st: String, vc: String) -> UIViewController {
        let storyboard = UIStoryboard(name: st, bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: vc)
        
        return viewController
    }
}
