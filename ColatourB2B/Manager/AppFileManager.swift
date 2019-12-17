//
//  FileManager.swift
//  colatour
//
//  Created by M6985 on 2019/4/1.
//  Copyright © 2019 Colatour. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import ObjectMapper

class AppFileManager: NSObject{
    
    static let shared = AppFileManager()
    fileprivate var dispose = DisposeBag()
    
    let documentDirectoryURL : URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    var fileDirectoryURL : URL {
        get {
            let memberNo = UserDefaultUtil.shared.memberNo
            let memberNoToString = ( memberNo == nil ) ? "unknown" : "\(memberNo!)"
            return documentDirectoryURL.appendingPathComponent("Colatour/Order/\(memberNoToString)")
        }
    }
    
    var scheduleFileDirectoryURLs : URL {
        get {
            let memberNo = UserDefaultUtil.shared.memberNo
            let memberNoToString = ( memberNo == nil ) ? "unknown" : "\(memberNo!)"
            return documentDirectoryURL.appendingPathComponent("Colatour/Schedule/\(memberNoToString)")
        }
    }

    let eTicketJsonFileName = "ETicket"
    let eTicketJsonExtension = "json"
    var eTicketJsonFileURL : URL {
        get {
            return fileDirectoryURL
                .appendingPathComponent(eTicketJsonFileName)
                .appendingPathExtension(eTicketJsonExtension)
        }
    }
    
    let error = NSError(domain: "JsonFileError", code: 0, userInfo: [:])
    
    private func getFileURL(orderNo: Int, fileName: String) -> URL {
        return fileDirectoryURL.appendingPathComponent("\(orderNo)", isDirectory: true).appendingPathComponent(fileName)
    }
    
    private func getFileURL(downloadUrl:String, toruDate:String, fileName: String) -> URL {
        return scheduleFileDirectoryURLs.appendingPathComponent("\(toruDate)", isDirectory: true).appendingPathComponent("\(fileName)")
    }
    
    func getLocalETicketJson() -> Single<[String:Any]> {

        let eTicketJsonFilePath = eTicketJsonFileURL.path
        
        if (FileManager.default.fileExists(atPath: eTicketJsonFilePath) == false) {
            return Single.error(error)
        }
        
        //Note : throw NSString初始化 錯誤
        //Note : throw convertToDictionary 錯誤
        do{
            let json = try NSString(contentsOfFile: eTicketJsonFilePath, encoding: String.Encoding.utf8.rawValue) as String
            let jsonObj: [String:Any] = try convertToDictionary(text: json)
            return Single.just(jsonObj)
        }catch{
            return Single.error(error)
        }
    }
    
    func saveETicketResponse(eTicketResponse: ETicketResponse) {
        //TODO 失敗需處理嗎 ?
        if let data = try? JSONSerialization.data(withJSONObject: eTicketResponse.toJSON(), options: []){
            try? FileManager.default.createDirectory(at: fileDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            try? data.write(to: eTicketJsonFileURL)
        }
    }

    func loadLocalShcheduleDetailFileWith(downloadUrl: String, toruDate: String, fileName: String) -> URL? {
        let url = getFileURL(downloadUrl: downloadUrl, toruDate: toruDate, fileName: fileName)
        if FileManager.default.fileExists(atPath: url.path){
            return url
        }else{
            return nil
        }
    }
    
    func loadLocalETicketFileWith(orderNo: Int, fileName: String) -> URL? {
        //TODO 失敗需要throw嗎 ?
        let url = getFileURL(orderNo: orderNo, fileName: fileName)
        if FileManager.default.fileExists(atPath: url.path){
            return url
        }else{
            return nil
        }
    }
    
    private func convertToDictionary(text: String) throws -> [String: Any]  {
        let data = text.data(using: .utf8)
        
        //Note : throw text 轉 Data 錯誤
        if (data == nil) {
            throw error
        }
        
        //Note: throw JSONSerialization錯誤
        //Note: 如：傳了不是json格式的文字，"a".data(using: .utf8)
        let jsonObj = try JSONSerialization.jsonObject(with: data!, options: [])
        
        //Note : throw jsonObj 轉 [String: Any] 錯誤
        let jsonObjDictionary = jsonObj as? [String: Any]
        if (jsonObjDictionary == nil) {
            throw error
        }
        
        return jsonObjDictionary!
    }
    
    func removeItem(atFilePath: URL){
        try? FileManager.default.removeItem(at: atFilePath)
    }
}
