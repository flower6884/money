//
//  UserConsumptionInfo.swift
//  Money1
//
//  Created by ruru on 2017/7/25.
//  Copyright © 2017年 ruru. All rights reserved.
//

import Foundation

class UserConsumptionInfo {
    var item:String = ""
    var date:String = ""
    var time:String = ""
    var image:String = ""
    var amount:Int = 0
    
    init(item:String, date:String, time:String, image:String, amount:Int) {
        self.item = item
        self.date = date
        self.time = time
        self.image = image
        self.amount = amount
    }
}
