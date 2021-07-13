//
//  AirTicketSearchViewModel.swift
//  ColatourB2B
//
//  Created by 7690 劉晉賢 on 2021/7/6.
//  Copyright © 2021 Colatour. All rights reserved.
//

import Foundation
import RxSwift

class AirTicketSearchViewModel: BaseViewModel {
    
    var searchType: SearchByType?
    var airSearchInit: TKTInitResponse.TicketResponse?
    var sotoSearchInit: TKTInitResponse.TicketResponse?
    var lccSearchInit: LccResponse.LCCSearchInitialData?
    var airTicketRequest = TKTSearchRequest()
    var sotoTicketRequest = SotoTicketRequest()
    var lccTicketRequest = LccTicketRequest()
    
    var airTktCellViewModel : AirTktCellViewModel?
    var sotoAirCellViewModel: SotoAirCellViewModel?
    var lccAirCellViewModel: LccAirCellViewModel?
    
    var groupAirReloadData: (() -> ())?
    var sotoAirReloadData: (() -> ())?
    var lccReloadData: (() -> ())?
    var onTouchDate: (() -> ())?
    var onTouchSearch: (() -> ())?
    var onTouchNonStop: (() -> ())?
    var onTouchLccDeparture: (() -> ())?
    var onTouchLccDestination: (() -> ())?
    var onTouchLccRequestByPerson: (() -> ())?
    var onTouchAirlineSwitch: (() -> ())?
    var onTouchLccDate: (() -> ())?
    var onTouchRadio: (() -> ())?
    var onTouchPax: (() -> ())?
    
    var onTouchSelection: ((_ selection: TKTInputFieldType) -> ())?
    var onTouchArrival: ((_ arrival: ArrivalType) -> ())?
    var bindSearchUrlResult: ((_ result: AirSearchUrlResponse.AirUrlResult) -> ())?
    
    fileprivate let repository = TKTRepository.shared
    fileprivate var dispose = DisposeBag()
    
    required init (searchType: SearchByType) {
        self.searchType = searchType
    }
    
    func getAirTicketSearchInit() {
        onStartLoadingHandle?(.coverPlate)
        
        repository.getAirSearchInit().subscribe(onSuccess: { [weak self] (model) in
            self?.onBindAirTicketSearchInit(tktSearchInit: model)
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.onApiErrorHandle?((error as! APIError), .coverPlate)
            self?.onCompletedLoadingHandle?()
        }).disposed(by: dispose)
    }
    
    func getSotoAirSearchInit() {
        onStartLoadingHandle?(.coverPlate)
        
        repository.getSotoSearchInit().subscribe(onSuccess: { [weak self] (model) in
            self?.onBindSotoAirSearchInit(sotoSearchInit: model)
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.onApiErrorHandle?((error as! APIError), .coverPlate)
            self?.onCompletedLoadingHandle?()
        }).disposed(by: dispose)
    }
    
    func getLccAirSearchInit() {
        onStartLoadingHandle?(.coverPlate)
        
        repository.getLccSearchInit().subscribe(onSuccess: { [weak self] (model) in
            
            self?.onBindLccAirSearchInit(lccSearchInit: model)
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.onApiErrorHandle?((error as! APIError), .custom)
            self?.onCompletedLoadingHandle?()
        }).disposed(by: dispose)
    }
    
    func postAirTicketSearch() {
        onStartLoadingHandle?(.coverPlate)
        repository.postAirTicketSearch(request: airTicketRequest).subscribe(onSuccess: { [weak self] (model) in
            self?.onBindSearchUrlResult(result: model)
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.onApiErrorHandle?((error as! APIError), .alert)
            self?.onCompletedLoadingHandle?()
        }).disposed(by: dispose)
    }
    
    func postSotoTicketSearch() {
        onStartLoadingHandle?(.coverPlate)
        repository.postSotoTicketSearch(request: sotoTicketRequest).subscribe(onSuccess: { [weak self] (model) in
            self?.onBindSearchUrlResult(result: model)
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.onApiErrorHandle?((error as! APIError), .alert)
            self?.onCompletedLoadingHandle?()
        }).disposed(by: dispose)
    }
    
    func postLCCTicketSearch() {
        onStartLoadingHandle?(.coverPlate)
        repository.postLCCicketSearch(request: lccTicketRequest).subscribe(onSuccess: { [weak self] (model) in
            self?.onBindSearchUrlResult(result: model)
            self?.onCompletedLoadingHandle?()
        }, onError: { [weak self] (error) in
            self?.onApiErrorHandle?((error as! APIError), .alert)
            self?.onCompletedLoadingHandle?()
        }).disposed(by: dispose)
    }
    
    func setCellViewModel(tableView: String) {
        
        switch tableView {
        case "AirTktCell":
            airTktCellViewModel = AirTktCellViewModel(info: airTicketRequest)
            
            airTktCellViewModel?.onTouchArrival = { [weak self] arrival, searchType in
                self?.searchType = searchType
                self?.onTouchArrival?(arrival)
            }
            
            airTktCellViewModel?.onTouchDate = { [weak self]  searchType in
                self?.searchType = searchType
                self?.onTouchDate?()
            }
            
            airTktCellViewModel?.onTouchSearch = { [weak self] searchType in
                self?.searchType = searchType
                self?.onTouchSearch?()
            }
            
            airTktCellViewModel?.onTouchSelection = { [weak self] selection, searchType in
                self?.searchType = searchType
                self?.onTouchSelection?(selection)
            }
            airTktCellViewModel?.onTouchNonStop =  { [weak self] searchType in
                
                switch searchType {
                case .airTkt:
                    self?.airTicketRequest.isNonStop = !(self?.airTicketRequest.isNonStop ?? false)
                case .soto:
                    self?.sotoTicketRequest.isNonStop = !(self?.sotoTicketRequest.isNonStop ?? false)
                default:
                    ()
                }
                self?.onTouchNonStop?()
            }
            
        case "SotoAirCell":
            sotoAirCellViewModel = SotoAirCellViewModel(info: sotoTicketRequest)
            
            sotoAirCellViewModel?.onTouchSelection = { [weak self]  selection, searchType in
                self?.searchType = searchType
                self?.onTouchSelection?(selection)
            }
            
            sotoAirCellViewModel?.onTouchDate = { [weak self] searchType in
                self?.searchType = searchType
                self?.onTouchDate?()
            }
            
            sotoAirCellViewModel?.onTouchNonStop = { [weak self] searchType in
                switch searchType {
                case .airTkt:
                    self?.airTicketRequest.isNonStop = !(self?.airTicketRequest.isNonStop ?? false)
                case .soto:
                    self?.sotoTicketRequest.isNonStop = !(self?.sotoTicketRequest.isNonStop ?? false)
                default:
                    ()
                }
                self?.onTouchNonStop?()
            }
            
            sotoAirCellViewModel?.onTouchSearch = { [weak self] searchType in
                self?.searchType = searchType
                self?.onTouchSearch?()
            }
            
        case "LccAirCell":
            lccAirCellViewModel = LccAirCellViewModel(lccInfo: lccTicketRequest)
            
            lccAirCellViewModel?.onTouchLccDeparture = { [weak self] in
                self?.onTouchLccDeparture?()
            }
            
            lccAirCellViewModel?.onTouchLccDestination = { [weak self] in
                self?.onTouchLccDestination?()
            }
            
            lccAirCellViewModel?.onTouchLccRequestByPerson = { [weak self] in
                self?.onTouchLccRequestByPerson?()
            }
            
            lccAirCellViewModel?.onTouchAirlineSwitch = { [weak self] in
                self?.lccTicketRequest.isSameAirline.toggle()
                self?.onTouchAirlineSwitch?()
            }
            
            lccAirCellViewModel?.onTouchLccDate = { [weak self] in
                self?.onTouchLccDate?()
            }
            
            lccAirCellViewModel?.onTouchRadio = { [weak self] isToAndFor in
                self?.lccTicketRequest.isToAndFro = isToAndFor
                self?.onTouchRadio?()
            }
            
            lccAirCellViewModel?.onTouchPax = { [weak self] in
                self?.onTouchPax?()
            }
            
            lccAirCellViewModel?.onTouchLccSearch = { [weak self] in
                self?.searchType = .lcc
                self?.onTouchSearch?()
            }
            
        default:
            ()
        }
    }
}

extension AirTicketSearchViewModel {
    
    private func onBindAirTicketSearchInit(tktSearchInit: TKTInitResponse) {
        self.airSearchInit = tktSearchInit.initResponse
        self.airTicketRequest = TKTSearchRequest().getAirTicketRequest(response: tktSearchInit.initResponse!)
        if self.airSearchInit?.journeyTypeList.contains("來回") == true {
            self.airTicketRequest.journeyType = "來回"
        }
        groupAirReloadData?()
    }
    
    private func onBindSotoAirSearchInit(sotoSearchInit: TKTInitResponse) {
        self.sotoSearchInit = sotoSearchInit.initResponse
        self.sotoTicketRequest = SotoTicketRequest().getSotoTicketRequest(response: sotoSearchInit.initResponse!)
        if self.sotoSearchInit?.journeyTypeList.contains("來回") == true {
            self.sotoTicketRequest.journeyType = "來回"
        }
        sotoAirReloadData?()
    }
    
    private func onBindLccAirSearchInit(lccSearchInit: LccResponse) {
        self.lccSearchInit = lccSearchInit.lCCSearchInitialData
        self.lccTicketRequest = LccTicketRequest().getLccTicketRequest(reponse: self.lccSearchInit!)
        
        lccReloadData?()
    }
    
    private func onBindSearchUrlResult(result: AirSearchUrlResponse) {
        
        bindSearchUrlResult?(result.airUrlResult!)
    }
}
