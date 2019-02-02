//
//  Enum.swift
//  smallcase
//
//  Created by Siddharth Paneri on 02/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation

enum RequestType: String {
    case getSmallcaseDetailData = "/smallcase"
    case getHistoricalData = "/historical"
}

enum Duration : String {
    case _1m = "1m"
    case _6m = "6m"
    case _1y = "1y"
    case _2y = "2y"
    case _3y = "3y"
    case _4y = "4y"
}
