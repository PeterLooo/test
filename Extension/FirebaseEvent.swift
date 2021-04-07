//
//  FirebaseEvents.swift
//  colatour
//
//  Created by M7268 on 2019/4/23.
//  Copyright © 2019 Colatour. All rights reserved.
//

enum Event : String {
    case iOS_NOTIFICATION_OPEN = "iOS_notification_open" // 點擊推波開啟
    case iOS_NOTICE_OPEN = "iOS_notice_open" // 從通知開啟的
}

enum EventParameter : String {
    case item_id = "item_id"
    case item_name = "item_name"
    case source = "source"
    case item_type = "item_type"
    case item_type2 = "item_type2"
    case item_type3 = "item_type3"
    case item_number = "item_number"
    case item_number2 = "item_number2"
}
