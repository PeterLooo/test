//
//  MemberIndexServiceCellViewModel.swift
//  ColatourB2B
//
//  Created by 6985 吳思賢 on 2021/7/7.
//  Copyright © 2021 Colatour. All rights reserved.
//

class MemberIndexServiceCellViewModel {
    var onTouchServer: (()->())?
    var serverData: ServerData?
    
    init(serverData: ServerData){
        self.serverData = serverData
    }
}
