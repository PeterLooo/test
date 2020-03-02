//
//  WebViewProtocol.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2020/2/26.
//  Copyright © 2020 Colatour. All rights reserved.
//

import UIKit

protocol WebViewProtocol: NSObjectProtocol {
    func onBindTourShareList(shareList:WebViewTourShareResponse.ItineraryShareData)
}

protocol WebViewPresenterProtocol: BasePresenterProtocol {
    func getTourShareList(tourCode: String, tourDate: String)
}
